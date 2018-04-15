source ~/workspace/antigen/antigen.zsh
antigen init ~/.antigenrc

export TERMINAL=termite
export EDITOR=nvim
export BROWSER=firefox

# foos

mkcd() {
  mkdir -p $1
  cd $1
}
