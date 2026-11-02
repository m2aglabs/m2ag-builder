This directory contains some scripts that can help install extra services and custom uis.

(1-22-21) Currently, not all installers are compatible with the latest architecture. See the readme in each directory.

reset-m2ag.sh:

This script will remove and reinstall the m2ag builder. The component map and all downloaded modules will have to be readded.

Run with:

```
bash m2ag-labs/installer/extras/reset-m2ag.sh
```

runandshut.sh:

A script to enable a run indicator led and a shutdown button for a Raspberry PI.

Circuit diagrams and explantion can be found at this blog post:

[https://m2aglabs.com/2020/04/08/raspberry-pi-running-indicator-and-shutdown-button/](https://m2aglabs.com/2020/04/08/raspberry-pi-running-indicator-and-shutdown-button/)

Run with:
```
bash m2ag-labs/installer/extras/runandshut.sh
```



