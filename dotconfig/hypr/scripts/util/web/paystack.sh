#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
exec xdg-open "https://dashboard.paystack.com/#/dashboard"
