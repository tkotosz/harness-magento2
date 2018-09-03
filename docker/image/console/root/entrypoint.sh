#!/bin/bash

main()
{
    su - build
    sh -c 'while sleep 3600; do :; done'
}

setup_app_networking()
{
    # we always want to resolve the app host to traefik
    if ! grep $APP_HOST /etc/hosts > /dev/null ; then
        DOCKER_INTERNAL_IP=`/sbin/ip route|awk '/default/ { print $3 }'`
        echo -e "$DOCKER_INTERNAL_IP\t$APP_HOST" | tee -a /etc/hosts > /dev/null
    fi

    # make linux consistent with docker-for-mac
    if [ "${HOST_OS_FAMILY}" = "linux" ]; then
        DOCKER_INTERNAL_HOST="host.docker.internal"
        if ! grep $DOCKER_INTERNAL_HOST /etc/hosts > /dev/null ; then
            DOCKER_INTERNAL_IP=`/sbin/ip route|awk '/default/ { print $3 }'`
            echo -e "$DOCKER_INTERNAL_IP\t$DOCKER_INTERNAL_HOST" | tee -a /etc/hosts > /dev/null
        fi
    fi
}

bootstrap()
{
    setup_app_networking
}

bootstrap
main
