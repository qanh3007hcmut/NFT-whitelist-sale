import { run } from "hardhat";
import * as fs from "fs";
import * as path from "path";
import { loadMerkleRoot } from "../scripts/utils";
import * as dotenv from "dotenv";
dotenv.config();

async function main() {
  // Read contract addresses from ignition deployments
  const deploymentsPath = path.join(
    __dirname,
    "../ignition/deployments/chain-11155111/deployed_addresses.json"
  );
  const deployments = JSON.parse(fs.readFileSync(deploymentsPath, "utf8"));

  const NFTAddress = deployments["MyNFTModule#MyNFT"];
  const baseURI = process.env.BASE_URI;
  const merkleRoot = loadMerkleRoot("data/proofs.json");
  if (!baseURI) {throw new Error("BASE_URI environment variable is not set.");}
  else console.log("Base URI:", baseURI);
  
  if (!merkleRoot) throw new Error("Merkle root is not set. Please run the merkle script.");
  else console.log("Merkle Root:", merkleRoot);

  console.log("Verifying contracts on Etherscan...");

  try {
    await run("verify:verify", {
      address: NFTAddress,
      constructorArguments: [merkleRoot, baseURI],
    });
    console.log("NFT verified successfully");
  } catch (error: any) {
    if (error.message.includes("Already Verified")) {
      console.log("NFT already verified");
    } else {
      console.error("Error verifying NFT:", error);
    }
  }

  console.log("Verification process completed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
