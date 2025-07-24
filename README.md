# Pokemon NFT Collection (PKM)

## Overview
A unique ERC-721 NFT collection on the Ethereum Sepolia testnet featuring Pokemon-themed digital collectibles. This exclusive collection uses a Merkle tree-based whitelist system with a configurable supply cap (default: 1000 tokens) and a per-wallet minting limit (default: 5 NFTs).

## Contract Details
- **NFT Contract**: [0x1D2Bd1C80D67B454bC5533a14B3F328c58001119](https://sepolia.etherscan.io/address/0x1D2Bd1C80D67B454bC5533a14B3F328c58001119)
- **Whitelist Sale Contract**: [0x2b7D022dF0B66Ae57BF8bA68c295C47B4a79738A](https://sepolia.etherscan.io/address/0x2b7D022dF0B66Ae57BF8bA68c295C47B4a79738A)
- **Token Standard**: ERC-721
- **Symbol**: PKM
- **Name**: Pokemon
- **Default Max Supply**: 1000 NFTs (configurable)
- **Default Minting Limit**: 5 NFTs per wallet (configurable)

## Core Features
- Merkle tree-based whitelist verification with MerkleProof library
- Role-based access control with MINTER_ROLE for authorized minting
- Configurable supply and per-wallet minting limits
- Secure fund withdrawal mechanisms (ETH & ERC20)
- Customizable base token URI with automatic ".json" suffix
- Event logging for minting, supply updates, and configuration changes

## Current Collection
Minted tokens:
1.  **Token #1**:   "Dave Starbelly" - A friendly OpenSea Creature that enjoys long swims in the ocean
2.  **Token #2**:   "Psyduck" - Friendly Pokemon Creature that enjoys long swims in the ocean
3.  **Token #3**:   "Pikachu - Deadpool Edition" - Not only a friendly Pokemon creature, but also immortal and deadly
4.  **Token #4**:   "Lucario" - It’s said that no foe can remain invisible to Lucario, since it can detect auras—even those of foes it could not otherwise see
5.  **Token #5**:   "Armarouge" - Armarouge evolved through the use of a set of armor that belonged to a distinguished warrior. This Pokémon is incredibly loyal
6.  **Token #6**:   "Ceruledge - The fiery blades on its arms burn fiercely with the lingering resentment of a sword wielder who fell before accomplishing their goal
7.  **Token #7**:   "Regigigas" - It is said to have made Pokémon that look like itself from a special ice mountain, rocks, and magma
8.  **Token #8**:   "Necrozma" - It looks somehow pained as it rages around in search of light, which serves as its energy. It’s apparently from another world
9.  **Token #9**:   "Reshiram" - This legendary Pokémon can scorch the world with fire. It helps those who want to build a world of truth
10. **Token #10**:  "Gouging Fire" - There are scant few reports of this creature being sighted. One short video shows it rampaging and spouting pillars of flame


## Technical Specifications
- **Metadata**: JSON files stored at configurable base URI with automatic ".json" extension
- **Development**: Solidity ^0.8.28
- **Framework**: OpenZeppelin ERC721, AccessControl, Ownable, SafeERC20, MerkleProof
- **Whitelist Verification**: Merkle Proof verification with keccak256 hashing
- **Access Control**: Role-based permissions with DEFAULT_ADMIN_ROLE and MINTER_ROLE

## Usage Guide

### Collectors
- **Mint NFTs**: Call `mintNFT(bytes32[] calldata proofs)` with your Merkle proof if whitelisted (maximum 5 per address by default)
- **Check Collection Size**: Call `_getTotalSupply()` to see how many NFTs have been minted
- **View Token Metadata**: Token URIs automatically append ".json" to the base URI

### Contract Owner
- **Whitelist Management**: Update the Merkle root with `setMerkleRoot(bytes32 newMerkleRoot)`
- **Collection Parameters**: 
  - `setMaxSupply(uint256 maxSupply)` to change the maximum collection size
  - `setMaxMintPerAddresss(uint256 newLimit)` to adjust per-wallet minting limit
- **NFT Contract Management**:
  - `setBaseTokenURI(string memory baseURI)` to update the metadata location (requires DEFAULT_ADMIN_ROLE)
  - Grant MINTER_ROLE to authorize additional minting addresses
- **Treasury Management**: 
  - `withdraw()` for ETH
  - `withdrawToken(address token)` for ERC20 tokens

## Interact with the contract on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x2b7D022dF0B66Ae57BF8bA68c295C47B4a79738A).
## View demo test with the contract on [Youtube](https://youtu.be/XFmeM0SQlRU).