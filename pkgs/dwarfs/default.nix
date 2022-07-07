{
  stdenv,
  boost,
  bison,
  double-conversion,
  cmake,
  lib,
  git,
  fetchFromGitHub,
  fmt_8,
  fuse3,
  gflags,
  glog,
  jemalloc,
  libarchive,
  libdwarf,
  libevent,
  libunwind,
  lz4,
  openssl,
  ronn,
  xxHash,
  xz,
  zstd,
  pkgconfig,
}:
stdenv.mkDerivation rec {
  pname = "dwarfs";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-bGJkgcq8JxueRTX08QpJv1A0O5wXbiIgUY7BrY0Ln/M=";
  };

  # Needs tagged git repo for generating some files
  # leaveDotGit alone isn't enough and breaks reproducible hashing
  preConfigure = ''
    git init
    git add .
    git -c user.name=root -c user.email=root@localhost commit -m "v${version}" -q
    git -c user.name=root -c user.email=root@localhost tag "v${version}" -m "v${version}"
  '';

  # ...but the files are still kinda ugly, so let's make the data prettier for wherever it gets used ;)
  postConfigure = ''
    sed -i \
      -e 's/\(PRJ_GIT_REV = \).*/\1"${src.rev}";/' \
      -e 's/\(PRJ_GIT_DESC = \).*/\1"${version}";/' \
      -e 's/\(PRJ_GIT_BRANCH = \).*/\1"${src.rev}";/' \
      -e 's/\(PRJ_GIT_ID = \).*/\1"${version} from Nixpkgs :)";/' \
      ../src/dwarfs/version.cpp
  '';

  cmakeFlags = [
    "-DPREFER_SYSTEM_ZSTD=ON"
    "-DPREFER_SYSTEM_XXHASH=ON"
  ];

  nativeBuildInputs = [
    bison
    cmake
    ronn
    fmt_8
    git
    boost.dev
    libevent.dev
    libdwarf.dev
    pkgconfig
  ];

  buildInputs = [
    fuse3
    openssl
    boost
    jemalloc
    xxHash
    lz4
    xz
    zstd
    libarchive
    libunwind
    fmt_8
    glog
    gflags
    double-conversion
  ];
}
