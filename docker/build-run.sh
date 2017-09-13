#!/bin/bash

# Build
user="rleite" # Geralmente precisara alterar so este
build="img-server"

# Run
container="server"
port="-p 22"
privileged="--privileged"
# restart="--restart on-failure:3"

# Extras
repo="raul010/ubuntu-server"


build_run () {
    pretende=$1
    if [ $pretende == "1" ] || [ $pretende == "3" ];
    then
        echo "Building imagem"

        ## comando ##
        docker build --tag $build --build-arg user=$user  .

        if [ $# != 0 ];
        then
            echo "Erro no build. Verificar o erro pra poder prosseguir"
        fi
    fi

    if [ $pretende == "2" ] || [ $pretende == "3" ];
    then
        echo "Runing container"
        ## comando ##    
        docker run --name $container $port $restart -h $container $privileged -it $build /bin/bash
    fi

}


echo "O que você pretende?"
echo "1) build"
echo "2) run"
echo "3) build e run"
echo "4) start e attach"
echo "5) commit"
echo "6) push"
read pretende

case $pretende in
[1-3])
    build_run $pretende
;;
4)
    echo "Starting e Attaching terminal"
    ## comando ##    
    docker start $container && docker attach $container
;;
5)  
    echo "Commit imagem"
    docker commit $container $repo
;;
6)
    echo "Pushing para repositório"
    docker push $repo
;;


esac

