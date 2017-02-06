#!/bin/bash
init(){
	# echo "**** initializing update & upgrade"
	# sudo apt-get update -y;
	# sudo apt-get upgrade -y;
	echo "**** creating user node-red-service"
	#create a user for node-red to execute as a service but with a /home folder
	sudo adduser --disabled-password --disabled-login -gecos "" node-red-service
}

install_node(){
  init;
  echo "**** installing nodejs 6"
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -;
  sudo apt-get install -y nodejs;
}

install_node_red(){
	install_node;
	echo "**** Installing node-red"
	sudo npm install -g --unsafe-perm node-red node-red-admin;	
}

# add any node you need in the list
declare -a arr=("node-red-contrib-ui"
	"node-red-contrib-azure-iot-hub"
	"node-red-contrib-cognitive-services"
	"node-red-contrib-azure-blob-storage"
)

install_node_red_plugin(){
	echo "**** installing plugin $1"
	sudo npm install -g $1
}

create_node_red_service(){
 cd /home/node-red-service;
 sudo sh -c 'echo "[Unit]\nDescription=node-red server\nAfter=syslog.target network.target\n[Service]\nWorkingDirectory=/home/node-red-service/\nUser=node-red-service\nGroup=node-red-service\nExecStart=/usr/bin/node-red\nRestart=on-failure\nKillSignal=SIGINT\n[Install]\nWantedBy=multi-user.target\n" > nodered.service';

 sudo systemctl daemon-reload;
 sudo systemctl enable /home/node-red-service/nodered.service;
 sudo systemctl start nodered.service;
}


install_node_red;

echo "**** Installing node-red plugins"
for i in "${arr[@]}"
do
   install_node_red_plugin "$i"
done

echo "**** Creating node-red Service"
create_node_red_service;
