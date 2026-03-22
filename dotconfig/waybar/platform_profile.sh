#!/usr/bin/env bash

get_profile() {
    cat /sys/firmware/acpi/platform_profile 2>/dev/null
}

set_profile() {
    echo "$1" | sudo tee /sys/firmware/acpi/platform_profile >/dev/null
}

cycle_profile() {
    current=$(get_profile)

    case "$current" in
    quiet) next="balanced" ;;
    balanced) next="performance" ;;
    performance) next="quiet" ;;
    *) next="quiet" ;;
    esac

    set_profile "$next"
}

[[ "$1" == "toggle" ]] && cycle_profile

echo "{\"alt\": \"$(get_profile)\"}"
