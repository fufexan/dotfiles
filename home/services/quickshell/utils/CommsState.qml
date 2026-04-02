pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

// Stolen and modified from @anasgets on the Quickshell Discord server.

Singleton {
    id: root

    property bool cameraActiveRaw: false

    readonly property bool microphoneActive: {
        const nodes = Pipewire.ready ? (Pipewire.nodes?.values || []) : [];
        return nodes.some(n => n && (n.type & PwNodeType.AudioInStream) === PwNodeType.AudioInStream && !isSystemVirtualMic(n) && !(n.audio && n.audio.muted));
    }

    readonly property bool microphoneMuted: {
        return PipeWireState.defaultSource?.audio.muted ?? false;
    }

    readonly property bool cameraActive: {
        const nodes = Pipewire.ready ? (Pipewire.nodes?.values || []) : [];
        if (nodes.length === 0)
            return false;

        const links = Pipewire.links?.values || [];
        const isActiveLink = l => {
            const s = String(l?.state || l?.info?.state || "").toLowerCase();
            return l?.active === true || /active|running|connected|streaming|live|started/.test(s);
        };

        const hasVideoPort = n => {
            const ports = n?.ports ? (n.ports.values || []) : [];
            return ports.some(p => {
                const props = p?.properties || {};
                const media = String(props["media.class"] || props["port.media.class"] || "").toLowerCase();
                const dsp = String(props["format.dsp.media-type"] || props["format.media-type"] || "").toLowerCase();
                const cat = String(props["port.category"] || "").toLowerCase();
                return media.includes("video") || dsp.includes("video") || cat.includes("capture");
            });
        };

        const hasActiveVideoLink = n => links.some(l => (l?.outputNodeId === n?.id || l?.inputNodeId === n?.id) && isActiveLink(l));

        const activeState = n => {
            const live = String(prop(n, "stream.is-live") || prop(n, "stream.active") || prop(n, "device.active")).toLowerCase();
            const state = String(n?.state || prop(n, "node.state") || "").toLowerCase();
            return live === "true" || live === "1" || state === "running" || n?.ready === true || hasVideoPort(n) || hasActiveVideoLink(n);
        };

        const pwCamera = nodes.some(n => n && (n.type & PwNodeType.VideoSource) === PwNodeType.VideoSource && !isScreencast(n) && activeState(n));

        return pwCamera || root.cameraActiveRaw;
    }

    readonly property bool screensharingActive: {
        const nodes = Pipewire.ready ? (Pipewire.nodes?.values || []) : [];
        if (nodes.length === 0)
            return false;

        const videoScreencast = nodes.some(n => n && (n.type & PwNodeType.VideoSource) === PwNodeType.VideoSource && isScreencast(n));

        if (videoScreencast)
            return true;

        // Some portals/apps expose an audio input stream alongside desktop capture
        return nodes.some(n => {
            if (!n)
                return false;
            if ((n.properties || {})["media.class"] !== "Stream/Input/Audio")
                return false;

            const mediaName = String(prop(n, "media.name")).toLowerCase();
            const appName = String(prop(n, "application.name")).toLowerCase();
            const live = String(prop(n, "stream.is-live")).toLowerCase() === "true";
            const muted = !!(n.audio && n.audio.muted);

            const looksLikeDesktop = mediaName.includes("desktop") || appName.includes("screen") || appName === "obs";
            return live && looksLikeDesktop && !muted;
        });
    }

    // Helpers
    function isSystemVirtualMic(node) {
        if (!node)
            return false;
        const name = String(node.name || "").toLowerCase();
        const mediaName = String(prop(node, "media.name")).toLowerCase();
        const appName = String(prop(node, "application.name")).toLowerCase();
        const text = name + " " + mediaName + " " + appName;
        return /cava|monitor|system|effect_input.rnnoise|pulseaudio volume control/.test(text);
    }

    function isScreencast(node) {
        if (!node)
            return false;
        const appName = String(prop(node, "application.name")).toLowerCase();
        const nodeName = String(node.name || "").toLowerCase();
        const text = appName + " " + nodeName;
        return /xdg-desktop-portal|xdpw|screencast|screen|gnome shell|kwin|obs/.test(text);
    }

    function prop(node, key) {
        if (!node)
            return "<unset>";
        const p = node.properties || {};
        if (p[key] !== undefined && p[key] !== null && p[key] !== "")
            return p[key];

        const g = node.globalProperties || {};
        if (g[key] !== undefined && g[key] !== null && g[key] !== "")
            return g[key];

        const info = node.info && (node.info.properties || node.info.props || node.info.propertiesMap);
        if (info && info[key] !== undefined && info[key] !== null && info[key] !== "")
            return info[key];

        const meta = node.metadata || {};
        if (meta[key] !== undefined && meta[key] !== null && meta[key] !== "")
            return meta[key];

        return "<unset>";
    }

    // Check whether cameras exist so we know whether to start polling
    Process {
        running: true
        command: ["sh", "-c", "ls -1 /dev/video*"]
        stdout: StdioCollector {
            onStreamFinished: () => {
                if (text != "") {
                    cameraCheckTimer.repeat = true;
                    cameraCheckTimer.running = true;
                }
            }
        }
    }

    Timer {
        id: cameraCheckTimer
        interval: 1000
        running: false
        onTriggered: cameraCheckProcess.running = true
    }

    Process {
        id: cameraCheckProcess
        running: true
        // Currently using /dev/video0. On my `io` machine /dev/video2 is the
        // infrared camera, which is only used by Howdy for facial auth.
        // I don't wanna poll that since it'll trigger the camera indicator for
        // a bit right after unlocking the screen.
        command: ["sh", "-c", "lsof /dev/video0 >/dev/null"]
        onExited: (exitCode, exitStatus) => root.cameraActiveRaw = exitCode == 0
    }
}
