const hre = require("hardhat");
const { ethers } = hre;

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = deployer.address;
  console.log(`\n\n\n Deployer Address: ${deployerAddress} \n\n\n`);

  const BXDResolvers = await ethers.getContractFactory("BxdDSAResolver");

  const indexAddress = "0xC558A66098EFB3314E681F74f5bB08c396257D18";

  const bxdResolvers = await BXDResolvers.deploy(indexAddress);

  console.log("bxd dsa resolver deployed", bxdResolvers.address);

  await hre.run("verify:verify", {
    address: bxdResolvers.address,
    constructorArguments: [indexAddress],
    contract: "contracts/dsa/index.sol:BxdDSAResolver",
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
