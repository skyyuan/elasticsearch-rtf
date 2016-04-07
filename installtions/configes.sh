#!/usr/bin/bash -i
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
mkdir -p /data/es/data
mkdir -p /data/es/log
mkdir -p /data/es/pid
mkdir -p /data/es/tmp
chown -R elasticsearch:elasticsearch /data/es
