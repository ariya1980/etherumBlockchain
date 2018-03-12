var Web3 = require('web3')
var MetaCoin = require('./metacoin.js')

//const URL = 'http://localhost:8000'
const URL = 'http://localhost:8545'

var admin, accounts, web3

function initializeDapp (onComplete) {
  console.log('initializing dapp establishing connection with ' + URL + '...')
  if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider)
  } else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider(URL))
  }

  if (web3) {
    console.log('getting accounts')
    return web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        console.log('There was an error fetching your accounts.')
        return
      }
      if (accs.length === 0) {
        console.log('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.')
        return
      }
      console.log('successfully retreive all account')

      accounts = accs
      console.log(accounts)
      admin = accs[0]
      console.log('admin account : ', admin)
	  
	  //unlock
	  web3.eth.personal.unlockAccount(admin,"chain",300000).then((response) => {
			console.log(' unlock account : ' ,response);
		}).catch((error) => {
			console.log(' unlock account : ' ,error);
		});

      MetaCoin.init(web3, admin)
      onComplete()
    })
  } else {
    console.log('error establishing connection with DApp via ', URL)
  }
}

const router = require('express').Router()

router.post('/test', function (req, res) {
  console.log('/test: request body', req.body)
})

router.post('/newAccount', function (req, res) {
  console.log('/newAccount: request body', req.body)
  if (!req.body.passwords) {
    return res.status(400).json({
      message: 'incomplete parameter'
    })
  }
  MetaCoin.newAccount(web3, admin,req.body.passwords)
  .then(function (result) {
    var response = {
      result: result
    }
    console.log('/newAccount: response', response)
    return res.status(200).json(response)
  }).catch(function (error) {
    return res.status(500).json({
      message: error.message
    })
  })
})

router.post('/balance', function (req, res) {
  console.log('/balance: request body', req.body)
  if (!req.body.account) {
    return res.status(400).json({
      message: 'incomplete parameter'
    })
  }
  MetaCoin.getBalance(req.body.account)
  .then(function (result) {
    var response = {
      result: result
    }
    console.log('/balance: response', response)
    return res.status(200).json(response)
  }).catch(function (error) {
    return res.status(500).json({
      message: error.message
    })
  })
})

router.post('/send', function (req, res) {
  console.log('/send: request body', req.body)
  if (!req.body) {
    return res.status(400).json({
      message: 'incomplete parameter'
    })
  }
  var sender = req.body.sender
  var from = req.body.from
  var to = req.body.to
  var value = req.body.value

  if (!(to && value && sender)) {
    return res.status(400).json({
      message: 'incomplete parameter'
    })
  }

  MetaCoin.sendCoin(from || sender, to, value, web3, admin)
  .then(function (result) {
    console.log('/send: response', result)
    return res.status(200).json(result)
  }).catch(function (error) {
    return res.status(500).json({
      message: error.message
    })
  })
})

exports.contracts = router
exports.initializeDapp = initializeDapp
