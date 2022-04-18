

 
 # AlexandriaLibrary
 
 The idea is as: We have a books warehouse where we mint NFT books. Then if we need for a book to be on sale, then we give ownership of this newly minted book, to the warehouse in order to add this for sale.
 As goal we want to be able to sale books and also rent them for a specific period of time which after that the user should not have more access to the NFT book. This NFT book shouldbe able for a specific time in terms of block numbers.

Business steps:
  - Mint a new Book in the BookRepository contract, and add as owner the AlexandriaLibrary contract. This in order for the latest, to be able and sale or rent the book to users.
  - Add the book in AlexandriaLibrary contract (manually as for now)

 - `truffle compile`
 - `truffle migrate --reset development`  # --reset only for re-deployments
 - `truffle console --network development`
 
Run script guide:
    - `truffle(development)> migrate --reset`
    - `truffle(development)>  exec scripts/setup-library.js`

 OR follow step by step guide, bellow:

 Get instance of each contract
 - `let bookRepo = await BookRepository.deployed()`
 - `let alexandria = await AlexandriaLibrary.deployed()`

Mint a book NFT and add as owner teh AlexandriaLibrary `contract`
 - `bookRepo.sellItem(alexandria.address, "https://ipfs.io/ipfs/QmPUBKc7fMStJWDevfdMXGGC4NwxCNATcVXbcB481As53h")`
 - `bookRepo.ownerOf(1)` // NFT ID is automatically increased by 1, therefore our first NFT has `ID=1`

Add book in AlexandriaLibrary in order to be in market place for sale or  rent
 - `alexandria.addBook(1, "Java for the impatient")`
 - `alexandria.getBookByTitle("Java for the impatient")`

Rent a book
 - `alexandria.buyBook(1, {value: 1000000000000000000})`
 - `alexandria.getBookTokenUrl(1)`
 - `bookRepo.rep.ownerOf(1)`


