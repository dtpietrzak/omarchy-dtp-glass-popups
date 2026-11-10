import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons as Commons

// Makes the bar's flyouts follow the bar's look. The flyouts read their
// background from the shell's `[popups]` color tokens, which a theme sets once;
// the bar's look (glassy, opaque or clear) is picked at run time in shell.json.
// This watches that choice and sets the flyouts' `background-alpha` to match,
// the way the dtp cards do: see-through when glassy, solid otherwise.
Item {
  id: root

  property var shell: null
  readonly property real glassAlpha: 0.35
  property string look: "opaque"
  readonly property string wanted: look === "glassy" ? String(glassAlpha) : "1"

  function apply() {
    var color = Commons.Color
    var values = {}
    for (var key in color.userShellValues) values[key] = color.userShellValues[key]
    if (values["popups.background-alpha"] === root.wanted) return
    values["popups.background-alpha"] = root.wanted
    color.userShellValues = values
    color.mergeShell()
  }

  function readLook(raw) {
    var config = null
    try { config = JSON.parse(String(raw || "")) } catch (e) { config = null }
    var bar = config && config.bar ? config.bar : {}
    root.look = bar.background || (bar.transparent === true ? "none" : "opaque")
    root.apply()
  }

  onWantedChanged: apply()

  // The shell rebuilds its values whenever the user's shell.toml or the theme
  // is read again, which drops this setting. Put it back.
  Connections {
    target: Commons.Color
    function onUserShellValuesChanged() { root.apply() }
    function onThemeShellValuesChanged() { root.apply() }
  }

  FileView {
    path: Quickshell.env("HOME") + "/.config/omarchy/shell.json"
    watchChanges: true
    printErrors: false
    onLoaded: root.readLook(text())
    onFileChanged: reload()
  }

  function setUpHyprland() {
    var path = decodeURIComponent(String(Qt.resolvedUrl("hypr/popups.lua")).replace(/^file:\/\//, ""))
    Hyprland.dispatch('(function() dofile(' + JSON.stringify(path) + ') end)')
  }
  // After a reload, once Hyprland has loaded the bar's own rule for the same
  // layer, so this one lands on top of it.
  Timer {
    id: settle
    interval: 400
    onTriggered: root.setUpHyprland()
  }
  Component.onCompleted: settle.start()
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "configreloaded") settle.restart()
    }
  }
}
