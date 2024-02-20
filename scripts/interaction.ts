import { ethers } from "hardhat";

async function main() {

  const stakeEtherContract = "0xf5D216e54d19dBFb36286139dbBC6DB1d909228d";
  // const StakeEther = await ethers.getContractAt("IStakeEther", stakeEtherContract);

  // Alternative way of interactng with a deployed contract without using Contract Interface
  const Staking = await ethers.getContractFactory("StakeEther");
  const StakeEther = Staking.attach(stakeEtherContract);

  const tx = await StakeEther.deposit({ value: 1 });
  await tx.wait();

  // const reward = await StakeEther.checkReward();

  // const withdraw = await StakeEther.withdraw(1000000000000000012n)
  // await withdraw.wait();

  const bal = await StakeEther.checkContractBalance();
  console.log(bal);
}



// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
