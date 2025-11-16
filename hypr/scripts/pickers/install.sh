#!/bin/bash
previewlabel='alt-p: toggle description, alt-j/k: scroll, tab: multi-select'

fzfargs=(
    --multi
    --preview="echo -e \"$previewlabel\n\" && paru -Sii {1}"
    --preview-window 'down:65%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
)

pkg_names=$(paru -Slq | fzf "${fzfargs[@]}")

if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated for paru
    echo "$pkg_names" | tr '\n' ' ' | xargs paru -S --noconfirm
fi
