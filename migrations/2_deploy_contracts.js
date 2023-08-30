const NFT = artifacts.require("NFT");

module.exports = async function(deployer) {
    //deploy NFT Contract
	await deployer.deploy(NFT);
};