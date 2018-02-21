'use strict';

const bitcoin = require('bitcoinjs-lib');
const util = require('util')
const reverse = require('buffer-reverse');
const sha256 = require('sha256');

function toJson(tx) {
	return {
		'txid': reverse(tx.getHash()).toString('hex'),
		'hash': reverse(tx.getHash()).toString('hex'),
		'version': tx.version,
		'size': tx.weight(),
		'vsize': tx.virtualSize(),
		'locktime': tx.locktime,
		'vin': tx.ins.map((input) => {
			return {
				'txid': reverse(input.hash).toString('hex'),
				'vout': input.index,
				'sequence': input.sequence,
			};
		}),
		'vout': tx.outs.map((out, index) => {
			return {
				'value': out.value / 100000000,
				'n': index,
				'scriptPubKey': {
					'hex': out.script.toString('hex'),
					'type': 'pubkeyhash',
					'address': bitcoin.address.fromOutputScript(out.script),
				},
			};
		})
	};
}


function generateTxs(total = 10, type = 0) {
	if(type !== 0 && type !== 1 && type !== 2) {
		throw new Error('Wrong type %s', type);
	}

	const maxOutputs = (type == 0 ? 1 : 2);

	const outputs = [{
		transaction: '61d520ccb74288c96bc1a2b20ea1c0d5a704776dd0164a396efec3ea7040349d',
		index: 0,
		amount: 12000 * Math.pow(maxOutputs, total) + 12000 * total,
	}];
	const txs = [];

	for(let i = 0; i < total; ++i) {
		let txb = new bitcoin.TransactionBuilder();

		const index = Math.floor((Math.random() * outputs.length));
		const output = outputs[index];
		outputs.splice(index, 1);
		if(type == 2) {
			txb.addInput(output.transaction, output.index);
			if(Math.random() < 0.2) {
				txb.addInput(sha256(Math.random().toString()), 0);
			}
		} else {
			txb.addInput(output.transaction, output.index);
		}

		const amountOfOutputs = Math.floor((Math.random() * maxOutputs) + 1);
		const outs = [];
		for(let j = 0; j < amountOfOutputs; ++j) {
			txb.addOutput(bitcoin.ECPair.makeRandom({ network: bitcoin.networks.regtest }).getAddress(), Math.floor((output.amount - 9000)/amountOfOutputs));
			outs.push({
				index: j,
				amount: Math.floor((output.amount - 9000)/amountOfOutputs),
			})
		}
		txb.addOutput(bitcoin.ECPair.makeRandom({ network: bitcoin.networks.regtest }).getAddress(), 9000);

		const tx = txb.buildIncomplete();
		txs.push({
			transaction: tx,
			hash: tx.getHash(),
		});

		for(let j = 0; j < amountOfOutputs; ++j) {
			outputs.push({
				transaction: tx.getHash(),
				index: outs[j].index,
				amount: outs[j].amount,
			});
		}
	}
	return txs;
}

let txs = [];

if(process.argv.length == 2) {
	txs = generateTxs();
} else if(process.argv.length == 3) {
	txs = generateTxs(parseInt(process.argv[2], 10));
} else if(process.argv.length == 4) {
	txs = generateTxs(parseInt(process.argv[2], 10), parseInt(process.argv[3], 10));
} else {
	console.error('Too much parameters!');
	return 1;
}

console.log(JSON.stringify(txs.map(tx => toJson(tx.transaction))));
