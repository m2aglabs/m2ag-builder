Systemd files to start the services:

Commands: 
sudo systemctl status <service name>
sudo systemctl start <service name>
sudo systemctl enable <serice name>
sudo systemctl daemon-reload

Place in /etc/systemd/system

API: 

Service name: m2ag-api

Filename: m2ag-api.service

Contents: 

[Unit]

Description=m2ag.labs device api
After=network.target

[Service]

User=pi
WorkingDirectory=/home/pi/device
ExecStart=python3 api.py
Restart=always

[Install]
WantedBy=multi-user.target

Device: 

Service name: m2ag-device

Filename: m2ag-device.service

Contents: 

[Unit]

Description=m2ag.labs device
After=network.target

[Service]

User=pi
WorkingDirectory=/home/pi/device
ExecStart=python3 device.py
Restart=always

[Install]
WantedBy=multi-user.target


Refercnce:

https://blog.miguelgrinberg.com/post/running-a-flask-application-as-a-service-with-systemd
