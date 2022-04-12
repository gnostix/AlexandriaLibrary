const AlexandriaLibrary = artifacts.require("AlexandriaLibrary");

module.exports = function (deployer) {
  deployer.deploy(AlexandriaLibrary);
};
