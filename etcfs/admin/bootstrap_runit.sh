#!/usr/bin/env bash

## Import envvars dumped by Dockerfile, since runit starts with no ENV
export > /etc/envvars

## A bin path would be rather useful too
PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin

## Run it
exec env - PATH=$PATH runsvdir -P /etc/service