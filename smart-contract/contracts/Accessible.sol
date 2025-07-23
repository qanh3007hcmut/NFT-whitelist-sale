// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./BaseStorage.sol";

abstract contract Accessible is BaseStorage {
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
}
