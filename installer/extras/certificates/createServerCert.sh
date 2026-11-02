#!/usr/bin/env bash
if [[ "$1" == "" ]]
then
    echo "please supply the hostname"
    exit
fi
mkdir devices/"$1"
echo "$1"
cp templates/server.csr.cnf server.csr.cnf
cp templates/v3.ext v3.ext
# mac needs the "" after -i
sed -i 's*--HOSTNAME--*'"$1"'*g' v3.ext
sed -i 's*--HOSTNAME--*'"$1"'*g' server.csr.cnf
openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -config server.csr.cnf
openssl x509 -req -in server.csr -CA roots/rootCA.pem -CAkey roots/rootCA.key -CAcreateserial -out server.crt -days 825 -sha256 -extfile v3.ext
mv server.crt devices/"$1"/server.crt
mv server.key devices/"$1"/server.key
rm server.csr
rm server.csr.cnf
rm v3.ext
