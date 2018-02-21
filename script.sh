#!/usr/bin/env bash

EVE_CONFIG_PARAMS="-conf=eve/bitcoin.conf -datadir=eve/ -port=18333 -server -zmqpubhashtx=tcp://0.0.0.0:28332 -zmqpubhashblock=tcp://0.0.0.0:28332 -zmqpubrawblock=tcp://0.0.0.0:28332 -zmqpubrawtx=tcp://0.0.0.0:28332"
BOB_CONFIG_PARAMS="-conf=bob/bitcoin.conf -datadir=bob/ -port=18444 -server -connect=localhost:18333"
ALICE_CONFIG_PARAMS="-conf=alice/bitcoin.conf -datadir=alice/ -port=18555 -server -connect=localhost:18333"
EVE_PARAMS="-rpcuser=eve -rpcpassword=eve -rpcport=8333 -regtest"
BOB_PARAMS="-rpcuser=bob -rpcpassword=bob -rpcport=8444 -regtest"
ALICE_PARAMS="-rpcuser=alice -rpcpassword=bob -rpcport=8555 -regtest"

case "$1" in
	start)
		./bitcoind.exe $EVE_CONFIG_PARAMS $EVE_PARAMS &
		sleep 8
		./bitcoin-cli.exe $EVE_PARAMS encryptwallet passw > /dev/null
		./bitcoind.exe $EVE_CONFIG_PARAMS $EVE_PARAMS &
		sleep 2
		echo "Started bitcoind for Eve"
		./bitcoind.exe $BOB_CONFIG_PARAMS $BOB_PARAMS &
		sleep 8
		./bitcoin-cli.exe $BOB_PARAMS encryptwallet passw > /dev/null
		./bitcoind.exe $BOB_CONFIG_PARAMS $BOB_PARAMS &
		sleep 2
		echo "Started bitcoind for Bob"
		./bitcoind.exe $ALICE_CONFIG_PARAMS $ALICE_PARAMS &
		sleep 8
		./bitcoin-cli.exe $ALICE_PARAMS encryptwallet passw > /dev/null
		./bitcoind.exe $ALICE_CONFIG_PARAMS $ALICE_PARAMS &
		sleep 2
		echo "Started bitcoind for Alice"
		;;
	stop)
		kill -9 `ps aux | grep bitcoind | awk '{print $1}'`
		rm -rf eve/regtest/
		rm -rf bob/regtest/
		rm -rf alice/regtest/
		;;
	mine)
		./bitcoin-cli.exe $EVE_PARAMS generate 3
		./bitcoin-cli.exe $EVE_PARAMS generate 100
		;;
	send)
		case "$3" in
			eve)
				ADDRESS=`./bitcoin-cli.exe $EVE_PARAMS getnewaddress`
				;;
			bob)
				ADDRESS=`./bitcoin-cli.exe $BOB_PARAMS getnewaddress`
				;;
			alice)
				ADDRESS=`./bitcoin-cli.exe $ALICE_PARAMS getnewaddress`
				;;
		esac
		echo $ADDRESS
		case "$2" in
			eve)
				./bitcoin-cli.exe $EVE_PARAMS walletpassphrase passw 60
				./bitcoin-cli.exe $EVE_PARAMS sendtoaddress $ADDRESS $4
				;;
			bob)
				./bitcoin-cli.exe $BOB_PARAMS walletpassphrase passw 60
				./bitcoin-cli.exe $BOB_PARAMS sendtoaddress $ADDRESS $4
				;;
			alice)
				./bitcoin-cli.exe $ALICE_PARAMS walletpassphrase passw 60
				./bitcoin-cli.exe $ALICE_PARAMS sendtoaddress $ADDRESS $4
				;;
		esac
		;;
	command)
		name="$2"
		shift
		shift
		case "$name" in
			eve)
				./bitcoin-cli.exe $EVE_PARAMS $*
				;;
			bob)
				./bitcoin-cli.exe $BOB_PARAMS $*
				;;
			alice)
				./bitcoin-cli.exe $ALICE_PARAMS $*
				;;
		esac
		;;
	*)
		echo $"Usage: $0 {start|stop|mine|send <from> <to> <amount>|command <who> <command>}"
		exit 1	
esac