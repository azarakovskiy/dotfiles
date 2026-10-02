majorMash = {"cmd", "alt", "ctrl"}
minorMash = {"shift", "alt", "ctrl"}

hs.loadSpoon("SpoonInstall", {
    use_syncinstall = true
})

Install=spoon.SpoonInstall

Install:andUse("Caffeine", {
    start = true, hotkeys = {
        toggle = { minorMash, "c" }
    }
})

hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({});

require("bluetooth")
