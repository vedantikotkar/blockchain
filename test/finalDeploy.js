const hre=require('hardhat')

async function main() {
    const [owner, from1, from2, from3] = await hre.ethers.getSigners();
    const chai = await hre.ethers.getContractFactory('Library');
    const contract = await chai.deploy(); // Deploy the contract
    await contract.waitForDeployment(); // Ensure the contract is deployed and initialized

     console.log("Address of contract ", contract);

}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});