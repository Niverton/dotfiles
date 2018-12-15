source /usr/share/zsh/share/antigen.zsh
antigen init ~/.antigenrc

export TERMINAL=termite
export EDITOR=nvim
export BROWSER=firefox

# foos

mkcd() {
  mkdir -p $1
  cd $1
}

alias gpuon="sudo tee /proc/acpi/bbswitch <<< ON"

gpuoff() {
  sudo rmmod nvidia_uvm nvidia
  sudo tee /proc/acpi/bbswitch <<< OFF
}
