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
    await bookRepo.mintBook(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");
	await bookRepo.mintBook(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");
    await bookRepo.mintBook(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h");

	let ow = await bookRepo.ownerOf(1);
	console.log("book 1 owner is " + ow);

    await alexandria.addBookForSale(1, "Java for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Java for the impatient");

	await alexandria.addBookForSale(2, "Ruby for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Ruby for the impatient");

	await alexandria.addBookForSale(3, "Python for the impatient", {from: accounts[0]});
    await alexandria.getBookByTitle("Python for the impatient");

	console.log(" All books added for sale ");

	await alexandria.buyBook(1, {from: accounts[1], value: 1000000000000000000});
	await alexandria.buyBook(2, {from: accounts[2], value: 1000000000000000000});
	await alexandria.buyBook(3, {from: accounts[2], value: 1000000000000000000});

	console.log(" buy two books ");

	let booksOfContract = await alexandria.getBooksByOwner(alexandria.address);
	console.log(`books of Contract owner ${booksOfContract} `);

	let booksOfFirstAccount = await alexandria.getBooksByOwner(accounts[1]);
	console.log(`books of first account ${accounts[1]} : ${booksOfFirstAccount} `);

	let booksOfSecondAccount = await alexandria.getBooksByOwner(accounts[2]);
	console.log(`books of second account ${accounts[2]} : ${booksOfSecondAccount} `);

	callback();
}