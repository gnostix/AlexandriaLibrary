const BookRepository = artifacts.require("BookRepository");

module.exports = function (deployer) {
  deployer.deploy(BookRepository);
};
