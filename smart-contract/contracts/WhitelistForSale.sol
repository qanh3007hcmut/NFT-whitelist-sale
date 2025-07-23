// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./MyNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

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

    constructor(address nftAddress, bytes32 _root) Ownable(msg.sender) {
        nftContract = MyNFT(nftAddress);
        _merkleRoot = _root;
    }

    function mintNFT(
        bytes32[] calldata proofs
    ) external onlyWhitelist(proofs) withinLimit {
        require(nftContract.nextTokenId() <= _maxSupply, "Max supply reached");
        _mintPerAddr[msg.sender] += 1;
        nftContract.mint(msg.sender);
        emit TokenMinted(msg.sender, nftContract.nextTokenId() -1);
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No balance to withdraw");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    function withdrawToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(balance > 0, "No token balance to withdraw");
        IERC20(token).safeTransfer(msg.sender, balance);
    }

    function _getTotalSupply() external view returns (uint256) {
        return nftContract.nextTokenId() - 1;
    }

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

    receive() external payable {}

    fallback() external payable {}
}
