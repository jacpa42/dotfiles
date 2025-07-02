config.load_autoconfig()

# Open youtube in separate tab
config.bind("Yt", "open -t https://youtube.com/")
# Open youtube in current tab
config.bind("yt", "open https://youtube.com/")
# Open whatsapp in separate tab
config.bind("Wa", "open -t https://web.whatsapp.com/")
# Open whatsapp in current tab
config.bind("wa", "open https://web.whatsapp.com/")
# Open chatgpt in separate tab
config.bind("Ch", "open -t https://chatgpt.com/")
# Open chatgpt in current tab
config.bind("ch", "open https://chatgpt.com/")
# Open github in current tab
config.bind("gh", "open https://github.com/")

# Open inbox 0 in current tab
config.bind("e0", "open https://mail.google.com/mail/u/0/?hl=en#inbox")
# Open inbox 0 in separate tab
config.bind("E0", "open -t https://mail.google.com/mail/u/0/?hl=en#inbox")
# Open inbox 1 in current tab
config.bind("e1", "open https://mail.google.com/mail/u/1/?hl=en#inbox")
# Open inbox 1 in separate tab
config.bind("E1", "open -t https://mail.google.com/mail/u/1/?hl=en#inbox")
# Open inbox 2 in current tab
config.bind("e2", "open https://outlook.office.com/mail/")
# Open inbox 2 in separate tab
config.bind("E2", "open -t https://outlook.office.com/mail/")
# Open inbox 3 in current tab
config.bind("e3", "open https://mail.proton.me/u/2/inbox")
# Open inbox 3 in separate tab
config.bind("E3", "open -t https://mail.proton.me/u/2/inbox")


# Open teams in current tab
config.bind("tt", "open https://teams.microsoft.com/v2/")
# Open teams in separate tab
config.bind("tT", "open -t https://teams.microsoft.com/v2/")

# Clear download notifications
config.bind("<Ctrl-f>", "download-clear ;; clear-messages")
# resource config
config.bind("<Shift-r>", "config-source")

c.fileselect.handler = "external"
c.fileselect.folder.command = ["ghostty", "-e", "yazi --chooser-file={}"]
c.fileselect.single_file.command = ["ghostty", "-e", "yazi --chooser-file={}"]
c.fileselect.multiple_files.command = ["ghostty", "-e", "yazi --chooser-file={}"]

c.tabs.position = "bottom"

c.window.hide_decoration = True
c.window.transparent = True

c.content.prefers_reduced_motion = True
c.content.pdfjs = True

# COLOURS #
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.preferred_color_scheme = "dark"

c.zoom.default = "175%"

c.hints.chars = "jfkdlspaieurow"
c.fonts.default_size = "16pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.contextmenu = c.fonts.default_family
c.fonts.prompts = c.fonts.default_family
c.fonts.tooltip = c.fonts.default_family

############# SCHEME #############

