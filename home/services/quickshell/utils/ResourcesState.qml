pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int cpu_percent
    property string cpu_freq
    property int mem_percent
    property string mem_used

    Process {
        id: process_cpu_percent
        running: true
        command: ["sh", "-c", "top -bn1 | rg '%Cpu' | awk '{print 100-$8}'"]
        stdout: SplitParser {
            onRead: data => root.cpu_percent = Math.round(data)
        }
    }

    Process {
        id: process_cpu_freq
        running: true
        command: ["sh", "-c", "lscpu --parse=MHZ"]
        stdout: StdioCollector {
            id: collector
            onStreamFinished: () => {
                const data = collector.text
                // delete the first 4 lines (comments)
                const mhz = data.split("\n").slice(4);
                // compute mean frequency
                const total = mhz.reduce((acc, e) => acc + Number(e), 0)
                const freq = total / mhz.length;

                root.cpu_freq = Math.round(freq) + " MHz";
            }
        }
    }

    Process {
        id: process_mem_percent
        running: true
        command: ["sh", "-c", "free | awk 'NR==2{print $3/$2*100}'"]
        stdout: SplitParser {
            onRead: data => root.mem_percent = Math.round(data)
        }
    }

    Process {
        id: process_mem_used
        running: true
        command: ["sh", "-c", "free --si -h | awk 'NR==2{print $3}'"]
        stdout: SplitParser {
            onRead: data => root.mem_used = data
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: () => {
            process_cpu_percent.running = true
            process_cpu_freq.running = true
            process_mem_percent.running = true
            process_mem_used.running = true
        }
    }
}
