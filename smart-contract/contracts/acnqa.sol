// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ACNQA is ERC721URIStorage, Ownable {
    uint256 private _currentTokenId;
    string private _baseTokenURI;    
    mapping(address => bool) public whitelist;
    uint256 public maxSupply = 10000;
    mapping(address => uint256) public mintedPerAddress;
    uint256 public maxPerAddress = 5;
    
    event NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI);

    constructor(string memory baseURI) ERC721("AppsCyclone NQA Collection", "ACNQA") Ownable(msg.sender) {
        _baseTokenURI = baseURI;
        whitelist[msg.sender] = true;
        _currentTokenId = 0;
    }
    
    function mintNFT(address recipient, string memory tokenURI) public inWhitelist returns (uint256) {
        require(_currentTokenId < maxSupply, "Max supply reached");
        require(mintedPerAddress[recipient] < maxPerAddress, "Max tokens per address reached");
        require(recipient != address(0), "Cannot mint to zero address");

        // Increment token ID
        _currentTokenId += 1;
        uint256 newItemId = _currentTokenId;
        
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        // Increment the recipient's minted count
        mintedPerAddress[recipient]++;
        
        emit NFTMinted(recipient, newItemId, tokenURI);

        return newItemId;
    }
    
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    // Function to update max supply
    function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
        require(newMaxSupply >= _currentTokenId, "New max supply must be >= current supply");
        maxSupply = newMaxSupply;
    }
    
    // Function to update max tokens per address
    function setMaxPerAddress(uint256 newMaxPerAddress) public onlyOwner {
        maxPerAddress = newMaxPerAddress;
    }
    
    // Modifier to check if an address is whitelisted
    modifier inWhitelist() {
        require(whitelist[msg.sender], "Not in whitelist");
        _;
    }
    
    // Function to add addresses to whitelist
    function addToWhitelist(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }
    
    // Function to remove addresses from whitelist
    function removeFromWhitelist(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = false;
        }
    }
    
    // Function to withdraw ETH from contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdrawal failed");
    }
    
    // Function to withdraw ERC20 tokens from contract
    function withdrawToken(address tokenAddress) public onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");
        require(token.transfer(owner(), balance), "Token withdrawal failed");
    }
    
    // Function to receive ETH
    receive() external payable {}
    fallback() external payable {}
    function currentTokenId() public view returns (uint256) {
        return _currentTokenId;
    }
}