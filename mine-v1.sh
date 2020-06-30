#!/usr/bin/env bash

[[ "$EUID" -ne "0" ]] && echo "This script must be run as root" && exit; 


rpcusername=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
passwd=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')

echo "Updating System.."
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libboost-all-dev libboost-program-options-dev

sudo apt-get install -y libminiupnpc-dev libzmq3-dev libprotobuf-dev protobuf-compiler unzip software-properties-common

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update -y
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

clear

wallet-install()
{
	clear

	wget "https://www.qngnode.cc/wp-content/uploads/2020/06/qnodecoin-daemon-v2.0-linux.tar.gz" -O qnodecoin-daemon-v2.0-linux.tar.gz

	wget "https://www.qngnode.cc/wp-content/uploads/2020/06/qnodecoin-qt-v2.0-linux.tar.gz" -O qnodecoin-qt-v2.0-linux.tar.gz

	tar -xzvf qnodecoin-daemon-v2.0-linux.tar.gz
	tar -xzvf qnodecoin-qt-v2.0-linux.tar.gz

	sudo mv qnodecoind qnodecoin-tx qnodecoin-cli qnodcoin-qt /usr/bin/

	clear



	mkdir $HOME/.qnodecoin
	cat > $HOME/.qnodecoin/qnodecoin.conf <<EOF
		rpcuser=$rpcusername
		rpcpassword=$passwd
		rpcallowip=127.0.0.1
		listen=1
		server=1
		txindex=1
		daemon=1
EOF
clear

echo "Now starting the daemon . . .\n"
qnodecoind

sleep 5s

clear
}

 miner()
{


	cat > $HOME/mine.sh <<EOF
		#!/bin/bash
		#SCRIPT_PATH=`pwd`
		#cd $SCRIPT_PATH
		echo "Press [CTRL+C] to stop mining."
		echo
		echo "Note: It may take you up to +/- 30 minutes to mine your first block"
		echo 
		while true
		do
			qnodecoin-cli generate 1
		done
EOF

chmod +x mine.sh
echo "Now starting the miner"
sleep 5s
./mine.sh
}

#init-setup
wallet-install
miner

