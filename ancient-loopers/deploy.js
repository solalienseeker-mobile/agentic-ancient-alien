const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Cryptogene to Neon EVM...");

  const [deployer] = await ethers.getSigners();
  console.log("Deployer address:", deployer.address);

  const balance = await deployer.getBalance();
  console.log("Balance:", ethers.utils.formatEther(balance), "NEON");

  const Cryptogene = await ethers.getContractFactory("Cryptogene");
  const cryptogene = await Cryptogene.deploy();

  console.log("Waiting for deployment...");
  await cryptogene.deployed();

  const tx = cryptogene.deployTransaction;

  console.log(JSON.stringify({
    contract: "Cryptogene",
    address: cryptogene.address,
    txHash: tx.hash,
    network: "neon-devnet",
    blockNumber: tx.blockNumber,
    gasUsed: tx.gasLimit.toString(),
    gasless: true,
    biconomy: "enabled"
  }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
