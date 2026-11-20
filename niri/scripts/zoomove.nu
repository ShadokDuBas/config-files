#! /usr/bin/env nu

def "main left" [
  ] {
  main --left
}


# Make the focused window smaller, focus another window
# and make it complement the screen
def main [
  --left (-l) #Move to the left (default: to the right)
  --mid (-m) #Make the window take half the screen (default 2/5-3/5)
] {
  let proportions = if $mid {["50%" "50%"]} else {["40%" "60%"]};
  niri msg action set-column-width $proportions.0;
  if $left { 
    niri msg action focus-column-left 
  } else {
    niri msg action focus-column-right;
  };
  niri msg action set-column-width $proportions.1;
}

def "main right" [] {
  main
}
