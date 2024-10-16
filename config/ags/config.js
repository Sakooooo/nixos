// TODO(sako):: try to do something like this https://github.com/PartyWumpus/dotfiles/blob/7cecf39127af0818a3b0d2d8112bf03c304d1172/modules/hyprland/ags/src/main.ts
const hyprland = await Service.import("hyprland")
// const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S %b %e."'],
})

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

// function Workspaces() {
//     const activeId = hyprland.active.workspace.bind("id")
//     const workspaces = hyprland.bind("workspaces")
//         .as(ws => ws.map(({ id }) => Widget.Button({
//             on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
//             child: Widget.Label(`${id}`),
//             class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
//         })))

//     return Widget.Box({
//         class_name: "workspaces",
//         children: workspaces,
//     })
// }

const dispatch = ws => hyprland.sendMessage(`dispatch workspace ${ws}`);

export const Workspaces = () => Widget.EventBox({
    child: Widget.Box({
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            class_name: "workspace-buttons",
            attribute: i,
            // Keeps button from expanding to fit its container
            onClicked: () => dispatch(i),
            child: Widget.Box({
                class_name: "workspace-indicator",
                // vpack: "start",
                vpack: "center",
                hpack: "center",
                children: [
                    Widget.Label({
                        label: `${i}`,
                        justification: "center",
                    })
                ],
                setup: self => self.hook(hyprland, () => {
                    // The "?" is used here to return "undefined" if the workspace doesn't exist
                    self.toggleClassName('workspace-inactive', (hyprland.getWorkspace(i)?.windows || 0) === 0);
                    self.toggleClassName('workspace-occupied', (hyprland.getWorkspace(i)?.windows || 0) > 0);
                    self.toggleClassName('workspace-active', hyprland.active.workspace.id === i);
                    // self.toggleClassName('workspace-large', (hyprland.getWorkspace(i)?.windows || 0) > 1);
                }),
            }),

        })),
    }),
});


function ClientTitle() {
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("title"),
    })
}


function Clock() {
    return Widget.Label({
        class_name: "clock",
        label: date.bind(),
    })
}


// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
// function Notification() {
//     const popups = notifications.bind("popups")
//     return Widget.Box({
//         class_name: "notification",
//         visible: popups.as(p => p.length > 0),
//         children: [
//             Widget.Icon({
//                 icon: "preferences-system-notifications-symbolic",
//             }),
//             Widget.Label({
//                 label: popups.as(p => p[0]?.summary || ""),
//             }),
//         ],
//     })
// }


function Media() {
    const label = Utils.watch("", mpris, "player-changed", () => {
        if (mpris.players[0]) {
            const { track_artists, track_title } = mpris.players[0]
            return `${track_artists.join(", ")} - ${track_title}`
        } else {
            return "Nothing is playing"
        }
    })

    return Widget.Button({
        class_name: "media",
        on_primary_click: () => mpris.getPlayer("")?.playPause(),
        on_scroll_up: () => mpris.getPlayer("")?.next(),
        on_scroll_down: () => mpris.getPlayer("")?.previous(),
        child: Widget.Label({ label }),
    })
}


function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })

    const slider = Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    const volume = Widget.Label({
	label: audio.speaker.bind("volume").as((x) => `${Math.round(x * 100)}%`)
    })

    return Widget.Box({
        class_name: "volume",
        // css: "min-width: 180px",
        children: [icon, volume],
    })
}


function BatteryLabel() {
    const icons = {
        80: "full",
        50: "good",
        30: "low",
        10: "empty",
    };
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0);
    // const icon = battery.bind("percent").as(p =>
    //     `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    const percent = battery.bind("percent").as(x => x.toString()) + "%";

    function getIcon() {
	const icon = [100, 50, 30, 10].find(threshold => threshold <= battery.percent);

	return `battery-${icons[icon]}-symbolic`;
    }

    const icon = Widget.Icon({
	icon: Utils.watch(getIcon(), battery, getIcon),
    });

    return Widget.Box({
        class_name: "battery",
        visible: battery.bind("available"),
        children: [
	    icon,
	    Widget.Label({
		label: battery.bind('percent').as(x => x.toString()),
	    })
        ],
    });
}


function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
    })
}


// layout of the bar
function Left() {
    return Widget.Box({
        spacing: 8,
        children: [
            Workspaces(),
            // ClientTitle(),
        ],
    })
}

function Center() {
    return Widget.Box({
        spacing: 8,
        children: [
            Media(),
            // Notification(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [
            Volume(),
            BatteryLabel(),
            Clock(),
            SysTray(),
        ],
    })
}

function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["bottom", "left", "right"],
	margins: [0, 10, 0, 10],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}

var hostname = Utils.exec("cat /etc/hostname");
var hosts = ["sakotop", "sakopc"];

addExtraBar: if (hostname === hosts[0]) {
    break addExtraBar;
} else if (hostname === hosts[1]) {
    App.addWindow(Bar(1));
}

App.config({
    style: "./style.css",
    windows: [
        Bar(),
    ],
})

export { }
