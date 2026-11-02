#!/usr/bin/env bash
openssl genrsa -des3 -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 7300 -out rootCA.pem
mv rootCA.pem roots/rootCA.pem
mv rootCA.key roots/rootCA.key
#
# mv createRootCA.sh roots/createRootCA.sh

