mp.add_key_binding("s", "shot-subs", function()
  local res = mp.command_native({ "screenshot", "subtitles" })
  if not res or not res.filename then
    mp.osd_message("Screenshot failed")
    return
  end

  mp.command_native_async({
    name = "subprocess",
    playback_only = false,
    args = { "sh", "-c", 'wl-copy < "$1" >/dev/null 2>&1', "_", res.filename },
  }, function(ok, r)
    mp.osd_message((ok and r.status == 0) and ("Copied " .. res.filename) or "wl-copy failed")
  end)

end)
