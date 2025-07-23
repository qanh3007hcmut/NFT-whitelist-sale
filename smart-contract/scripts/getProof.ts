import { buildMerkleTree, getProof } from "../scripts";

const whitelist = [
  { "address": "0x8492567253C49080ceB724477912F6D5aACe76c2"},
  { "address": "0x36d6EE57F87E3eE2efA08E2d4109e56Fc910A708"},
  { "address": "0xd3c4dF6AA75624261b3514EF9938A5451548Db21"}
];
const tree = buildMerkleTree(whitelist);
console.log(tree.getHexRoot());
console.log(getProof(tree, "0xd3c4dF6AA75624261b3514EF9938A5451548Db21"))