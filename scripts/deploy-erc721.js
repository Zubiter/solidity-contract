require('dotenv').config();
const hre = require("hardhat");

async function main() {
  if (!process.env.ZUBITER) throw "ZUBITER contract address not determined";
  const Clonable = await hre.ethers.getContractFactory("ZubiterClonableERC721");
  const clonable = await Clonable.deploy();

  await clonable.deployed();

  console.log("Clonable deployed to:", clonable.address);

  const Zubiter = await hre.ethers.getContractFactory("Zubiter");
  const zubiter = Zubiter.attach(process.env.ZUBITER);

  await zubiter.setTemplate(clonable.address);

  console.log("Zubiter template pointed to:", clonable.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
