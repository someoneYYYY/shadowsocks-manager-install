#!/bin/bash



SS_TYPE="client"
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo yum install -y wget
sudo systemctl start docker
sudo docker images

mkdir -p /data/docker/ssmgr

while getopts "s" OPT;do
     case $OPT in
       s) SS_TYPE="server";;
      esac
done

if [ "$SS_TYPE" == "server" ];then
  echo "server part"
  wget -N -P /data/docker/ssmgr/ https://raw.githubusercontent.com/tanghuailong/android/master/webgui.yml
  echo "finished downloading webgui.yml"
  docker run --name=ssmgr -d -v /data/docker/ssmgr:/root/.ssmgr/ -p 7000:80 -p 38000-38100:38000-38100 -e SSMGR_PASSWORD=123456 -e SS_METHOD=aes-256-cfb miniers/docker-ssmgr

else
  echo "client part "
  docker run  --name=ssmgrclient -d -v /data/docker/ssmgr:/root/.ssmgr -p 4001:4001 -p 38000-38100:38000-38100 -e SSMGR_PASSWORD=123456 -e SS_METHOD=aes-256-cfb  miniers/docker-ssmgr
fi

