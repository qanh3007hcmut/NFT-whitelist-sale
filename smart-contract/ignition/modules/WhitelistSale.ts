import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import MyNFTModule from "./MyNFT";
import { keccak256, toUtf8Bytes } from "ethers";
import { loadMerkleRoot, run_merkle } from "../../scripts/utils/";
import * as dotenv from "dotenv";
dotenv.config();

const WhitelistSaleModule = buildModule("WhitelistSaleModule", (m) => {
  const deployer = m.getAccount(0);

  const { MyNFT } = m.useModule(MyNFTModule);
  run_merkle();
  const merkleRoot = loadMerkleRoot("data/proofs.json");
  if (!merkleRoot) {
    throw new Error("Merkle root is not set. Please run the merkle script.");
  }

  // Deploy Whitelist Sale contract
  const WhitelistSale = m.contract("WhiteListSale", [MyNFT, merkleRoot], {
    from: deployer,
  });

  m.call(MyNFT, "grantRole", [keccak256(toUtf8Bytes("MINTER_ROLE")), WhitelistSale], {
    from: deployer,
  });
  return { WhitelistSale };
});

export default WhitelistSaleModule;
