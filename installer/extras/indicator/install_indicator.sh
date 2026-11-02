#!/bin/bash
# Install a service to run a neopixel as an indicator
cd ~
if [ ! -d "$HOME/.m2ag-labs" ]; then
    mkdir "$HOME/.m2ag-labs"
fi
if [ ! -d "$HOME/.m2ag-labs/services" ]; then
    mkdir "$HOME/.m2ag-labs/services"
fi
if [ ! -d "$HOME/.m2ag-labs/services/indicator" ]; then
    mkdir "$HOME/.m2ag-labs/services/indicator"
fi
pip install zerorpc
pip install rpi_ws281x adafruit-circuitpython-neopixel
python -m pip install --force-reinstall adafruit-blinka
#get the thing and component
cp "$HOME"/m2ag-labs/installer/extras/indicator/indicator.json m2ag-labs/device/available
cp "$HOME"/m2ag-labs/installer/extras/indicator/indicator.py m2ag-labs/device/helpers
sed -i 's*--HOST--*'"$HOSTNAME"'*g' "$HOME"/m2ag-labs/device/available/indicator.json
cp "$HOME"/m2ag-labs/installer/extras/indicator/indicator_service.py "$HOME/.m2ag-labs/services/indicator"
sudo cp "$HOME"/m2ag-labs/installer/extras/indicator/m2ag-indicator.service /etc/systemd/system/m2ag-indicator.service
sudo sed -i 's*--HOME--*'"$HOME"'*g' /etc/systemd/system/m2ag-indicator.service
sudo systemctl daemon-reload
sudo systemctl enable m2ag-indicator
sudo systemctl start m2ag-indicator
