import fs from "fs";
import path from "path";
import { ethers } from "ethers";
import { MerkleTree } from "merkletreejs";

interface WhitelistEntry {
  address: string;
}

// Load whitelist from file
const loadWhitelist = (filePath: string): WhitelistEntry[] => {
  try {
    const data = fs.readFileSync(path.resolve(filePath), "utf-8");
    const parsed: unknown = JSON.parse(data);

    if (!Array.isArray(parsed)) throw new Error("Invalid whitelist format");

    return parsed.map((entry) => {
      return {
        address: String(entry.address).toLowerCase(),
      };
    });
  } catch (error) {
    console.error("Failed to load whitelist:", error);
    process.exit(1);
  }
};

const buildMerkleTree = (entries: WhitelistEntry[]): MerkleTree => {
  const leaves = entries.map(({ address }) => {
    return ethers.keccak256(address);
  });
  return new MerkleTree(leaves, ethers.keccak256, { sortPairs: true });
};

const getProof = (tree: MerkleTree, address: string): string[] => {
  return tree.getHexProof(ethers.keccak256(address));
}

const generateProofs = (
  tree: MerkleTree,
  entries: WhitelistEntry[]
): Record<string, any> => {
  const proofs: Record<string, any> = {
    merkleRoot: tree.getHexRoot()
  };
  for (const { address } of entries) {
    proofs[address] = getProof(tree, address);
  }
  return proofs;
};

const main = () => {
  const whitelistPath = "data/whitelist.json";
  const outputPath = "data/proofs.json";

  const whitelist = loadWhitelist(whitelistPath);
  const tree = buildMerkleTree(whitelist);
  const proofs = generateProofs(tree, whitelist);

  fs.writeFileSync(outputPath, JSON.stringify(proofs, null, 2));
  console.log("Merkle Root:", proofs.merkleRoot);
  console.log("Proofs exported to:", outputPath);
};

main();

export {buildMerkleTree, generateProofs, getProof};