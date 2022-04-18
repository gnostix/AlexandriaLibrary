// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

import "./BookRepository.sol";

contract AlexandriaLibrary {
    // The address of the Books Repository
    BookRepository public bookRepo;

    // The name of this Contract
    string public constant NAME = "The Great Library of Alexandria";

    // The Contract's owner address
    address owner;

    // Mapping from Owner to a list of books
    mapping(address => Book[]) public booksByOwner;

    // mapping book by ID
    mapping(uint256 => Book) bookIdByBook;

    // Mapping from Book title to Book entity
    mapping(string => Book) public bookByTitle;

    // Mapping for address by rented books
    mapping(address => Book[]) public addressByRentedBooks;

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

    function addBook(uint256 bookId, string memory title)
        public
        contractIsBookOwner(bookId)
        returns (bool)
    {
        Book memory newBook = Book(bookId, title, address(this));
        booksByOwner[address(this)].push(newBook);
        bookByTitle[title] = newBook;
        bookIdByBook[bookId] = newBook;

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
        require(book.bookId != 0);

        addressByRentedBooks[msg.sender].push(book);
        bookIdByAddresses[bookId].push(msg.sender);

        bookRepo.transferFrom(address(this), msg.sender, bookId);
        return getBookTokenUrl(bookId);
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

        addressByRentedBooks[msg.sender].push(book);
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

    function getMyRentedBooks() public view returns (Book[] memory) {
        return addressByRentedBooks[msg.sender];
    }

    function getMyBooks() public view returns (Book[] memory) {
        return booksByOwner[msg.sender];
    }

    function getBooksByOwner(address bookOwner)
        public
        view
        returns (Book[] memory)
    {
        return booksByOwner[bookOwner];
    }

    function getBookByTitle(string memory title)
        public
        view
        returns (Book memory)
    {
        return bookByTitle[title];
    }
}
