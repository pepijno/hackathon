## prerequisites

node & npm [https://nodejs.org/en/download/](https://nodejs.org/en/download/)
git & git bash [https://git-scm.com/downloads](https://git-scm.com/downloads)

## Setup

Open git bash. Execute
	```git clone https://github.com/pepijno/hackathon.git```
	```cd hackathon```
	```npm install```
In the meantime, download the bitcoin core zip [https://bitcoin.org/en/download](https://bitcoin.org/en/download) and copy bitcoind.exe and bitcoin-cli.exe from the bin folder to the hackathon folder.

## Generating transactions

Usage:
	```node index.js <amount> <type>```

```amount```: The amount of transactions to generate. Defaults to ```10```.
```type```: The type of transactions, can be either ```0```, ```1``` or ```2```. ```1``` means each transaction has exactly two outputs: one regular output and one change output. Using type ```1``` will generate transactions with either two or three outputs. Using type ```2``` generate transactions with either two or three outputs and randomly adds extra inputs from outside the tree to some of the transactions. ```type``` defaults to ```0```.