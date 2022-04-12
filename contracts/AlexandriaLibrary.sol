// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

contract AlexandriaLibrary {
    string public constant NAME = "The Great Library of Alexandria";
    address owner;
    mapping(address => Book[]) public booksByOwner;
    mapping(string => Book) public bookByTitle;

    struct Book {
        string title;
        string ipfsurl;
        address bookOwner;
    }

    event BookAddedToLibrary(address bookOwner, string bookTitle);

    constructor() {
        owner = msg.sender;
    }

    function addBook(string memory title, string memory ipfsUrl) public returns (bool) {
        Book memory newBook = Book(title, ipfsUrl, msg.sender);
        booksByOwner[msg.sender].push(newBook);
        bookByTitle[title] = newBook;

        emit BookAddedToLibrary(msg.sender, title);

        return true;
    }

    function getMyBooks() public view returns (Book[] memory) {
        return booksByOwner[msg.sender];
    }

    function getBooksByOwner(address bookOwner) public view returns (Book[] memory) {
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
