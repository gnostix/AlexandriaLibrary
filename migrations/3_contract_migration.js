const AlexandriaLibrary = artifacts.require("AlexandriaLibrary");
const BookRepository = artifacts.require("BookRepository");

module.exports = async function (deployer) {
  let libInstance = await BookRepository.deployed()
  console.log("=====>  " + libInstance.address);
  await deployer.deploy(AlexandriaLibrary, libInstance.address);
};
