#!/bin/bash
wget https://github.com/bayramkarahan/e-ag/raw/refs/heads/master/e-ag-client_2.7.5_amd64.deb -O /tmp/e-ag-client_2.7.5_amd64.deb 
sudo dpkg -i /tmp/e-ag-client_2.7.5_amd64.deb
sudo apt-get -f install -y
