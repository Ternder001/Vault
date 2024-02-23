import { ethers } from 'hardhat';

async function main() {
  const VaultContract = await ethers.getContractFactory('VaultContract');
  const vaultContract = await VaultContract.deploy();

  await vaultContract.waitForDeployment();

  console.log(
    `VaultContract deployed to ${vaultContract.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

export {};
