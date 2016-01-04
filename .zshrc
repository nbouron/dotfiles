export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git golang docker docker-compose composer)

source $ZSH/oh-my-zsh.sh

# docker
docker-clean() {
    if [[ "$1" == "-f" ]]; then
        ids=$(docker ps -q)
        if [[ -n "$ids" ]]; then
            echo "Stopping running containers..."
            docker stop ${(f)ids}
        fi
    fi
    ids=$(docker ps -aq -f status=created)
    ids+=$(docker ps -aq -f status=exited)
    [[ -z "$ids" ]] && return
    echo "Removing inactive containers..."
    docker rm ${(f)ids}
}

docker-env() {
    local machine=${1-dev}
    echo "Setting up the environment for the \"$machine\" machine..."
    eval "$(docker-machine env ${machine})"
}

docker-env >/dev/null 2>&1

# go
if type go >/dev/null 2>&1; then
    export GOPATH=$HOME/go
    PATH=$PATH:$GOPATH/bin
fi

# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
