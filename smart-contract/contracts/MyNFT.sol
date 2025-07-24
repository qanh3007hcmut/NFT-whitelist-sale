// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Pokemon NFT Collection
 * @author Nguyen Quoc Anh
 * @notice NFT Smart Contract Core for Pokemon-themed digital collectibles
 * @dev Extends ERC721 standard with custom minting permissions and URI handling
 */
contract MyNFT is ERC721, Ownable {
    uint256 public nextTokenId = 1;
    string internal baseTokenURI;
    mapping(address => bool) minter;
    
    /**
     * @notice Initializes the contract with a base token URI
     * @dev Sets up the ERC721 token with name "Pokemon" and symbol "PKM"
     * @param _baseTokenURI The base URI for token metadata
     */
    constructor(
        string memory _baseTokenURI
    ) ERC721("Pokemon", "PKM") Ownable(msg.sender) {
        baseTokenURI = _baseTokenURI;
        minter[msg.sender] = true;
    }

    /**
     * @notice Mints a new token to the specified address
     * @dev Only authorized minters can call this function
     * @param to The address that will receive the minted token
     */
    function mint(address to) external {
        require(minter[msg.sender], "Unauthorized access");
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    /**
     * @notice Returns the base URI for token metadata
     * @dev Overrides the ERC721 _baseURI function
     * @return The base URI string
     */
    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * @notice Returns the URI for a given token ID
     * @dev Appends ".json" to the token URI from the parent implementation
     * @param tokenId The ID of the token to query
     * @return The token URI string
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return string.concat(super.tokenURI(tokenId), ".json");
    }

    /**
     * @notice Updates the base URI for token metadata
     * @dev Can only be called by the contract owner
     * @param baseURI The new base URI to set
     */
    function setBaseTokenURI(string memory baseURI) external onlyOwner {
        baseTokenURI = baseURI;
    }
    
    function addMinter(address _minter) external onlyOwner {
        minter[_minter] = true;
    }
}
