require "string"

function checkBluetoothResult(rc, stdout, stderr)
    if rc ~= 0 then
        print(string.format("Unexpected result executing `blueutil`: rc=%d stderr=%s stdout=%s", rc, stderr, stdout))
    end
end

local function blueutil_path()
    local candidates = {
        "/opt/homebrew/bin/blueutil",
        "/usr/local/bin/blueutil",
    }
    for _, path in ipairs(candidates) do
        if hs.fs.attributes(path) then
            return path
        end
    end
    return nil
end

function bluetooth(power)
    local bin = blueutil_path()
    if not bin then
        print("blueutil not found under /opt/homebrew or /usr/local")
        return
    end
    print("Using `blueutil` to set bluetooth to " .. power)
    local t = hs.task.new(bin, checkBluetoothResult, {"--power", power})
    t:start()
end

function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        bluetooth("off")
    elseif event == hs.caffeinate.watcher.screensDidWake then
        bluetooth("on")
    end
end

watcher = hs.caffeinate.watcher.new(f)
watcher:start()
