// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Event.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
abstract contract BaseStorage is Ownable, MyEvent {
    uint256 public _nextTokenId = 1;
    uint256 public _maxSupply = 1000;
    uint256 public _maxMintPerAddress = 5;
    
    bytes32 public _merkleRoot;
    string public _baseTokenURI;

    mapping(address => uint8) internal _mintPerAddr;
    
    function _getTotalSupply() public view returns (uint256) {return _nextTokenId - 1;}

    function _incrementTokenId() internal {_nextTokenId += 1;}
    function setMaxSupply(uint256 maxSupply) external onlyOwner {
        require(maxSupply > 0, "Max supply must be greater than zero");
        _maxSupply = maxSupply;
        emit MaxSupplyUpdated(_maxSupply);
    }
    function setMaxMintPerAddresss(uint256 newLimit) external onlyOwner {
        require(newLimit > 0, "Mint Limit must be greater than zero");
        _maxMintPerAddress = newLimit;
        emit MintLimitUpdated(_maxMintPerAddress);
    }
    function setMerkleRoot(bytes32 newMerkleRoot) public onlyOwner {
        require(newMerkleRoot != bytes32(0), "Merkle Root cannot be 0");
        _merkleRoot = newMerkleRoot;
        emit MerkleRootUpdated(_merkleRoot);
    }
    function setBaseTokenURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
        emit BaseURIUpdated(_baseTokenURI);
    }
}