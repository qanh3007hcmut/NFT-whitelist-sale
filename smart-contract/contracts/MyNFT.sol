// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 public nextTokenId = 1;
    string internal baseTokenURI;
    mapping(address => bool) minter;

    constructor(
        string memory _baseTokenURI
    ) ERC721("Pokemon", "PKM") Ownable(msg.sender) {
        baseTokenURI = _baseTokenURI;
        minter[msg.sender] = true;
    }

    function mint(address to) external {
        require(minter[msg.sender], "Unauthorized access");
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return string.concat(super.tokenURI(tokenId), ".json");
    }

    function setBaseTokenURI(string memory baseURI) external onlyOwner {
        baseTokenURI = baseURI;
    }

    function addMinter(address _minter) external onlyOwner {
        minter[_minter] = true;
    }
}
