// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./BaseStorage.sol";
import "./Accessible.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MyNFT is ERC721, BaseStorage, Accessible {
    using SafeERC20 for IERC20;

    constructor(
        bytes32 _root,
        string memory baseURI
    ) ERC721("Pokemon", "PKM") Ownable(msg.sender) {
        setMerkleRoot(_root);
        setBaseTokenURI(baseURI);
    }

    function mintNFT(
        bytes32[] calldata proofs
    ) external onlyWhitelist(proofs) withinLimit {
        require(_nextTokenId <= _maxSupply, "Max supply reached");
        _mintPerAddr[msg.sender] += 1;
        _incrementTokenId();
        _safeMint(msg.sender, _nextTokenId - 1);
        emit TokenMinted(msg.sender, _nextTokenId - 1);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721) returns (string memory) {
        require(tokenId < _nextTokenId, "TokenId does not exist");
        return
            string(
                abi.encodePacked(_baseTokenURI, Strings.toString(tokenId), ".json")
            );
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

    receive() external payable {}

    fallback() external payable {}
}
