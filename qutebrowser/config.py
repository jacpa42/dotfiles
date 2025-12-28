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

# Open inbox
config.bind("e", "open https://mail.proton.me/u/2/inbox")
# Open inbox in separate tab
config.bind("E", "open -t https://mail.proton.me/u/2/inbox")

# Clear download notifications
config.bind("<Ctrl-f>", "download-clear ;; clear-messages")
# resource config
config.bind("<Shift-r>", "config-source")

c.fileselect.handler = "external"

select_cmd = ["footclient", "--title=tpopup", "--app-id=tpopup", "yazi", "--chooser-file={}"]
c.fileselect.folder.command = select_cmd
c.fileselect.single_file.command = select_cmd
c.fileselect.multiple_files.command = select_cmd

import os

c.url.default_page = f"file:///{os.path.expanduser("~")}/Projects/dotfiles/qutebrowser/metal.png"
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}"
    # "DEFAULT": "https://www.google.com/search?q={}"
}

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

# FONTS #
c.hints.chars = "jfkdlspaieurow"
c.fonts.default_size = "16pt"
c.fonts.default_family = ["JetBrainsMono Nerd Font Mono", "Noto Color Emoji"]
c.fonts.contextmenu = c.fonts.default_family[0]
c.fonts.prompts = c.fonts.default_family[0]
c.fonts.tooltip = c.fonts.default_family[0]

############# COLOUR SCHEME #############
def catppuccin():
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

