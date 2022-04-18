const truffle = require("truffle");
const BookRepository = artifacts.require("BookRepository");
const AlexandriaLibrary = artifacts.require("AlexandriaLibrary");

module.exports = async function(callback) {
	console.log("IT WORKS");
	
	let bookRepo = await BookRepository.deployed();
	console.log("Book Repo address " + bookRepo.address);

    let alexandria = await AlexandriaLibrary.deployed();
	console.log("Alexandria address " + alexandria.address);

	const accounts = await web3.eth.getAccounts();
	console.log(accounts[0]);

	//add three random books
    await bookRepo.sellItem(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");
	await bookRepo.sellItem(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");
    await bookRepo.sellItem(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");

	let ow = await bookRepo.ownerOf(1);
	console.log("book 1 owner is " + ow);

    await alexandria.addBook(1, "Java for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Java for the impatient");

	await alexandria.addBook(2, "Ruby for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Ruby for the impatient");

	await alexandria.addBook(3, "Python for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Python for the impatient");

	let books = await alexandria.getBooksByOwner(alexandria.address);
	console.log(books);

	callback();
}