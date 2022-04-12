

 
 # AlexandriaLibrary
 
 - truffle compile
 - truffle migrate --reset development  # --reset only for redeployments
 - truffle console --network development
 - let lib = await AlexandriaLibrary.deployed()
 - lib.addBook("the second  book title", "the second  book ipfs url")
 - lib.getBooksByOwner()
 - lib.getBookByTitle('the second  book title')
