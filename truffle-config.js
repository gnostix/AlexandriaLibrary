const HDWalletProvider = require('@truffle/hdwallet-provider')
require('dotenv').config()
const MNEMONIC = process.env.MNEMONIC;
const INFURA_API_KEY = process.env.INFURA_API_KEY;

module.exports = {

  networks: {
    dev: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" 
    },
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/v3/" + INFURA_API_KEY)
      },
      network_id: 3,
      gas: 4000000      //make sure this gas allocation isn't over 4M, which is the max
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(MNEMONIC, "https://rinkeby.infura.io/v3/" + INFURA_API_KEY)
      },
      network_id: 4,
      gas: 5500000,
      gasPrice: 100000000000,
      networkCheckTimeout: 60000,
    },
    kovan: {
      provider: function () {
        return new HDWalletProvider(MNEMONIC, "https://kovan.infura.io/v3/" + INFURA_API_KEY)
      },
      network_id: 42,
      gas: 672197,
      gasPrice: 10000000000,
      networkCheckTimeout: 60000,
    }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
       version: "0.8.13",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  },
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  },
  plugins: [
    'truffle-plugin-verify',
    'truffle-plugin-setup-library'
  ]
 
};
