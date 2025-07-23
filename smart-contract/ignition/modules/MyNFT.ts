import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MyNFTModule = buildModule("MyNFTModule", (m) => {
  // Base URI for NFT metadata
  const deployer = m.getAccount(0);

  const baseURI = process.env.BASE_URI;
  if (!baseURI) {
    throw new Error("BASE_URI environment variable is not set.");
  }
  // Deploy NFT contract
  const MyNFT = m.contract("MyNFT", [baseURI], { from: deployer });
  return { MyNFT };
});

export default MyNFTModule;
