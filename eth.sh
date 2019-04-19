#!/bin/bash
# This is a comment!
# sudo root
echo "Start reset eth"
echo "test" 
#echo "bch1n1t1al0!" | sudo -S -v
#sudo -i
#check_errs $? "sudo -i ${1} "
#start clear screen 

LOG_DT=$(date +"%Y/%m/%d %H:%M:%S.%3N")
FILE_FORMAT=$(date +"%Y%m%d%H%M%S")
FILE_RESULT="/home/bchainadmin/backup/eth_$FILE_FORMAT.log"

stopscreen() {
	echo "$LOG_DT|Start clear screen"  | tee -a $FILE_RESULT
        screen -S explorer -X quit
	screen -S nodejs -X quit
	killall -HUP geth
	screen -S node1 -X quit
	screen -S node2 -X quit
	screen -S bootnode -X quit
	echo "$LOG_DT|End clear screen" | tee -a $FILE_RESULT
}

bootnode() {
	#boot net (01)
	echo "$LOG_DT|Start bootnode screen"  | tee -a $FILE_RESULT
	cd /home/bchainadmin/eth-dwallet/
	screen -d -m -S bootnode -L  bootnode -nodekey boot.key -verbosity 9 -addr :30310
	echo "$LOG_DT|End bootnode screen" | tee -a $FILE_RESULT
}

node1() {
	#node 1(01)
	echo "$LOG_DT|Start node1 screen"  | tee -a $FILE_RESULT
	cd /home/bchainadmin/eth-dwallet/node1
	#screen -d -m -S node1 -L  geth --datadir . --syncmode 'full' --port 30311 --rpc --rpcaddr '0.0.0.0' --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --rpccorsdomain "*" --bootnodes 'enode://a6f04df21e6f2832ee849ff4a10829f8569eb27d3d2e869f93bf7e1ac92f41d07629ae1a5d9540bd8e86e97d9ce365cb1a31e86833f6d3aba85ae300fda98daf@127.0.0.1:30310' --networkid 1114 --gasprice '1' -unlock '0x3b638f2cba92bd5ce82b15b8b4f2a3cce38c2edf' --password password.txt --mine 
	screen -d -m -S node1 -L  geth --datadir . --syncmode 'full' --port 30311 --rpc --rpcaddr '0.0.0.0' --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --rpccorsdomain "*" --networkid 1114 --gasprice '1' -unlock '0x11b6ea30ed4782387c3344a3c663a2a3e92a8c2f' --password password.txt --mine 

	echo "$LOG_DT|End node1 screen" | tee -a $FILE_RESULT
}

node2() {
	#node 2(01)
	echo "$LOG_DT|Start node2 screen"  | tee -a $FILE_RESULT
	cd /home/bchainadmin/eth-dwallet/node2
	screen -d -m -S node2 -L  geth --datadir . --syncmode 'full' --port 30312 --rpc --rpcaddr '0.0.0.0' --rpcport 8546 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --rpccorsdomain "*"  --bootnodes 'enode://a6f04df21e6f2832ee849ff4a10829f8569eb27d3d2e869f93bf7e1ac92f41d07629ae1a5d9540bd8e86e97d9ce365cb1a31e86833f6d3aba85ae300fda98daf@127.0.0.1:30310' --networkid 1114 --gasprice '0' --unlock '0xd450e8f1c80d8882852b8184c8a11074714b2a75' --password password.txt --mine 
	echo "$LOG_DT|End node2 screen" | tee -a $FILE_RESULT
}

nodejs() {
	#nodejs
	echo "$LOG_DT|Start nodejs screen"  | tee -a $FILE_RESULT
	sleep 15
	cd /home/bchainadmin/eth-dwallet/projectDwallet
	screen -d -m -S nodejs -L node app 
	echo "$LOG_DT|End nodejs screen" | tee -a $FILE_RESULT
}

explorer() {
	#explorer
	echo "$LOG_DT|Start explorer screen"  | tee -a $FILE_RESULT
        sleep 15
	cd /home/bchainadmin/explorer
	screen -d -m -S explorer -L  npm start 
	echo "$LOG_DT|End explorer screen" | tee -a $FILE_RESULT
}

case $1 in
    start)
        #bootnode
		node1
		#node2
		nodejs
		explorer
        ;;
    stop)
        stopscreen
        ;;
    restart)
        stopscreen
        #bootnode
		node1
		#node2
		nodejs
		explorer
        ;;
esac

exit 0
