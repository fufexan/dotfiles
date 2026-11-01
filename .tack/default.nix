# SPDX-License-Identifier: EUPL-1.2
# tack-managed resolver. delete this line to take ownership; tack will leave it alone afterwards.
# tack-resolver: patched tag version signedBy

let
  inherit (builtins)
    addErrorContext
    all
    attrNames
    attrValues
    concatMap
    any
    elem
    elemAt
    filter
    foldl'
    fromJSON
    hashFile
    head
    intersectAttrs
    isAttrs
    isList
    isString
    listToAttrs
    mapAttrs
    match
    pathExists
    readFile
    removeAttrs
    split
    stringLength
    substring
    tail
    trace
    ;

  validateInputNames =
    { value, location }:
    if !isList value || any (name: !isString name) value then
      throw "tack: ${location} must be an array of strings"
    else
      value;

  knownTypes = [
    "github"
    "gitlab"
    "git"
    "tarball"
    "path"
    "indirect"
  ];

  # fetchTree's lastModifiedDate, YYYYMMDDHHMMSS in UTC
  formatEpoch =
    secs:
    let
      days = secs / 86400;
      daySecs = secs - days * 86400;
      shifted = days + 719468;
      era = shifted / 146097;
      dayOfEra = shifted - era * 146097;
      yearOfEra = (dayOfEra - dayOfEra / 1460 + dayOfEra / 36524 - dayOfEra / 146096) / 365;
      dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra / 4 - yearOfEra / 100);
      marchMonth = (5 * dayOfYear + 2) / 153;
      day = dayOfYear - (153 * marchMonth + 2) / 5 + 1;
      month = if marchMonth < 10 then marchMonth + 3 else marchMonth - 9;
      year = yearOfEra + era * 400 + (if month <= 2 then 1 else 0);
      pad = n: if n < 10 then "0${toString n}" else toString n;
    in
    "${toString year}${pad month}${pad day}${pad (daySecs / 3600)}${
      pad (daySecs / 60 - daySecs / 3600 * 60)
    }${pad (daySecs - daySecs / 60 * 60)}";

  fetchTreeAttrs = {
    type = null;
    owner = null;
    repo = null;
    host = null;
    url = null;
    id = null;
    ref = null;
    rev = null;
    narHash = null;
    lastModified = null;
    revCount = null;
    submodules = null;
    shallow = null;
    allRefs = null;
    name = null;
    lfs = null;
    exportIgnore = null;
    verifyCommit = null;
    keytype = null;
    publicKey = null;
    publicKeys = null;
    dirtyRev = null;
    dirtyShortRev = null;
    unpack = null;
    treeHash = null;
  };

  call =
    {
      overrides ? { },
      resolverDir ? ./.,
    }:
    let
      pins = fromTOML (readFile (resolverDir + "/pins.toml"));
      lock = fromJSON (readFile (resolverDir + "/pins.lock.json"));
      declared =
        if pins.inputs or { } ? _meta then
          throw "tack: '_meta' is reserved by tack, rename that input"
        else
          pins.inputs or { };
      all_follow_raw = pins.all_follow or { };
      # tackOverrides carries this reserved entry across nested resolver boundaries
      inheritedPolicy = overrides.__tack_policy or { };
      inheritedFollows = inheritedPolicy.follows or { };
      inheritedFollowMeta = inheritedPolicy.followMeta or { };
      inheritedOverrideMeta = inheritedPolicy.meta or { };
      inheritedOmitted = inheritedPolicy.omitted or [ ];
      inheritedOmitLayers = (inheritedPolicy.omit or { }).layers or [ ];
      pinOverrides = removeAttrs overrides [ "__tack_policy" ];

      all_omit_inputs =
        if !(pins ? omit_inputs) then
          [ ]
        else if !isAttrs pins.omit_inputs then
          throw "tack: omit_inputs must be a table with a names array"
        else
          validateInputNames {
            value = pins.omit_inputs.names or [ ];
            location = "omit_inputs.names";
          };

      checkFollowKeys =
        { follows, location }:
        let
          scopedName = key: match "(flake|tack):(.*)" key;
          clashes = filter (key: scopedName key != null && follows ? ${elemAt (scopedName key) 1}) (
            attrNames follows
          );
          clash = head clashes;
        in
        if clashes == [ ] then
          follows
        else
          throw "tack: ${location} has both '${elemAt (scopedName clash) 1}' and '${clash}', keep only one";

      # flatten `target = [aliases]` rows alongside `alias = "target"` rows
      all_follow = listToAttrs (
        concatMap (
          key:
          let
            val = all_follow_raw.${key};
          in
          if isList val then
            [
              {
                name = key;
                value = key;
              }
            ]
            ++ map (a: {
              name = a;
              value = key;
            }) val
          else if isString val then
            [
              {
                name = key;
                value = val;
              }
            ]
          else
            [ ]
        ) (attrNames all_follow_raw)
      );

      # path nodes are convenience pins, so return the live local path directly
      # because fetchTree rejects unlocked paths in pure eval
      fetchPin =
        name:
        if !(lock ? ${name}) then
          throw "tack: pin '${name}' has no lock entry; run tack update"
        else
          let
            node = lock.${name};
            type = node.type or "";
          in
          if type == "path" then
            {
              outPath = if substring 0 1 node.path == "/" then node.path else resolverDir + ("/" + node.path);
              lastModified = node.lastModified or 0;
            }
            // (if node ? narHash then { inherit (node) narHash; } else { })
          # a cold fetcher cache makes fetchTree re-unpack a locked tarball into the
          # git cache even when its store path exists, fetchTarball checks the store first
          else if type == "tarball" && node ? narHash && node ? lastModified then
            {
              outPath = fetchTarball {
                inherit (node) url;
                sha256 = node.narHash;
              };
              inherit (node) narHash lastModified;
              lastModifiedDate = formatEpoch node.lastModified;
            }
            // (
              if node ? rev then
                {
                  inherit (node) rev;
                  shortRev = substring 0 7 node.rev;
                }
              else
                { }
            )
          else if !(elem type knownTypes) then
            throw "tack: unknown lock type '${type}' for pin '${name}'"
          else
            fetchTree (intersectAttrs fetchTreeAttrs node);

      fetchFixed =
        { name, entry }:
        let
          raw = derivation {
            inherit name;
            inherit (entry) url;
            builder = "builtin:fetchurl";
            system = "builtin";
            outputHash = entry.sha256;
            outputHashAlgo = "sha256";
            outputHashMode = "flat";
          };
          unpacked = derivation {
            inherit name;
            builder = "builtin:unpack-channel";
            system = "builtin";
            src = raw;
            channelName = name;
          };
        in
        if (entry.unpack or "file") == "tarball" then unpacked.outPath + "/" + name else raw.outPath;

      # tack builds patched trees and adds them to the store, so eval only
      # fetches a locked path and never builds
      fetchPatched =
        { name, pin }:
        let
          node = lock.${name} or { };
          tree =
            node.patched
              or (throw "tack: pin '${name}' has patches but no patched tree, run tack update ${name}");
          vendored =
            digest:
            let
              file = resolverDir + "/${digest.file}";
            in
            if pathExists file then
              file
            else
              throw "tack: patch ${digest.file} for pin '${name}' is missing, if this is a flake make sure it is tracked by git (git add .tack/patches)";
          current =
            map (digest: digest.source) tree.patches == pin.patches
            && all (digest: hashFile "sha256" (vendored digest) == digest.sha256) tree.patches;
          fetched =
            addErrorContext
              "tack: could not read the patched tree of '${name}', run tack materialize ${name}, or tack update ${name} if the lock was edited by hand"
              (
                fetchTree (
                  {
                    type = "path";
                    inherit (tree) path narHash;
                  }
                  // (if tree ? lastModified then { inherit (tree) lastModified; } else { })
                )
              );
        in
        if !current then
          throw "tack: patches for '${name}' changed since the lock was written, run tack update ${name}"
        else
          fetched
          // (
            if node ? rev then
              {
                dirtyRev = node.rev + "-dirty";
                dirtyShortRev = substring 0 7 node.rev + "-dirty";
              }
            else
              { }
          );

      metaFields = {
        github = [
          "owner"
          "repo"
          "host"
          "tag"
          "version"
          "rev"
          "narHash"
          "lastModified"
        ];
        gitlab = [
          "owner"
          "repo"
          "host"
          "tag"
          "version"
          "rev"
          "narHash"
          "lastModified"
        ];
        git = [
          "url"
          "ref"
          "tag"
          "version"
          "rev"
          "narHash"
          "lastModified"
        ];
        tarball = [
          "url"
          "rev"
          "narHash"
          "lastModified"
        ];
        indirect = [ "id" ];
        path = [
          "path"
          "narHash"
          "lastModified"
        ];
        fixed = [
          "url"
          "tag"
          "version"
          "sha256"
          "unpack"
        ];
      };
      metaDefaults = {
        github.host = "github.com";
        gitlab.host = "gitlab.com";
        fixed.unpack = "file";
      };
      lockedFields = {
        rev = null;
        narHash = null;
        lastModified = null;
      };

      # indirect entries lock only an id, so their revision comes from the registry fetch
      pinMeta =
        name:
        let
          entry = lock.${name} or (throw "tack: pin '${name}' has no lock entry; run tack update");
          type = entry.type or "unknown";
          fields = listToAttrs (
            map (field: {
              name = field;
              value = null;
            }) (metaFields.${type} or [ ])
          );
          fetched = if type == "indirect" then intersectAttrs lockedFields (fetchPin name) else { };
        in
        (metaDefaults.${type} or { }) // intersectAttrs fields entry // fetched // { inherit type; };

      resolveFollowMeta = mapAttrs (_: target: selfMeta.${target} or { type = "upstream"; });

      resolveSpec =
        { upLock, spec }:
        if isList spec then
          walkPath {
            inherit upLock;
            nodeName = upLock.root;
            path = spec;
          }
        else
          spec;

      walkPath =
        {
          upLock,
          nodeName,
          path,
        }:
        if path == [ ] then
          nodeName
        else if !(upLock.nodes ? ${nodeName}) then
          throw "tack: follows path dead-end: no node '${nodeName}' in flake.lock"
        else
          let
            key = head path;
            inputs = upLock.nodes.${nodeName}.inputs or { };
          in
          if !(inputs ? ${key}) then
            throw "tack: follows path dead-end: node '${nodeName}' has no input '${key}'"
          else
            walkPath {
              inherit upLock;
              nodeName = resolveSpec {
                inherit upLock;
                spec = inputs.${key};
              };
              path = tail path;
            };

      followsFor =
        { name, pin }:
        let
          # a rule into this pin's own inputs would make that input follow itself
          prefix = name + "/";
          intoSelf = filter (k: substring 0 (stringLength prefix) all_follow.${k} == prefix) (
            attrNames all_follow
          );
        in
        {
          level = {
            global = removeAttrs all_follow intoSelf;
            # other pins follow these, so an omit must not throw them away
            selfFollowed = map (
              key:
              let
                m = match "(flake|tack):(.*)" key;
              in
              if m == null then key else elemAt m 1
            ) intoSelf;
            local = pin.follows or { };
            localLocation = "inputs.${name}.follows";
            excluded = pin.exclude_follow or [ ];
            inherited = inheritedFollows;
            inheritedMeta = inheritedFollowMeta;
          };
          deep = {
            global = all_follow;
            local = { };
            localLocation = "inputs.${name}.follows";
            excluded = pin.exclude_follow or [ ];
            inherited = inheritedFollows;
            inheritedMeta = inheritedFollowMeta;
          };
        };

      matchesInput =
        {
          rules,
          side,
          name,
        }:
        any (rule: rule == "*" || rule == name || rule == "${side}:*" || rule == "${side}:${name}") rules;

      omitsFor =
        { name, pin }:
        let
          localOmitted = validateInputNames {
            value = pin.omit_inputs or [ ];
            location = "inputs.${name}.omit_inputs";
          };
          localKept = validateInputNames {
            value = pin.keep_inputs or [ ];
            location = "inputs.${name}.keep_inputs";
          };
        in
        builtins.deepSeq localOmitted (
          builtins.deepSeq localKept {
            layers = inheritedOmitLayers ++ [
              {
                omitted = all_omit_inputs ++ localOmitted;
                kept = localKept;
              }
            ];
          }
        );

      # layers run outermost first and a keep only cancels omits from its own
      # layer or deeper, so a nested project cannot undo its consumer's omit
      shouldOmit =
        {
          omit,
          side,
          name,
        }:
        let
          go =
            layers:
            layers != [ ]
            && !(matchesInput {
              rules = (head layers).kept;
              inherit side name;
            })
            && (
              matchesInput {
                rules = (head layers).omitted;
                inherit side name;
              }
              || go (tail layers)
            );
        in
        go omit.layers;

      omittedInput =
        { side, name }:
        throw "tack: ${side} input '${name}' was omitted by omit_inputs";

      # `pin/input/...` walks the inputs that pin was evaluated with, as a flake.nix follows does
      resolveFollows = mapAttrs (
        _: target:
        let
          path = filter isString (split "/" target);
          pin = self.${head path} or (throw "tack: follows target '${head path}' is not a pin");
        in
        foldl' (
          node: key:
          (node.inputs or { }).${key} or (throw "tack: follows target '${target}' has no input '${key}'")
        ) pin (tail path)
      );

      # follow keys are `flake:name`, `tack:name`, or bare `name`
      # project onto one side, rekeyed to bare names; exclusions apply only
      # to global follows, before level-local follows are merged over them
      projectFollows =
        {
          side,
          follows,
          location,
          excluded ? [ ],
        }:
        let
          checked = checkFollowKeys { inherit follows location; };
        in
        listToAttrs (
          concatMap (
            key:
            let
              m = match "(flake|tack):(.*)" key;
            in
            if
              m == null
              && !(matchesInput {
                rules = excluded;
                inherit side;
                name = key;
              })
            then
              [
                {
                  name = key;
                  value = follows.${key};
                }
              ]
            else if
              m != null
              && head m == side
              && !(matchesInput {
                rules = excluded;
                inherit side;
                name = elemAt m 1;
              })
            then
              [
                {
                  name = elemAt m 1;
                  value = follows.${key};
                }
              ]
            else
              [ ]
          ) (attrNames checked)
        );

      followLayersForSide =
        {
          side,
          policy,
          resolve,
          inherited,
        }:
        resolve (projectFollows {
          inherit side;
          follows = policy.global;
          location = "all_follow";
          excluded = policy.excluded;
        })
        // resolve (projectFollows {
          inherit side;
          follows = policy.local;
          location = policy.localLocation;
        })
        // projectFollows {
          inherit side;
          follows = inherited;
          location = "inherited follows";
        };

      followOverridesForSide =
        { side, policy }:
        followLayersForSide {
          inherit side policy;
          resolve = resolveFollows;
          inherited = policy.inherited;
        };

      followMetaForSide =
        { side, policy }:
        followLayersForSide {
          inherit side policy;
          resolve = resolveFollowMeta;
          inherited = policy.inheritedMeta;
        };

      scopedFollowValues =
        side: values:
        listToAttrs (
          map (name: {
            name = "${side}:${name}";
            value = values.${name};
          }) (attrNames values)
        );

      propagatedPolicy =
        {
          omit,
          follows,
          omitted,
          meta,
        }:
        let
          followValues =
            scopedFollowValues "flake" (followOverridesForSide {
              side = "flake";
              policy = follows;
            })
            // scopedFollowValues "tack" (followOverridesForSide {
              side = "tack";
              policy = follows;
            });
          active = any (layer: layer.omitted != [ ] || layer.kept != [ ]) omit.layers || followValues != { };
        in
        {
          inherit active;
          override = {
            __tack_policy = {
              inherit omit omitted meta;
              follows = followValues;
              followMeta = scopedFollowValues "tack" (followMetaForSide {
                side = "tack";
                policy = follows;
              });
            };
          };
        };

      omitOverridesFor =
        {
          side,
          inputs,
          omit,
        }:
        listToAttrs (
          map (name: {
            inherit name;
            value = omittedInput { inherit side name; };
          }) (filter (name: shouldOmit { inherit omit side name; }) (attrNames inputs))
        );

      tackCallFor =
        {
          dir,
          omit,
          levelFollows,
          deepFollows,
        }:
        let
          tackPinsPath = dir + "/.tack/pins.toml";
          hasTack = pathExists tackPinsPath;
          upPins = if hasTack then fromTOML (readFile tackPinsPath) else { };
          tackInputs = upPins.inputs or { };
          tackOverrides = intersectAttrs tackInputs (followOverridesForSide {
            side = "tack";
            policy = levelFollows;
          });
          tackOmitOverrides = omitOverridesFor {
            side = "tack";
            inputs = tackInputs;
            inherit omit;
          };
          effectiveTackOverrides = tackOmitOverrides // tackOverrides;
          propagated = propagatedPolicy {
            inherit omit;
            follows = deepFollows;
            omitted = attrNames (removeAttrs tackOmitOverrides (attrNames tackOverrides));
            meta = intersectAttrs tackInputs (followMetaForSide {
              side = "tack";
              policy = levelFollows;
            });
          };
          supportsOverrides = (upPins.tack or { }).recomposable or false;
          direct = effectiveTackOverrides != { };
          needed = direct || propagated.active;
          # policy for deeper levels may match nothing below, so only a direct override warns
          blocked = hasTack && direct && !supportsOverrides;
        in
        {
          inherit supportsOverrides direct needed;
          overrides = effectiveTackOverrides // propagated.override;
          report =
            value:
            if blocked then
              trace "tack: ${dir}: not marked recomposable (set [tack] recomposable = true); overrides will not reach upstream" value
            else
              value;
        };

      mkCallerInputs =
        {
          upLock,
          nodeName,
          rawInputs,
          levelOverrides,
          selfFollowed,
          rootInputs,
          deepFollows,
          omit,
        }:
        mapAttrs (
          n: _decl:
          levelOverrides.${n} or (
            if
              !(elem n selfFollowed)
              && shouldOmit {
                inherit omit;
                side = "flake";
                name = n;
              }
            then
              omittedInput {
                side = "flake";
                name = n;
              }
            else if upLock != null then
              let
                ref =
                  (upLock.nodes.${nodeName}.inputs or { }).${n}
                    or (throw "tack: input '${n}' declared but not in flake.lock node '${nodeName}'");
                # a lock follows path names the root's input, which may itself be followed or omitted
                followed = foldl' (
                  value: key:
                  (value.inputs or { }).${key}
                    or (throw "tack: follows path dead-end: no input '${key}' along ${toString ref}")
                ) rootInputs.${head ref} (tail ref);
                childName = resolveSpec {
                  inherit upLock;
                  spec = ref;
                };
                childNode = upLock.nodes.${childName};
                childSrc = fetchTree childNode.locked;
              in
              if isList ref && ref != [ ] then
                followed
              else if childNode.flake or true then
                evalTransitive {
                  inherit upLock rootInputs omit;
                  nodeName = childName;
                  sourceInfo = childSrc;
                  follows = deepFollows;
                }
              else
                childSrc
            else
              throw "tack: no flake.lock; cannot resolve input '${n}'"
          )
        ) rawInputs;

      mkFlakeResult =
        {
          sourceInfo,
          flakeDir,
          callerInputs,
          outputs,
        }:
        outputs
        // sourceInfo
        // {
          outPath = flakeDir;
          inputs = callerInputs;
          inherit outputs sourceInfo;
          _type = "flake";
        };

      evalFlake =
        {
          sourceInfo,
          flakeDir,
          upLock,
          nodeName,
          levelFollows,
          deepFollows,
          omit,
          rootInputs ? null,
        }:
        let
          raw = import (flakeDir + "/flake.nix");

          # project follows onto each side, keep only names that side has
          # bare follow reaches both; `flake:`/`tack:` reaches just one
          tackCall = tackCallFor {
            dir = flakeDir;
            inherit omit levelFollows deepFollows;
          };
          flakeLevel = intersectAttrs (raw.inputs or { }) (followOverridesForSide {
            side = "flake";
            policy = levelFollows;
          });

          # deep follows pass down raw, so each descendant re-projects per side
          callerInputs = mkCallerInputs {
            inherit
              upLock
              nodeName
              deepFollows
              omit
              ;
            rawInputs = raw.inputs or { };
            levelOverrides = flakeLevel;
            selfFollowed = levelFollows.selfFollowed or [ ];
            rootInputs = if rootInputs == null then callerInputs else rootInputs;
          };

          # upstream declares its outputs forward tackOverrides; a closed `{ self }:`
          # would throw on the extra kwarg, so forward only when declared
          extraArgs =
            if tackCall.supportsOverrides && tackCall.needed then
              { tackOverrides = tackCall.overrides; }
            else
              { };

          outputs = raw.outputs (callerInputs // extraArgs // { self = result; });

          result = tackCall.report (mkFlakeResult {
            inherit
              sourceInfo
              flakeDir
              callerInputs
              outputs
              ;
          });
        in
        result;

      evalTransitive =
        {
          upLock,
          nodeName,
          sourceInfo,
          follows,
          omit,
          rootInputs,
        }:
        evalFlake {
          inherit
            upLock
            nodeName
            sourceInfo
            omit
            rootInputs
            ;
          flakeDir = sourceInfo.outPath;
          levelFollows = follows;
          deepFollows = follows;
        };

      evalTopFlake =
        {
          sourceInfo,
          name,
          pin,
          omit,
        }:
        let
          flakeDir = sourceInfo.outPath + (if pin ? dir then "/" + pin.dir else "");
          upLockPath = flakeDir + "/flake.lock";
          upLock = if pathExists upLockPath then fromJSON (readFile upLockPath) else null;
          rootNode = if upLock != null then upLock.root else null;
          f = followsFor { inherit name pin; };
        in
        builtins.seq omit (evalFlake {
          inherit
            sourceInfo
            flakeDir
            upLock
            omit
            ;
          nodeName = rootNode;
          levelFollows = f.level;
          deepFollows = f.deep;
        });

      evalFetch =
        {
          sourceInfo,
          name,
          pin,
          subdir,
          omit,
        }:
        let
          path = sourceInfo.outPath + subdir;
          f = followsFor { inherit name pin; };
          # a fetch drill-in is tack-only
          tackCall = tackCallFor {
            dir = path;
            inherit omit;
            levelFollows = f.level;
            deepFollows = f.deep;
          };
        in
        # only override tack files within a `fetch`, since there's no flake.lock
        builtins.seq omit (
          if tackCall.supportsOverrides && tackCall.needed then
            let
              upstream = import (path + "/.tack");
            in
            # old resolvers return a plain attrset, not a callable functor
            if upstream ? __functor then
              (upstream { inherit (tackCall) overrides; }) // { outPath = path; }
            else if tackCall.direct then
              trace "tack: ${path}: upstream .tack predates override support; overrides will not reach it" path
            else
              path
          else
            tackCall.report path
        );

      loadPin =
        { name, pin }:
        let
          pinType = pin.type or (if pin.flake or true then "flake" else "fetch");
          omit = omitsFor { inherit name pin; };
          follows = checkFollowKeys {
            follows = pin.follows or { };
            location = "inputs.${name}.follows";
          };
          excludeFollow = validateInputNames {
            value = pin.exclude_follow or [ ];
            location = "inputs.${name}.exclude_follow";
          };
        in
        builtins.deepSeq
          [
            omit
            follows
            excludeFollow
          ]
          (
            if pinType == "fixed" then
              fetchFixed {
                inherit name;
                entry = lock.${name};
              }
            else
              let
                sourceInfo =
                  if (pin.patches or [ ]) == [ ] then fetchPin name else fetchPatched { inherit name pin; };
                subdir = if pin ? dir then "/" + pin.dir else "";
              in
              if pinType == "flake" then
                evalTopFlake {
                  inherit
                    sourceInfo
                    name
                    pin
                    omit
                    ;
                }
              else
                evalFetch {
                  inherit
                    sourceInfo
                    name
                    pin
                    subdir
                    omit
                    ;
                }
          );

      # undeclared lock entries are synthesised into toplevels by auto-dedup
      # only when referenced as [all_follow] targets
      autoTargets = listToAttrs (
        map (target: {
          name = target;
          value = true;
        }) (attrValues all_follow)
      );
      autoNames = filter (n: !(declared ? ${n}) && autoTargets ? ${n}) (attrNames lock);
      autoPin =
        name:
        let
          sourceInfo = fetchPin name;
          pin = { };
          omit = omitsFor { inherit name pin; };
        in
        if pathExists (sourceInfo.outPath + "/flake.nix") then
          evalTopFlake {
            inherit
              sourceInfo
              name
              pin
              omit
              ;
          }
        else
          sourceInfo;

      self =
        (mapAttrs (name: pin: loadPin { inherit name pin; }) declared)
        // listToAttrs (
          map (name: {
            inherit name;
            value = autoPin name;
          }) autoNames
        )
        // pinOverrides;

      selfMeta = removeAttrs (
        mapAttrs (name: _: pinMeta name) (removeAttrs self (attrNames pinOverrides))
        // mapAttrs (name: _: inheritedOverrideMeta.${name} or { type = "upstream"; }) pinOverrides
      ) inheritedOmitted;
    in
    builtins.seq all_omit_inputs (
      builtins.seq
        (checkFollowKeys {
          follows = all_follow;
          location = "all_follow";
        })
        (
          self
          // {
            _meta = selfMeta;
            __functor = _: args: call ({ inherit resolverDir; } // args);
          }
        )
    );
in
call { }
