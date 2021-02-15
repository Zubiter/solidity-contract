const hre = require("hardhat");

async function main() {
  const Zubiter = await hre.ethers.getContractFactory("Zubiter");
  const zubiter = await Zubiter.deploy();

  await zubiter.deployed();

  console.log("Zubiter deployed to:", zubiter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
