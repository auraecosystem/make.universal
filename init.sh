# Bash
$ rustup completions bash > ~/.local/share/bash-completion/completions/rustup

# Bash (macOS/Homebrew)
$ rustup completions bash > $(brew --prefix)/etc/bash_completion.d/rustup.bash-completion

# Fish
$ mkdir -p ~/.config/fish/completions
$ rustup completions fish > ~/.config/fish/completions/rustup.fish

# Zsh
$ rustup completions zsh cargo > ~/.zfunc/_cargo

rm -f ~/.zcompdump; compinit
source ~/.zshrc

# PowerShell 
$ rustup completions powershell >> $PROFILE.CurrentUserCurrentHost
# or
$ rustup completions powershell | Out-String | Invoke-Expression
