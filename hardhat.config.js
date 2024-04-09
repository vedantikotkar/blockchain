require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",

  networks:{
    sepolia:{
      url:`https://eth-sepolia.g.alchemy.com/v2/y-46--elI5Lr_PlK0Isefz4NApOKp6e6`,
      accounts:[`7829a2f319d47c073df69fe331facc59e8fa20dc76f3ceac925ec8646999cbed`]
    }

  },
  etherscan:{
    apiKey:{
      sepolia:`y-46--elI5Lr_PlK0Isefz4NApOKp6e6`
    }
  }
};
