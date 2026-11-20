#! /usr/bin/env nu

# ln -s this file ~/go-neovim.nu

let dossiers = "/home/vincent/.nvim-folders.json"
let folder_pipe = "/tmp/fzf-pipe"
let fzf_title = "fzf-selector"
let nvim_title = "nvim"

def parse-nvim-folders [] {
  open $dossiers
}

def save-nvim-folders [] {
  $in
  | save -f $dossiers
}

def find-nvim-id [] {
  niri msg -j windows
  | from json
  | where title =~ "nvim"
  | where is_focused == false
  | sort-by {|x| $x.title | str length}
  | select id
}

def "main select-folder" [] {
  parse-nvim-folders
  | str join "\n"
  | fzf
  | complete
  | if ($in.exit_code == 0) {
    $in.stdout
    | str trim -c "\n"
    | save -f $folder_pipe
  } else {
    ""
    | save -f $folder_pipe
  }
}

# Prompts for a folder, then open an instance "lauch nvim" with that working
# directory
def "main new-instance" [] {
  alacritty -T $fzf_title -e /home/vincent/go-neovim.nu select-folder ;
  let folder = open $folder_pipe
  if ($folder == "") {return} else {
    alacritty -T $nvim_title --working-directory $folder -e /home/vincent/go-neovim.nu launch-nvim ;
  }
}

def "main launch-nvim" [] {
  nvim ;
  fish
}

# Adds current working directory to the folder list
def "main add-folder" [] {
  let x = pwd;
  parse-nvim-folders
  | append [$x]
  | inspect
  | save-nvim-folders
}

# find the active nvim window, and asks niri to focus it.
# If no active nvim window is open, open a new nvim window.
# New windows use a pwd that belongs to a list stored on the file.
def main [
  --new (-n) #Force to open a new window
] {
  let l = find-nvim-id
  if $l == [] or $new {
    main new-instance
  } else {
    let $id = $l | get 0 | get id
    niri msg action focus-window --id $id
  }
}
