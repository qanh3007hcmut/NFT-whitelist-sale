// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract MyEvent {
    event TokenMinted(address indexed to, uint256 indexed tokenId);

    event MaxSupplyUpdated(uint256 newMaxSupply);
    event MerkleRootUpdated(bytes32 newMerkleRoot);
    event MintLimitUpdated(uint256 newMintLimit);
    event BaseURIUpdated(string _newBaseURI);
}