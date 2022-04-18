const truffle = require("truffle");
// const BookRepository = require("BookRepository");
// const AlexandriaLibrary = require("AlexandriaLibrary");

    /**
 * Outputs `Hello, World!` when running `truffle run hello`,
 * or `Hello, ${name}` when running `truffle run hello [name]`
 * @param {Config} config - A truffle-config object.
 * Has attributes like `truffle_directory`, `working_directory`, etc.
 */
module.exports = async (config) => {
    // config._ has the command arguments.
    // config_[0] is the command name, e.g. "hello" here.
    // config_[1] starts remaining parameters.
    console.log("==================================");

    truffle.migrate();
    // let bookRepo = await config.BookRepository.deployed();
    // let alexandria = await config.AlexandriaLibrary.deployed();
    // bookRepo.sellItem(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");
    // bookRepo.ownerOf(1);
    // alexandria.addBook(1, "Java for the impatient");
    // alexandria.getBookByTitle("Java for the impatient");

    if (config.help) {
      console.log(`Usage: truffle run hello [name]`);
      return;
    }

  }
