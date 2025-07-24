// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./MyNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @title Whitelist Sale for Pokemon NFT Collection
 * @notice Manages whitelist-based minting of Pokemon NFTs with Merkle proof verification
 * @dev Controls minting limits, supply cap, and whitelist access
 */
contract WhiteListSale is Ownable {
    using SafeERC20 for IERC20;

    MyNFT public nftContract;
    uint256 public _maxSupply = 1000;
    uint256 public _maxMintPerAddress = 5;
    bytes32 public _merkleRoot;

    mapping(address => uint8) internal _mintPerAddr;

    event TokenMinted(address indexed to, uint256 indexed tokenId);
    event MaxSupplyUpdated(uint256 newMaxSupply);
    event MerkleRootUpdated(bytes32 newMerkleRoot);
    event MintLimitUpdated(uint256 newMintLimit);

    /**
     * @notice Verifies sender is on the whitelist
     * @param proofs Merkle proof for verification
     */
    modifier onlyWhitelist(bytes32[] calldata proofs) {
        require(
            MerkleProof.verify(
                proofs,
                _merkleRoot,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "Your address is not in whitelist"
        );
        _;
    }

    modifier withinLimit() {
        require(
            _mintPerAddr[msg.sender] < _maxMintPerAddress,
            "Mint Token Limit reached"
        );
        _;
    }

    /**
     * @notice Initializes the contract with NFT address and merkle root
     * @param nftAddress Address of the NFT contract
     * @param _root Initial merkle root for whitelist
     */
    constructor(address nftAddress, bytes32 _root) Ownable(msg.sender) {
        nftContract = MyNFT(nftAddress);
        _merkleRoot = _root;
    }

    /**
     * @notice Mints an NFT if sender is whitelisted and within limits
     * @param proofs Merkle proof verifying sender is whitelisted
     */
    function mintNFT(
        bytes32[] calldata proofs
    ) external onlyWhitelist(proofs) withinLimit {
        require(nftContract.nextTokenId() <= _maxSupply, "Max supply reached");
        _mintPerAddr[msg.sender] += 1;
        nftContract.mint(msg.sender);
        emit TokenMinted(msg.sender, nftContract.nextTokenId() - 1);
    }

    /**
     * @notice Withdraws all ETH from contract to owner
     */
    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No balance to withdraw");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    /**
     * @notice Withdraws ERC20 tokens from contract to owner
     * @param token Address of ERC20 token to withdraw
     */
    function withdrawToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(balance > 0, "No token balance to withdraw");
        IERC20(token).safeTransfer(msg.sender, balance);
    }

    /**
     * @notice Returns current total supply of minted NFTs
     * @return Current number of minted NFTs
     */
    function _getTotalSupply() external view returns (uint256) {
        return nftContract.nextTokenId() - 1;
    }

    /**
     * @notice Updates maximum supply cap
     * @param maxSupply New maximum supply value
     */
    function setMaxSupply(uint256 maxSupply) external onlyOwner {
        require(maxSupply > 0, "Max supply must be greater than zero");
        _maxSupply = maxSupply;
        emit MaxSupplyUpdated(_maxSupply);
    }

    /**
     * @notice Updates maximum mint limit per address
     * @param newLimit New mint limit per address
     */
    function setMaxMintPerAddresss(uint256 newLimit) external onlyOwner {
        require(newLimit > 0, "Mint Limit must be greater than zero");
        _maxMintPerAddress = newLimit;
        emit MintLimitUpdated(_maxMintPerAddress);
    }

    /**
     * @notice Updates merkle root for whitelist verification
     * @param newMerkleRoot New merkle root hash
     */
    function setMerkleRoot(bytes32 newMerkleRoot) public onlyOwner {
        require(newMerkleRoot != bytes32(0), "Merkle Root cannot be 0");
        _merkleRoot = newMerkleRoot;
        emit MerkleRootUpdated(_merkleRoot);
    }

    /// @notice Allows contract to receive ETH
    receive() external payable {}

    /// @notice Fallback function to receive ETH
    fallback() external payable {}
}
