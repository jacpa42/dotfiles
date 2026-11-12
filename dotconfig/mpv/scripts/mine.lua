local mp = require "mp"
local opts = { command = "jacob_mine" }
require("mp.options").read_options(opts, "mine")

local function last_line(s)
    s = (s or ""):gsub("%s+$", "")
    return s:match("([^\n]*)$") or s
end

local LETTER = { sub = "s", sub2 = "s", audio = "a", video = "v" }

-- Add "--<name>-file PATH" or "--<name>-stream s:N" for one of mpv's current tracks.
-- s:N counts only that kind of track, the same way mpv numbers them, so it can't get out of step with ffmpeg.
local function add_track(args, name, kind)
    local t = mp.get_property_native("current-tracks/" .. kind)
    if not t then return false end
    if t.external then
        if name == "audio" or name == "video" then return false end   -- separate dub/video files aren't supported
        table.insert(args, "--" .. name .. "-file")
        table.insert(args, t["external-filename"])
    else
        table.insert(args, "--" .. name .. "-stream")
        table.insert(args, LETTER[kind] .. ":" .. tostring(t.id - 1))
    end
    return true
end

local function image_based(t)
    local c = (t and t.codec or ""):lower()
    return c:find("pgs") or c:find("dvd_sub") or c:find("dvb_sub") or c:find("vobsub")
end

local function mine()
    local path = mp.get_property("path")
    local time = mp.get_property_number("time-pos")
    if not path or not time then return end
    local args = { opts.command, "card", path, "--time", string.format("%.3f", time),
                   "--sub-delay", tostring(mp.get_property_number("sub-delay", 0)),
                   "--en-delay", tostring(mp.get_property_number("secondary-sub-delay",
                                          mp.get_property_number("sub-delay", 0))) }
    if image_based(mp.get_property_native("current-tracks/sub")) then
        mp.osd_message("mine: this subtitle track is image-based (PGS), so its text can't be read. "
                       .. "Load a .srt/.ass Japanese subtitle file instead.", 6)
        return
    end
    if not add_track(args, "sub", "sub") then
        mp.osd_message("mine: turn on the Japanese subtitles first", 3)
        return
    end
    if not image_based(mp.get_property_native("current-tracks/sub2")) then
        add_track(args, "en", "sub2")   -- secondary subtitles (secondary-sid), if you show English too
    end
    add_track(args, "audio", "audio")
    add_track(args, "video", "video")

    mp.osd_message("mine: making card…", 2)
    mp.command_native_async({ name = "subprocess", args = args, playback_only = false,
                              capture_stdout = true, capture_stderr = true },
        function(ok, res)
            if ok and res.status == 0 then
                mp.osd_message("mine: " .. last_line(res.stdout), 4)
            else
                local err = last_line(res and res.stderr) ~= "" and last_line(res.stderr) or (res and res.error_string) or "?"
                mp.osd_message("mine failed: " .. err, 6)
                mp.msg.error(res and res.stderr or "")
            end
        end)
end

mp.add_key_binding("ctrl+m", "mine", mine)
