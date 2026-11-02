#!/bin/bash
# for development -- reset m2ag-labs code but don't do a reinstall of all the services.
# does not delete .m2ag-labs
sudo systemctl stop m2ag-thing
sudo systemctl stop m2ag-client
sudo systemctl stop m2ag-builder
rm -rf "$HOME/m2ag-labs"
echo 'install services'
git clone https://github.com/m2ag-labs/m2ag-thing-builder.git "$HOME/m2ag-labs"
git clone https://github.com/m2ag-labs/m2ag-thing-installer.git "$HOME/m2ag-labs/installer"
git clone https://github.com/m2ag-labs/m2ag-thing-client.git "$HOME/m2ag-labs/client"
#copy default config:
cp "$HOME"/m2ag-labs/installer/thing/config_template/server.json "$HOME"/m2ag-labs/config/server.json
cp "$HOME"/m2ag-labs/installer/thing/config_template/component_map.json "$HOME"/m2ag-labs/config/component_map.json
sed -i 's*--HOSTNAME--*'"$HOSTNAME"'*g' "$HOME"/m2ag-labs/config/server.json
#create needed directories
mkdir "$HOME"/m2ag-labs/config/available
mkdir "$HOME"/m2ag-labs/config/available/components
mkdir "$HOME"/m2ag-labs/config/available/things
mkdir "$HOME"/m2ag-labs/device/services/components
mkdir "$HOME"/m2ag-labs/device/things/components
sudo systemctl start m2ag-builder
sudo systemctl start m2ag-client
