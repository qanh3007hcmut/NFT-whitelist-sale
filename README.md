# Pokemon NFT Collection (PKM)

## Overview
A unique ERC-721 NFT collection on the Ethereum Sepolia testnet featuring Pokemon-themed digital collectibles. This exclusive collection uses a Merkle tree-based whitelist system with a configurable supply cap (default: 1000 tokens) and a per-wallet minting limit (default: 5 NFTs).

## Contract Details
- **NFT Contract**: [0x76aA01653860d06bBE110E8A64085Ca2330d1924](https://sepolia.etherscan.io/address/0x76aA01653860d06bBE110E8A64085Ca2330d1924)
- **Whitelist Sale Contract**: [0x4E9463F95263Cbd998c2b05d87970404A267E411](https://sepolia.etherscan.io/address/0x4E9463F95263Cbd998c2b05d87970404A267E411)
- **Token Standard**: ERC-721
- **Symbol**: PKM
- **Name**: Pokemon
- **Default Max Supply**: 1000 NFTs (configurable)
- **Default Minting Limit**: 5 NFTs per wallet (configurable)

## Core Features
- Merkle tree-based whitelist verification
- Configurable supply and per-wallet minting limits
- Secure fund withdrawal mechanisms (ETH & ERC20)
- Customizable base token URI

## Current Collection
Minted tokens:
1. **Token #1**: "Dave Starbelly" - A friendly OpenSea Creature that enjoys long swims in the ocean
2. **Token #2**: "Psyduck" - Friendly Pokemon Creature that enjoys long swims in the ocean
3. **Token #3**: "Pikachu - Deadpool Edition" - Not only a friendly Pokemon creature, but also immortal and deadly

## Technical Specifications
- **Metadata**: JSON files stored at configurable base URI
- **Development**: Solidity ^0.8.28
- **Framework**: OpenZeppelin ERC721, Ownable, SafeERC20
- **Whitelist Verification**: Merkle Proof verification

## Usage Guide

### Collectors
- **Mint NFTs**: Call `mintNFT(bytes32[] calldata proofs)` with your Merkle proof if whitelisted (maximum 5 per address by default)
- **Check Collection Size**: Call `_getTotalSupply()` to see how many NFTs have been minted

### Contract Owner
- **Whitelist Management**: Update the Merkle root with `setMerkleRoot(bytes32 newMerkleRoot)`
- **Collection Parameters**: 
  - `setMaxSupply(uint256 maxSupply)` to change the maximum collection size
  - `setMaxMintPerAddresss(uint256 newLimit)` to adjust per-wallet minting limit
- **NFT Contract Management**:
  - `setBaseTokenURI(string memory baseURI)` to update the metadata location
  - `addMinter(address _minter)` to authorize additional minting addresses
- **Treasury Management**: 
  - `withdraw()` for ETH
  - `withdrawToken(address token)` for ERC20 tokens

Interact with the contract on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x4E9463F95263Cbd998c2b05d87970404A267E411).