flavours = {
    "latte": {
        "rosewater": "#dc8a78", "flamingo": "#dd7878",
        "pink": "#ea76cb", "mauve": "#8839ef",
        "red": "#d20f39", "maroon": "#e64553",
        "peach": "#fe640b", "yellow": "#df8e1d",
        "green": "#40a02b", "teal": "#179299",
        "sky": "#04a5e5", "sapphire": "#209fb5",
        "blue": "#1e66f5", "lavender": "#7287fd",
        "text": "#4c4f69", "subtext1": "#5c5f77",
        "subtext0": "#6c6f85", "overlay2": "#7c7f93",
        "overlay1": "#8c8fa1", "overlay0": "#9ca0b0",
        "surface2": "#acb0be", "surface1": "#bcc0cc",
        "surface0": "#ccd0da", "base": "#eff1f5",
        "mantle": "#e6e9ef", "crust": "#dce0e8"
    },
    "frappe": {
        "rosewater": "#f2d5cf", "flamingo": "#eebebe",
        "pink": "#f4b8e4", "mauve": "#ca9ee6",
        "red": "#e78284", "maroon": "#ea999c",
        "peach": "#ef9f76", "yellow": "#e5c890",
        "green": "#a6d189", "teal": "#81c8be",
        "sky": "#99d1db", "sapphire": "#85c1dc",
        "blue": "#8caaee", "lavender": "#babbf1",
        "text": "#c6d0f5", "subtext1": "#b5bfe2",
        "subtext0": "#a5adce", "overlay2": "#949cbb",
        "overlay1": "#838ba7", "overlay0": "#737994",
        "surface2": "#626880", "surface1": "#51576d",
        "surface0": "#414559", "base": "#303446",
        "mantle": "#292c3c", "crust": "#232634"
    },
    "machiatto": {
        "rosewater": "#f4dbd6", "flamingo": "#f0c6c6",
        "pink": "#f5bde6", "mauve": "#c6a0f6",
        "red": "#ed8796", "maroon": "#ee99a0",
        "peach": "#f5a97f", "yellow": "#eed49f",
        "green": "#a6da95", "teal": "#8bd5ca",
        "sky": "#91d7e3", "sapphire": "#7dc4e4",
        "blue": "#8aadf4", "lavender": "#b7bdf8",
        "text": "#cad3f5", "subtext1": "#b8c0e0",
        "subtext0": "#a5adcb", "overlay2": "#939ab7",
        "overlay1": "#8087a2", "overlay0": "#6e738d",
        "surface2": "#5b6078", "surface1": "#494d64",
        "surface0": "#363a4f", "base": "#24273a",
        "mantle": "#1e2030", "crust": "#181926"
    },
    "mocha": {
        "rosewater": "#f5e0dc", "flamingo": "#f2cdcd",
        "pink": "#f5c2e7", "mauve": "#cba6f7",
        "red": "#f38ba8", "maroon": "#eba0ac",
        "peach": "#fab387", "yellow": "#f9e2af",
        "green": "#a6e3a1", "teal": "#94e2d5",
        "sky": "#89dceb", "sapphire": "#74c7ec",
        "blue": "#89b4fa", "lavender": "#b4befe",
        "text": "#cdd6f4", "subtext1": "#bac2de",
        "subtext0": "#a6adc8", "overlay2": "#9399b2",
        "overlay1": "#7f849c", "overlay0": "#6c7086",
        "surface2": "#585b70", "surface1": "#45475a",
        "surface0": "#313244", "base": "#1e1e2e",
        "mantle": "#181825", "crust": "#11111b"
    }
}

samecolorrows = True
palette = flavours["mocha"]

c.colors.completion.category.bg = palette["base"]
c.colors.completion.category.border.bottom = palette["mantle"]
c.colors.completion.category.border.top = palette["overlay2"]
c.colors.completion.category.fg = palette["green"]
if samecolorrows:
    c.colors.completion.even.bg = palette["mantle"]
    c.colors.completion.odd.bg = c.colors.completion.even.bg
else:
    c.colors.completion.even.bg = palette["mantle"]
    c.colors.completion.odd.bg = palette["crust"]
c.colors.completion.fg = palette["subtext0"]
c.colors.completion.item.selected.bg = palette["surface2"]
c.colors.completion.item.selected.border.bottom = palette["surface2"]
c.colors.completion.item.selected.border.top = palette["surface2"]
c.colors.completion.item.selected.fg = palette["text"]
c.colors.completion.item.selected.match.fg = palette["rosewater"]
c.colors.completion.match.fg = palette["text"]
c.colors.completion.scrollbar.bg = palette["crust"]
c.colors.completion.scrollbar.fg = palette["surface2"]

