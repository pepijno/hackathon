## prerequisites

node & npm ([https://nodejs.org/en/download/](https://nodejs.org/en/download/))

git & git bash ([https://git-scm.com/downloads](https://git-scm.com/downloads))

## Setup

Open git bash. Execute
```bash
git clone https://github.com/pepijno/hackathon.git
cd hackathon
npm install
```

In the meantime, download the bitcoin core zip ([https://bitcoin.org/en/download](https://bitcoin.org/en/download)) and copy bitcoind.exe and bitcoin-cli.exe from the bin folder to the hackathon folder.

## Generating transactions

Usage:
```bash
node index.js <amount> <type>
```

```amount```: The amount of transactions to generate. Defaults to ```10```.

```type```: The type of transactions, can be either ```0```, ```1``` or ```2```. ```1``` means each transaction has exactly two outputs: one regular output and one change output. Using type ```1``` will generate transactions with either two or three outputs. Using type ```2``` generate transactions with either two or three outputs and randomly adds extra inputs from outside the tree to some of the transactions. ```type``` defaults to ```0```.

For example, to generate 20 transactions with each transaction having two or three outputs:
```bash
node index.js 20 1
```

## Using bitcoin nodes

The `manage_nodes.sh` script provides commands for a three-node setup, 'owned' by alice, bob and eve.

To start the nodes (this takes a few seconds):
```bash
./manage_nodes.sh start
```

To stop the nodes:
```bash
./manage_nodes.sh stop
```

To mine the initial blocks for eve:
```bash
./script mine
```

Sending bitcoin from one user to another user:
```bash
./script send <from> <to> <amount in bitcoins>
```

Executing arbitrary bitcoin rpc calls:
```bash
./script command <who> <command>
```