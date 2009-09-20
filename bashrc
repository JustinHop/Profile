set -o vi

if [ -f "~/bin/zsh" ]; then
    alias zsh="~/bin/zsh"
fi

export PS1="<\u@\H> \W \$ "

