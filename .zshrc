# do not echo back
[[ -t 0 ]] && stty -echo
echo -n '\r\e[K'


# if a glob pattern for an argument has no match, leave it unchanged instead of printing an error
# allows commands like "composer update acme/*"
unsetopt NOMATCH

# delete old history line if new line is a duplicate
setopt HIST_IGNORE_ALL_DUPS

# Print the exit value of programs with non-zero exit status
setopt PRINT_EXIT_VALUE

# oh-my-zsh stuff
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git golang docker docker-machine docker-compose)
source $ZSH/oh-my-zsh.sh


# editor
export EDITOR=vim
export VISUAL=vim


# executables
export PATH=$HOME/bin:$PATH


# shell completion
fpath=(~/.zsh_completion $fpath) && compinit


# docker
docker-clean() {
    if [[ "$1" == "-f" ]]; then
        ids=$(docker ps -q)
        if [[ -n "$ids" ]]; then
            echo "Stopping running containers..."
            docker stop ${(f)ids}
        fi
    fi
    ids=$(docker ps -aq -f status=exited)
    [[ -z "$ids" ]] && return
    echo "Removing inactive containers..."
    docker rm ${(f)ids}
}


# go
if type go >/dev/null 2>&1; then
    export GOPATH=$HOME/go
    export GOTHUB=$GOPATH/src/github.com
    PATH=$GOPATH/bin:$PATH
    alias gop="cd \$GOPATH"
    alias got="cd \$GOTHUB"
fi


# php
alias phpunit="php-bin phpunit"
alias puli="php-bin puli"
alias c="composer"


# "sh long-running-task.sh; saydone"
saydone() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        voices=("Good News" Whisper Hysterical Princess Bells "Bad News" Bahh)
        words=(done maybe no failure "oh my god" finished yes success "you broke it")

        say -v "${voices[RANDOM % ${#voices[@]} + 1]}" "${words[RANDOM % ${#words[@]} + 1]}"
    else
        echo "OS not supported yet"
    fi
}


# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
