// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BookRepository is ERC721URIStorage, Ownable {
    bool private status = true;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event BookMinted(address _by, uint256 _tokenId);

    constructor() ERC721("Books Warehouse", "BOOX") {}

    modifier contractActivated() {
        require(
            status,
            "contractActivated: This book is not activated, in order to be on sale!"
        );
        _;
    }

    function sellItem(address buyer, string memory tokenURI)
        public
        contractActivated
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(buyer, newItemId);
        _setTokenURI(newItemId, tokenURI);

        emit BookMinted(buyer, newItemId);
        return newItemId;
    }

    /* Only the contract owner can start/stop this contract to mint new books */
    function activateSell(bool activation) public onlyOwner {
        status = activation;
    }
}