def kanagawa():
    # base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
    # Scheme name: Kanagawa
    # Scheme author: Tommaso Laurenzi (https://github.com/rebelot)
    # Template author: theova and Daniel Mulford
    # Commentary: Tinted Theming: (https://github.com/tinted-theming)

    base00 = "#1F1F28"
    base01 = "#16161D"
    base02 = "#223249"
    base03 = "#54546D"
    base04 = "#727169"
    base05 = "#DCD7BA"
    base06 = "#C8C093"
    base07 = "#717C7C"
    base08 = "#C34043"
    base09 = "#FFA066"
    base0A = "#C0A36E"
    base0B = "#76946A"
    base0C = "#6A9589"
    base0D = "#7E9CD8"
    base0E = "#957FB8"
    base0F = "#D27E99"

    # set qutebrowser colors

    # Text color of the completion widget. May be a single color to use for
    # all columns or a list of three colors, one for each column.
    c.colors.completion.fg = base05

    # Background color of the completion widget for odd rows.
    c.colors.completion.odd.bg = base00

    # Background color of the completion widget for even rows.
    c.colors.completion.even.bg = base00

    # Foreground color of completion widget category headers.
    c.colors.completion.category.fg = base0D

    # Background color of the completion widget category headers.
    c.colors.completion.category.bg = base00

    # Top border color of the completion widget category headers.
    c.colors.completion.category.border.top = base00

    # Bottom border color of the completion widget category headers.
    c.colors.completion.category.border.bottom = base00

    # Foreground color of the selected completion item.
    c.colors.completion.item.selected.fg = base05

    # Background color of the selected completion item.
    c.colors.completion.item.selected.bg = base02

    # Top border color of the selected completion item.
    c.colors.completion.item.selected.border.top = base02

    # Bottom border color of the selected completion item.
    c.colors.completion.item.selected.border.bottom = base02

    # Foreground color of the matched text in the selected completion item.
    c.colors.completion.item.selected.match.fg = base05

    # Foreground color of the matched text in the completion.
    c.colors.completion.match.fg = base09

    # Color of the scrollbar handle in the completion view.
    c.colors.completion.scrollbar.fg = base05

    # Color of the scrollbar in the completion view.
    c.colors.completion.scrollbar.bg = base00

    # Background color of disabled items in the context menu.
    c.colors.contextmenu.disabled.bg = base01

    # Foreground color of disabled items in the context menu.
    c.colors.contextmenu.disabled.fg = base04

    # Background color of the context menu. If set to null, the Qt default is used.
    c.colors.contextmenu.menu.bg = base00

    # Foreground color of the context menu. If set to null, the Qt default is used.
    c.colors.contextmenu.menu.fg =  base05

    # Background color of the context menu’s selected item. If set to null, the Qt default is used.
    c.colors.contextmenu.selected.bg = base02

    #Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
    c.colors.contextmenu.selected.fg = base05

    # Background color for the download bar.
    c.colors.downloads.bar.bg = base00

    # Color gradient start for download text.
    c.colors.downloads.start.fg = base00

    # Color gradient start for download backgrounds.
    c.colors.downloads.start.bg = base0D

    # Color gradient end for download text.
    c.colors.downloads.stop.fg = base00

    # Color gradient stop for download backgrounds.
    c.colors.downloads.stop.bg = base0C

    # Foreground color for downloads with errors.
    c.colors.downloads.error.fg = base08

    # Font color for hints.
    c.colors.hints.fg = base00

    # Background color for hints. Note that you can use a `rgba(...)` value
    # for transparency.
    c.colors.hints.bg = base0A

    # Font color for the matched part of hints.
    c.colors.hints.match.fg = base05

    # Text color for the keyhint widget.
    c.colors.keyhint.fg = base05

    # Highlight color for keys to complete the current keychain.
    c.colors.keyhint.suffix.fg = base05

    # Background color of the keyhint widget.
    c.colors.keyhint.bg = base00

    # Foreground color of an error message.
    c.colors.messages.error.fg = base00

    # Background color of an error message.
    c.colors.messages.error.bg = base08

    # Border color of an error message.
    c.colors.messages.error.border = base08

    # Foreground color of a warning message.
    c.colors.messages.warning.fg = base00

    # Background color of a warning message.
    c.colors.messages.warning.bg = base0E

    # Border color of a warning message.
    c.colors.messages.warning.border = base0E

    # Foreground color of an info message.
    c.colors.messages.info.fg = base05

    # Background color of an info message.
    c.colors.messages.info.bg = base00

    # Border color of an info message.
    c.colors.messages.info.border = base00

    # Foreground color for prompts.
    c.colors.prompts.fg = base05

    # Border used around UI elements in prompts.
    c.colors.prompts.border = base00

    # Background color for prompts.
    c.colors.prompts.bg = base00

    # Background color for the selected item in filename prompts.
    c.colors.prompts.selected.bg = base02

    # Foreground color for the selected item in filename prompts.
    c.colors.prompts.selected.fg = base05

    # Foreground color of the statusbar.
    c.colors.statusbar.normal.fg = base05

    # Background color of the statusbar.
    c.colors.statusbar.normal.bg = base00

    # Foreground color of the statusbar in insert mode.
    c.colors.statusbar.insert.fg = base0C

    # Background color of the statusbar in insert mode.
    c.colors.statusbar.insert.bg = base00

    # Foreground color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.fg = base0A

    # Background color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.bg = base00

    # Foreground color of the statusbar in private browsing mode.
    c.colors.statusbar.private.fg = base0E

    # Background color of the statusbar in private browsing mode.
    c.colors.statusbar.private.bg = base00

    # Foreground color of the statusbar in command mode.
    c.colors.statusbar.command.fg = base04

    # Background color of the statusbar in command mode.
    c.colors.statusbar.command.bg = base01

    # Foreground color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.fg = base0E

    # Background color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.bg = base01

    # Foreground color of the statusbar in caret mode.
    c.colors.statusbar.caret.fg = base0D

    # Background color of the statusbar in caret mode.
    c.colors.statusbar.caret.bg = base00

    # Foreground color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.fg = base0D

    # Background color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.bg = base00

    # Background color of the progress bar.
    c.colors.statusbar.progress.bg = base0D

    # Default foreground color of the URL in the statusbar.
    c.colors.statusbar.url.fg = base05

    # Foreground color of the URL in the statusbar on error.
    c.colors.statusbar.url.error.fg = base08

    # Foreground color of the URL in the statusbar for hovered links.
    c.colors.statusbar.url.hover.fg = base09

    # Foreground color of the URL in the statusbar on successful load
    # (http).
    c.colors.statusbar.url.success.http.fg = base0B

    # Foreground color of the URL in the statusbar on successful load
    # (https).
    c.colors.statusbar.url.success.https.fg = base0B

    # Foreground color of the URL in the statusbar when there's a warning.
    c.colors.statusbar.url.warn.fg = base0E

    # Background color of the tab bar.
    c.colors.tabs.bar.bg = base00

    # Color gradient start for the tab indicator.
    c.colors.tabs.indicator.start = base0D

    # Color gradient end for the tab indicator.
    c.colors.tabs.indicator.stop = base0C

    # Color for the tab indicator on errors.
    c.colors.tabs.indicator.error = base08

    # Foreground color of unselected odd tabs.
    c.colors.tabs.odd.fg = base05

    # Background color of unselected odd tabs.
    c.colors.tabs.odd.bg = base00

    # Foreground color of unselected even tabs.
    c.colors.tabs.even.fg = base05

    # Background color of unselected even tabs.
    c.colors.tabs.even.bg = base00

    # Background color of pinned unselected even tabs.
    c.colors.tabs.pinned.even.bg = base0B

    # Foreground color of pinned unselected even tabs.
    c.colors.tabs.pinned.even.fg = base00

    # Background color of pinned unselected odd tabs.
    c.colors.tabs.pinned.odd.bg = base0B

    # Foreground color of pinned unselected odd tabs.
    c.colors.tabs.pinned.odd.fg = base00

    # Background color of pinned selected even tabs.
    c.colors.tabs.pinned.selected.even.bg = base02

    # Foreground color of pinned selected even tabs.
    c.colors.tabs.pinned.selected.even.fg = base05

    # Background color of pinned selected odd tabs.
    c.colors.tabs.pinned.selected.odd.bg = base02

    # Foreground color of pinned selected odd tabs.
    c.colors.tabs.pinned.selected.odd.fg = base05

    # Foreground color of selected odd tabs.
    c.colors.tabs.selected.odd.fg = base05

    # Background color of selected odd tabs.
    c.colors.tabs.selected.odd.bg = base02

    # Foreground color of selected even tabs.
    c.colors.tabs.selected.even.fg = base05

    # Background color of selected even tabs.
    c.colors.tabs.selected.even.bg = base02

    # Background color for webpages if unset (or empty to use the theme's
    # color).
    c.colors.webpage.bg = base00
    return

kanagawa()
