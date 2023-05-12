


// script used to fund account from a geth coinbase account (geth --dev)
import { deployments, ethers, getNamedAccounts, upgrades } from 'hardhat';
import { BigNumber, providers } from 'ethers';
import dayjs from 'dayjs'
import { parseEther } from 'ethers/lib/utils';
const { JsonRpcProvider } = providers;

function wait(numSec: number): Promise<void> {
	return new Promise<void>((resolve) => {
		setTimeout(resolve, numSec * 1000);
	});
}

async function main() {
	const assetManagement = await deployments.get('AssetManagement');
	const { deployer, owner } = await getNamedAccounts();
	const tournamentName = 'DEMO';

	const Tournament = await ethers.getContractFactory('Tournament');
	const tournament = await upgrades.deployProxy(Tournament, [
		assetManagement.address,
		owner,
		tournamentName,
		dayjs().add(1, 'd').unix(),
		dayjs().add(15, 'd').unix(),
		1000,
		parseEther('0.01'),
		'0x958dcC4AFbDaEEE587D88AA9B04EbBf52A419d83',
		3,
		parseEther('10'),
		0,
		"https://tournament.dareplay.io/assets/DEMO.json"
	]);

	console.log('Tournament deployed to:', tournament.address);

	const contract = await ethers.getContractFactory('Reward');
	const reward = await upgrades.deployProxy(contract, [
		tournament.address,
	], { initializer: 'initialize' });

	console.log('Reward deployed to:', reward.address);

	await deployments.execute('AssetManagement', {
		from: deployer,
	}, 'grantRole', [
		await (await ethers.getContract('AssetManagement')).TRANSFERABLE_ERC20_ROLE(),
		tournament.address
	]);

	console.log('Granting roles to the AssetManagement contract');
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
