import { expect } from "chai";
import { ethers } from "hardhat";
import { MyNFT, TXNToken, WhiteListSale } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { MerkleTree } from "merkletreejs";
import { buildMerkleTree, getProof } from "../scripts";
import { keccak256, toUtf8Bytes } from "ethers";

describe("MyNFT", function () {
  // Contract
  let myNFT: MyNFT;
  let whitelistSale: WhiteListSale;
  // Signers
  let owner: SignerWithAddress,
    user1: SignerWithAddress,
    user2: SignerWithAddress,
    user3: SignerWithAddress,
    user4: SignerWithAddress;
  // Global Variables
  let token: TXNToken;
  let tree: MerkleTree;
  let whitelist: any[];
  let root: string;
  let baseURI =
    "https://emerald-rear-toad-540.mypinata.cloud/ipfs/bafybeifaxjdnlapvqis5ill5dblvkkb2ukcm7jol5kzc2duwtspmfsdb6i/";

  beforeEach(async function () {
    [owner, user1, user2, user3, user4] = await ethers.getSigners();
    const TestToken = await ethers.getContractFactory("TXNToken", user1);
    token = await TestToken.deploy();

    whitelist = [
      { address: owner.address },
      { address: user1.address },
      { address: user2.address },
      { address: user3.address },
    ];
    tree = buildMerkleTree(whitelist);
    root = tree.getHexRoot();
    // Deploy NFT
    const MyNFTFactory = await ethers.getContractFactory("MyNFT");
    myNFT = await MyNFTFactory.deploy(baseURI);
    // Deploy Whitelist Sale
    const WhiteListSaleFactory = await ethers.getContractFactory("WhiteListSale");
    whitelistSale = await WhiteListSaleFactory.deploy(myNFT.getAddress(), root);

    await myNFT.grantRole(keccak256(toUtf8Bytes("MINTER_ROLE")), whitelistSale.getAddress());
  });

  it("Should deploy with correct owner", async function () {
    expect(await myNFT.owner()).to.equal(owner.address);
  });

  it("Should deploy with correct initial state", async function () {
    expect(await myNFT.nextTokenId()).to.equal(1);
    expect(await whitelistSale._maxSupply()).to.equal(1000);
    expect(await whitelistSale._maxMintPerAddress()).to.equal(5);
    expect(await whitelistSale._getTotalSupply()).to.equal(0);
    expect(await whitelistSale._merkleRoot()).to.equal(root);
  });

  it("Should run correct setMaxMintPerAddresss", async function () {
    expect(await whitelistSale.setMaxMintPerAddresss(2))
      .to.emit(myNFT, "MintLimitUpdated")
      .withArgs(2);
    expect(await whitelistSale._maxMintPerAddress()).to.equal(2);
  });

  it("Should run correct setMaxSupply", async function () {
    expect(await whitelistSale.setMaxSupply(2000))
      .to.emit(whitelistSale, "MaxSupplyUpdated")
      .withArgs(2000);
    expect(await whitelistSale._maxSupply()).to.equal(2000);
  });

  it("Should mint correctly", async function () {
    const proof = getProof(tree, user2.address);
    expect(await whitelistSale.connect(user2).mintNFT(proof))
      .to.emit(whitelistSale, "TokenMinted")
      .withArgs(user2.address, 1);
      
    expect(await myNFT.nextTokenId()).to.equal(2);
    expect(await whitelistSale._getTotalSupply()).to.equal(1);
  });

  it("Should can not mint", async function () {
    const proof = getProof(tree, user4.address);
    await expect(whitelistSale.connect(user4).mintNFT(proof)).to.be.revertedWith("Your address is not in whitelist");
  });

  it("Should have correct format TokenURI", async function () {
    const proof = getProof(tree, owner.address);
    expect(await whitelistSale.connect(owner).mintNFT(proof))
      .to.emit(myNFT, "TokenMinted")
      .withArgs(owner.address, 1);
    const tokenURI = await myNFT.tokenURI(1);
    expect(tokenURI).to.equal(baseURI + "1.json");
  });

  it("should revert if not owner", async function () {
    await expect(whitelistSale.connect(user1).withdraw())
      .to.be.revertedWithCustomError(myNFT, "OwnableUnauthorizedAccount")
      .withArgs(user1.address);
  });

  it("should revert if balance is zero", async function () {
    await expect(whitelistSale.connect(owner).withdraw()).to.be.revertedWith(
      "No balance to withdraw"
    );
  });

  it("should withdraw all ETH to owner", async function () {
    // Send some ETH to contract
    await user1.sendTransaction({
      to: whitelistSale.getAddress(),
      value: ethers.parseEther("1"),
    });

    const ownerBalanceBefore = await ethers.provider.getBalance(owner.address);

    // Withdraw as owner
    const tx = await whitelistSale.connect(owner).withdraw();
    expect(tx).to.not.be.reverted;

    // Check owner received funds (minus gas)
    expect(await ethers.provider.getBalance(owner.address)).to.be.gt(
      ownerBalanceBefore
    );

    // Contract should have 0 balance
    const contractBalance = await ethers.provider.getBalance(
      whitelistSale.getAddress()
    );
    expect(contractBalance).to.equal(0);
  });

  it("should revert if token balance is 0", async () => {
    await expect(
      whitelistSale.connect(owner).withdrawToken(token)
    ).to.be.revertedWith("No token balance to withdraw");
  });

  it("should withdraw all token to owner", async () => {
    // Transfer 1000 tokens to contract
    await token.connect(user1).transfer(whitelistSale.getAddress(), ethers.parseEther("1000"));
    expect(await token.balanceOf(whitelistSale.getAddress())).to.equal(ethers.parseEther("1000"));
    // Withdraw
    await whitelistSale.connect(owner).withdrawToken(token.getAddress());

    expect(await token.balanceOf(owner.address)).to.equal(ethers.parseEther("1000"));
    expect(await token.balanceOf(whitelistSale.getAddress())).to.equal(0);
  });
});
