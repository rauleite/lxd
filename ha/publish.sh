#!/bin/bash
# lxc stop ha && lxc publish ha

out="out"
nginx1="web1"
nginx2="web2"
haproxy="ha"

lxc stop $test && lxc publish $test && \
lxc stop $nginx1 && lxc publish $nginx1 && \
lxc stop $nginx2 && lxc publish $nginx2