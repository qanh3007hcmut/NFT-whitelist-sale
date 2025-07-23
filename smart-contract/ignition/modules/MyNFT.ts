import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { loadMerkleRoot, run_merkle } from "../../scripts/utils/";
import * as dotenv from "dotenv";
dotenv.config();

const MyNFTModule = buildModule("MyNFTModule", (m) => {
  
  
  // Base URI for NFT metadata
  const baseURI = process.env.BASE_URI;
  run_merkle();
  const merkleRoot = loadMerkleRoot("data/proofs.json")
  if (!baseURI) {
    throw new Error("BASE_URI environment variable is not set.");
  }
  if (!merkleRoot) {
    throw new Error("Merkle root is not set. Please run the merkle script.");
  }
  
  // Deploy NFT contract
  const MyNFT = m.contract("MyNFT", [merkleRoot, baseURI]);

  return { MyNFT };
});

export default MyNFTModule;
