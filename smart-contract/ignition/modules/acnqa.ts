import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ACNQAModule = buildModule("ACNQAModule", (m) => {
  // Base URI for NFT metadata
  const baseURI = "https://gateway.pinata.cloud/ipfs/bafybeicw65mdqoyi7fkssfq53c5zkkrqujbfi3bidfzqtmtniqn4km4rla";
  
  // Deploy ACNQA NFT contract
  const acnqaNFT = m.contract("ACNQA", [baseURI]);

  return { acnqaNFT };
});

export default ACNQAModule;