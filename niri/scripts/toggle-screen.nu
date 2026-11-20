#! /usr/bin/env nu

let my_screen = "eDP-1"

def is-my-screen-on [] {
  let mode = (niri msg -j outputs 
  | from json 
  | get $my_screen
  | get "current_mode"
  | default (0 - 1));
  $mode != -1
}

# Toggle my laptop screen on and off
def main [
] {
  let b = is-my-screen-on;
  if $b {
    niri msg output $my_screen off
  } else {
    niri msg output $my_screen on
  }
}
