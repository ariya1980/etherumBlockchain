const fs = require('fs')

var contract
var admin

exports.init = function (web3, owner) {
  admin = owner
  // Read the compiled contract code
  var filePath = __dirname + '/../build/contracts/TokenERC20.json'
  let source = fs.readFileSync(filePath)
  let json = JSON.parse(source)

  // ABI description as JSON structure
  var abi = json.abi

  // address of the contract
  var address;
  for(var key in json.networks) {
    if(json.networks.hasOwnProperty(key)) {
        address = json.networks[key].address;
        break;
    }
  }
  console.log(address)

  // init contract object
  contract = new web3.eth.Contract(abi, address, {from: admin, gasPrice: '2000000'})

  if (contract) {
    console.log('successfully create Token contract')
  }
}

exports.getBalance = function (account) {	
  console.log('contract address : ' , contract.options.address)
  return contract.methods.balanceOf(account).call({from: account})
}

exports.newAccount = function (web3, owner, ph) {
  console.log('hint : ' , ph)
  return web3.eth.personal.newAccount(ph)
}

exports.sendCoin = function (sender, receiver, value, web3, admin) {
  console.log('contract address : ' , contract.options.address)
      //unlock
	  web3.eth.personal.unlockAccount(admin,"ps_edit",300000).then((response) => {
			console.log(' unlock account : ' ,response);
		}).catch((error) => {
			console.log(' unlock account : ' ,error);
		});
  return new Promise(function (resolve, reject) {
    contract.methods.transfer(receiver, value).send({from: sender})
    .then(function (receipt) {
      if (receipt) {
        console.log('transaction receipt', receipt)
        //resolve({result: true})
		resolve(receipt)
      }
      resolve({result: false})
    }).catch(function (err) {
      return reject(err)
    })
  })
}

exports.transferCoin = function (sender, receiver, value, web3, admin, by) {
  console.log('contract address : ' , contract.options.address)
      //unlock
	  web3.eth.personal.unlockAccount(admin,"ps_edit",300000).then((response) => {
			console.log(' unlock account : ' ,response);
		}).catch((error) => {
			console.log(' unlock account : ' ,error);
		});
  return new Promise(function (resolve, reject) {
    contract.methods.transferFrom(by,receiver, value).send({from: sender})
    .then(function (receipt) {
      if (receipt) {
        console.log('transaction receipt', receipt)
        //resolve({result: true})
		resolve(receipt)
      }
      resolve({result: false})
    }).catch(function (err) {
      return reject(err)
    })
  })
}


