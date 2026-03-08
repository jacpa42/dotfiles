#!/usr/bin/env bash
hyprctl dispatch workspace "$WEB_WORKSPACE"
exec xdg-open "https://app.yoco.com/sales/payments/payment-gateway"
