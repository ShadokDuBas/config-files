#!/usr/bin/env bash
swayidle -w \
  timeout 300 'swaylock -f' \
  timeout 240 'niri msg action power-off-monitors' \
    resume 'niri msg action power-on-monitors' \
  before-sleep 'swaylock -f'
