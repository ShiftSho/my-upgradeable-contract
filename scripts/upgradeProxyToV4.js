const { ethers, upgrades } = require('hardhat');

const proxyAddress = '0x42A730b406A1750FaA5B4EdCbCDc9Fb1138E7860';

async function main() {
  const VendingMachineV4 = await ethers.getContractFactory('VendingMachineV4');
  const upgraded = await upgrades.upgradeProxy(proxyAddress, VendingMachineV4);

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(
    upgraded.target
  );

  console.log("The current contract owner is: " + await upgraded.owner());
  console.log('Implementation contract address: ' + implementationAddress);
}

main();