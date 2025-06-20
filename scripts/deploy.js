const hre = require("hardhat");

async function main() {
  const CertificateRevocation = await hre.ethers.getContractFactory("CertificateRevocation");
  const contract = await CertificateRevocation.deploy();

  await contract.deployed();

  console.log("CertificateRevocation deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error in deployment:", error);
    process.exit(1);
  });
