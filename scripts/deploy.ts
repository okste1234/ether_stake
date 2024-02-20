import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60

  const stakeEther = await ethers.deployContract("StakeEther", [unlockTime]);

  await stakeEther.waitForDeployment();

  console.log(
    `StakeEther deployed to ${stakeEther.target} at ${unlockTime}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
