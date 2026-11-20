#!/usr/bin/env nu

let path = "~/Zotero/storage"
let file_pipe = "/tmp/fzf-zotero-pipe"

def "main select" [
] {
  cd $path;
  fzf -q "pdf$ "
  | complete
  # | inspect
  | if ($in.exit_code == 0) {
    $in.stdout
    | str trim -c "\n"
    | save -f $file_pipe
  } else {
    ""
    | save -f $file_pipe
  }
}

# Select a paper amongst the pdf saved in Zotero,
# and launch a pdf viewer.
def main [
] {
  alacritty -o "window.startup_mode = 'Fullscreen'" -e /home/vincent/zotero-pdf.nu select ;
  let file = open $file_pipe
  let address = ($path | path join $file | path expand);
  print $address;
  if ($file == "") {return} else {
    sioyek --new-window $address
  }
}