c.colors.downloads.bar.bg = palette["base"]
c.colors.downloads.error.bg = palette["base"]
c.colors.downloads.start.bg = palette["base"]
c.colors.downloads.stop.bg = palette["base"]
c.colors.downloads.error.fg = palette["red"]
c.colors.downloads.start.fg = palette["blue"]
c.colors.downloads.stop.fg = palette["green"]
c.colors.downloads.system.fg = "none"
c.colors.downloads.system.bg = "none"

c.colors.hints.bg = palette["peach"]
c.colors.hints.fg = palette["mantle"]

c.hints.border = "1px solid " + palette["mantle"]

c.colors.hints.match.fg = palette["subtext1"]

c.colors.keyhint.bg = palette["mantle"]
c.colors.keyhint.fg = palette["text"]
c.colors.keyhint.suffix.fg = palette["subtext1"]

c.colors.messages.error.bg = palette["overlay0"]
c.colors.messages.info.bg = palette["overlay0"]
c.colors.messages.warning.bg = palette["overlay0"]
c.colors.messages.error.border = palette["mantle"]
c.colors.messages.info.border = palette["mantle"]
c.colors.messages.warning.border = palette["mantle"]
c.colors.messages.error.fg = palette["red"]
c.colors.messages.info.fg = palette["text"]
c.colors.messages.warning.fg = palette["peach"]

c.colors.prompts.bg = palette["mantle"]
c.colors.prompts.border = "1px solid " + palette["overlay0"]
c.colors.prompts.fg = palette["text"]
c.colors.prompts.selected.bg = palette["surface2"]
c.colors.prompts.selected.fg = palette["rosewater"]

c.colors.statusbar.normal.bg = palette["base"]
c.colors.statusbar.insert.bg = palette["crust"]
c.colors.statusbar.command.bg = palette["base"]
c.colors.statusbar.caret.bg = palette["base"]
c.colors.statusbar.caret.selection.bg = palette["base"]
c.colors.statusbar.progress.bg = palette["base"]
c.colors.statusbar.passthrough.bg = palette["base"]
c.colors.statusbar.normal.fg = palette["text"]
c.colors.statusbar.insert.fg = palette["rosewater"]
c.colors.statusbar.command.fg = palette["text"]
c.colors.statusbar.passthrough.fg = palette["peach"]
c.colors.statusbar.caret.fg = palette["peach"]
c.colors.statusbar.caret.selection.fg = palette["peach"]
c.colors.statusbar.url.error.fg = palette["red"]
c.colors.statusbar.url.fg = palette["text"]
c.colors.statusbar.url.hover.fg = palette["sky"]
c.colors.statusbar.url.success.http.fg = palette["teal"]
c.colors.statusbar.url.success.https.fg = palette["green"]
c.colors.statusbar.url.warn.fg = palette["yellow"]
c.colors.statusbar.private.bg = palette["mantle"]
c.colors.statusbar.private.fg = palette["subtext1"]
c.colors.statusbar.command.private.bg = palette["base"]
c.colors.statusbar.command.private.fg = palette["subtext1"]

c.colors.tabs.bar.bg = palette["crust"]
c.colors.tabs.even.bg = palette["surface2"]
c.colors.tabs.odd.bg = palette["surface1"]
c.colors.tabs.even.fg = palette["overlay2"]
c.colors.tabs.odd.fg = palette["overlay2"]
c.colors.tabs.indicator.error = palette["red"]
c.colors.tabs.indicator.system = "none"
c.colors.tabs.selected.even.bg = palette["base"]
c.colors.tabs.selected.odd.bg = palette["base"]
c.colors.tabs.selected.even.fg = palette["text"]
c.colors.tabs.selected.odd.fg = palette["text"]

c.colors.contextmenu.menu.bg = palette["base"]
c.colors.contextmenu.menu.fg = palette["text"]
c.colors.contextmenu.disabled.bg = palette["mantle"]
c.colors.contextmenu.disabled.fg = palette["overlay0"]
c.colors.contextmenu.selected.bg = palette["overlay0"]
c.colors.contextmenu.selected.fg = palette["rosewater"]
