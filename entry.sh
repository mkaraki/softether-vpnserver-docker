#!/bin/bash

on_term()
{
    vpnserver stop
    exit -1
}

trap "on_term" TERM

mkdir -p /usr/local/vpnserver/server_log
touch /usr/local/vpnserver/server_log/keep_this_for_tail_log

vpnserver start

tail -f /usr/local/vpnserver/server_log/*

on_term