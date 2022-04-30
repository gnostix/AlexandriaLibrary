// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;
pragma experimental ABIEncoderV2;

import "./BookRepository.sol";

contract AlexandriaLibrary {
    // The address of the Books Repository
    BookRepository public bookRepo;

    // The name of this Contract
    string public constant NAME = "The Great Library of Alexandria";

    // The Contract's owner address
    address owner;

    Book[] public booksForSale;

    // Mapping from Owner to a list of books ids
    mapping(address => uint256[]) public booksByOwner;

    // mapping book by ID
    mapping(uint256 => Book) bookIdByBook;

    // Mapping from Book title to Book entity
    mapping(string => Book) public bookByTitle;

    // mapping for book by rented addresses
    mapping(uint256 => address[]) bookIdByAddresses;

    // mapping deadline per book rented (0x2ww2 => 1 => timestamp)
    mapping(address => mapping(uint256 => uint256)) addressByRentedBookByDeadline;

    // The book entity
    struct Book {
        uint256 bookId;
        string title;
        address bookOwner;
    }

    // Event fired when  new book is registered for sales
    event BookAddedToLibrary(string bookTitle);

    /**
     * Garanties that this contract is the owner of this specific NFT book ID
     * @param _bookId the NFT ID for this book
     */
    modifier contractIsBookOwner(uint256 _bookId) {
        address bookOwnerAddr = bookRepo.ownerOf(_bookId);
        require(
            bookOwnerAddr == address(this),
            "The book is not under Warehouse ownership"
        );
        _;
    }

    /**
     * Garanties that this msg.sender is the tokenid owner
     * @param tokenId takes as param the tokenId
     */
    modifier ownerOfTokenId(uint256 tokenId) {
        address tokenOwner = bookRepo.ownerOf(tokenId);
        require(tokenOwner == msg.sender, "You 're not the owner of this NFT!");
        _;
    }

    constructor(address _bookRepo) {
        bookRepo = BookRepository(_bookRepo);
        owner = msg.sender;
    }

    function addBookForSale(uint256 bookId, string memory title)
        public
        contractIsBookOwner(bookId)
        returns (bool)
    {
        Book memory newBook = Book(bookId, title, address(this));
        booksByOwner[address(this)].push(bookId);
        bookByTitle[title] = newBook;
        bookIdByBook[bookId] = newBook;

        booksForSale.push(newBook);

        emit BookAddedToLibrary(title);

        return true;
    }

    /**
     * Buy a new book
     * @param bookId add this param in order to buy the book (as NFT)
     */
    function buyBook(uint256 bookId) public payable returns (string memory) {
        require(msg.value >= 1 ether, "This book will cost 1 ether to buy");

        Book memory book = bookIdByBook[bookId];
        require(book.bookId != 0, "This book is not found!");

        // set the new book owner in our library
        book.bookOwner = msg.sender;
        bookIdByBook[bookId] = book;

        // remove bookId by the same index
        removeBookIdFromSales(bookId, address(this));

        // add bookId to new owner by the same index, for fast deletion

        booksByOwner[msg.sender].push(bookId);
        bookIdByAddresses[bookId].push(msg.sender);

        bookRepo.transferFrom(address(this), msg.sender, bookId);
        return getBookTokenUrl(bookId);
    }

    function removeBookIdFromSales(uint256 bookId, address bookOwner) internal {
        uint256[] memory bookIds = booksByOwner[bookOwner];
        uint256 length = bookIds.length - 1;
        uint256[] memory newBookIds = new uint256[](length);

        uint256 c = 0;
        for (uint256 i = 0; i < bookIds.length; i++) {
            uint256 _bookId = bookIds[i];
            if (bookId != _bookId) {
                newBookIds[c] = bookIds[i];
                c++;
            }
        }
        booksByOwner[bookOwner] = newBookIds;
    }

    /**
     * Rent a book for a given amount and for a specific time
     * @param bookId get as parameetr the bookId
     */
    function rentBook(uint256 bookId) public payable returns (string memory) {
        require(msg.value >= 1 ether, "This book will cost 1 ether to rent");

        Book memory book = bookIdByBook[bookId];
        require(book.bookId != 0);

        // not used currently. Is a place holder
        uint256 timeNow = block.timestamp;
        uint256 fiveMinutesRentDeadline = timeNow + 300 seconds;

        // booksByOwner[msg.sender][bookId] = bookId;
        bookIdByAddresses[bookId].push(msg.sender);

        addressByRentedBookByDeadline[msg.sender][
            bookId
        ] = fiveMinutesRentDeadline;

        bookRepo.transferFrom(address(this), msg.sender, bookId);
        return getBookTokenUrl(bookId);
    }

    /**
     * Stop renting the specific book. In this case you get back 50% of your deposit.
     * Or if the time of deadline has passed then you don't get any refund
     */
    function stopRentingBook(uint256 bookId) public {
        if (
            addressByRentedBookByDeadline[msg.sender][bookId] < block.timestamp
        ) {
            delete addressByRentedBookByDeadline[msg.sender][bookId];
            payable(msg.sender).transfer(1 ether);
        } else {
            // do not return any ether since the deadline has passed
            delete addressByRentedBookByDeadline[msg.sender][bookId];
        }
    }

    /**
     * Get for a NFT book ID the token URL
     */
    function getBookTokenUrl(uint256 tokenId)
        public
        view
        ownerOfTokenId(tokenId)
        returns (string memory)
    {
        return bookRepo.tokenURI(tokenId);
    }

    // to be defined
    function getMyRentedBooks() public view returns (Book[] memory books) {
        uint256[] memory bookIds = booksByOwner[msg.sender];
        for (uint256 i = 0; i < bookIds.length; i++) {
            books[i] = bookIdByBook[bookIds[i]];
        }

        return books;
    }

    function getMyBooks() public view returns (Book[] memory books) {
        books = getBooksByOwner(msg.sender);
    }

    function getBooksByOwner(address bookOwner)
        public
        view
        returns (Book[] memory books)
    {
        uint256[] memory bookIds = booksByOwner[bookOwner];
        books = new Book[](bookIds.length);
        for (uint256 i = 0; i < bookIds.length; i++) {
            uint256 bookId = bookIds[i];
            require(bookId != 0, " Book id with zero id");
            Book memory book = bookIdByBook[bookId];
            books[i] = book;
        }

        return books;
    }

    function getBooksIdsByOwner(address bookOwner)
        public
        view
        returns (uint256[] memory books)
    {
        books = booksByOwner[bookOwner];
    }

    function getBookByTitle(string memory title)
        public
        view
        returns (Book memory)
    {
        return bookByTitle[title];
    }
}
