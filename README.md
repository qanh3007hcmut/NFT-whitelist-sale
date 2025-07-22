# AppsCyclone NQA Collection (ACNQA)

## Overview
AppsCyclone NQA Collection is an ERC-721 NFT collection deployed on the Ethereum Sepolia testnet. The collection features unique digital collectibles with a maximum supply of 10,000 tokens and a limit of 5 tokens per address.

## Contract Details
- **Contract Address**: [0xAD1cC8ab9b51dDe4a3B23C7dDCB53ACCe63C6413](https://sepolia.etherscan.io/address/0xAD1cC8ab9b51dDe4a3B23C7dDCB53ACCe63C6413)
- **Token Standard**: ERC-721
- **Token Symbol**: ACNQA
- **Max Supply**: 10,000 NFTs
- **Tokens Per Address**: Maximum 5 tokens

## Features
- **Whitelist System**: Only whitelisted addresses can mint tokens
- **Owner Controls**: Contract owner can add/remove addresses from whitelist
- **Customizable Parameters**: Max supply and tokens per address can be adjusted by owner
- **Withdrawal Functions**: Contract includes functions to withdraw ETH and ERC20 tokens

## Minted Tokens
Currently, 3 tokens have been minted:

1. **Token #1**: "Dave Starbelly" - A friendly OpenSea Creature that enjoys long swims in the ocean
2. **Token #2**: "Psyduck" - Friendly Pokemon Creature that enjoys long swims in the ocean
3. **Token #3**: "Pikachu - Deadpool Edition" - Not only a friendly Pokemon creature, but also immorting to kill u

## Metadata
All token metadata is hosted on Pinata IPFS service, ensuring decentralized and permanent storage for the NFT attributes and images.

## Interacting with the Contract
You can interact with the contract directly on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0xAD1cC8ab9b51dDe4a3B23C7dDCB53ACCe63C6413).

### For Users
- Check if you're whitelisted by calling the `whitelist` function with your address
- If whitelisted, you can mint NFTs using the `mintNFT` function (up to 5 per address)

### For Contract Owner
- Add addresses to whitelist using `addToWhitelist`
- Remove addresses from whitelist using `removeFromWhitelist`
- Adjust max supply with `setMaxSupply`
- Change tokens per address limit with `setMaxPerAddress`
- Withdraw funds using `withdraw` (ETH) or `withdrawToken` (ERC20)

## Development
This project uses:
- Solidity ^0.8.0
- OpenZeppelin contracts for ERC721 implementation