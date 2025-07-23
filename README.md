# AppsCyclone NQA Collection (ACNQA)

## Overview
AppsCyclone NQA Collection is an ERC-721 NFT collection deployed on the Ethereum Sepolia testnet featuring unique digital collectibles. The collection has a maximum supply of 10,000 tokens with a limit of 5 tokens per wallet address.

## Contract Information
- **Address**: [0x7dd465D9f639012D11E04f39fd236962B1353D39](https://sepolia.etherscan.io/address/0x7dd465D9f639012D11E04f39fd236962B1353D39)
- **Standard**: ERC-721
- **Symbol**: ACNQA
- **Max Supply**: 10,000 NFTs
- **Mint Limit**: 5 tokens per address

## Key Features
- Whitelist-only minting system
- Owner-controlled whitelist management
- Adjustable supply and minting limits
- ETH and ERC20 token withdrawal functionality

## Collection Status
Currently minted tokens:
1. **Token #1**: "Dave Starbelly" - A friendly OpenSea Creature that enjoys long swims in the ocean
2. **Token #2**: "Psyduck" - Friendly Pokemon Creature that enjoys long swims in the ocean
3. **Token #3**: "Pikachu - Deadpool Edition" - Not only a friendly Pokemon creature, but also immortal and deadly

## Technical Details
- **Metadata Storage**: Pinata IPFS service
- **Smart Contract**: Solidity ^0.8.0
- **Dependencies**: OpenZeppelin ERC721 implementation

## How to Interact

### For Collectors
- Check whitelist status: Call `whitelist` function with your address
- Mint NFTs: Use `mintNFT` function (if whitelisted, max 5 per address)

### For Contract Owner
- Whitelist management: `addToWhitelist` and `removeFromWhitelist`
- Collection parameters: `setMaxSupply` and `setMaxPerAddress`
- Fund management: `withdraw` (ETH) and `withdrawToken` (ERC20)

You can interact with the contract directly on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x7dd465D9f639012D11E04f39fd236962B1353D39).