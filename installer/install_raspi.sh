#!/bin/bash
#TODO: add prompt if no certs -- continue as non-ssl
#TODO: check for .m2ag-labs/secrets
echo "m2ag.labs thing installer beta 2"
echo "copyright 2021 https://m2aglabs.com"

if [ ! -f "$HOME/server.crt" ] || [ ! -f "$HOME/server.key" ];
then
    echo "No ssl certs found"
    echo "ssl certs should be generated and placed in $HOME/m2ag-labs/config/ssl"
    echo "installing for http"
fi

echo 'update the system'
sudo apt update
sudo apt upgrade -y
echo 'install some tools'
sudo apt install mc git i2c-tools python3-pip python3-gpiozero python3-pigpio python3-venv apache2-utils  -y

echo 'install services'
git clone https://github.com/m2ag-labs/m2ag-webthings-builder.git "$HOME/m2ag-labs"
git clone https://github.com/m2ag-labs/m2ag-webthings-client.git "$HOME/m2ag-labs/client"


mkdir "$HOME"/m2ag-labs/config
mkdir "$HOME"/m2ag-labs/config/available
mkdir "$HOME"/m2ag-labs/config/ssl
mkdir "$HOME"/m2ag-labs/device/helpers

if [ -f "$HOME/server.crt" ] && [ -f "$HOME/server.key" ];
then 
    mv server.crt "$HOME/m2ag-labs/config/ssl"
    mv server.key "$HOME/m2ag-labs/config/ssl"
    mv rootca.crt "$HOME/m2ag-labs/config/ssl"
fi

cd m2ag-labs

echo 'create virtual environment'
python3 -m venv venv
source venv/bin/activate
python3 -m pip install wheel
pip3 install --upgrade setuptools
echo 'adafruit stuff'
pip3 install RPI.GPIO adafruit-blinka
echo 'flask'
pip3 install flask flask-cors flask-htpasswd==0.5.0 passlib==1.7.4
echo 'install other stuff'
pip3 install psutil gpiozero pigpio
echo 'install webthing dependencies'
pip3 install ifaddr jsonschema pyee tornado zeroconf 
pip3 install pyjwt zerorpc
echo 'setup systemd'
# set correct path in service files
sudo cp "$HOME/m2ag-labs/installer/thing/systemd/m2ag-builder.service" /etc/systemd/system/m2ag-builder.service
sudo sed -i 's*--HOME--*'"$HOME"'*g' /etc/systemd/system/m2ag-builder.service
sudo sed -i 's*--USER--*'"$USER"'*g' /etc/systemd/system/m2ag-builder.service
sudo cp "$HOME/m2ag-labs/installer/thing/systemd/m2ag-thing.service" /etc/systemd/system/m2ag-thing.service
sudo sed -i 's*--HOME--*'"$HOME"'*g' /etc/systemd/system/m2ag-thing.service
sudo sed -i 's*--USER--*'"$USER"'*g' /etc/systemd/system/m2ag-thing.service
# default user -- pi / raspberry
cp "$HOME/m2ag-labs/installer/thing/config_template/.htpasswd" "$HOME/config/"
#copy default config:
cp "$HOME"/m2ag-labs/installer/thing/config_template/server.json "$HOME"/m2ag-labs/config/server.json
cp "$HOME"/m2ag-labs/installer/thing/config_template/enabled.json "$HOME"/m2ag-labs/config/enabled.json
sed -i 's*--HOSTNAME--*'"$HOSTNAME"'*g' "$HOME"/m2ag-labs/config/server.json
sudo systemctl daemon-reload
# sudo systemctl enable m2ag-thing
sudo systemctl enable m2ag-builder
# Start api service last
# sudo systemctl start m2ag-thing
sudo systemctl start m2ag-builder