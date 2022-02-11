from brownie import accounts, MockV3Aggregator, config, network

local_blockchain_environment = ["development", "ganache-local"]
forked_blockchain_environment = ["mainnet-fork", "mainnet-fork-dev"]

def get_account():
    if (
        network.show_active() in local_blockchain_environment 
        or network.show_active() in forked_blockchain_environment
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def deploy_mocks():
    print(f"the active network is {network.show_active()}")
    print("deploying mock...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            18, 2000000000000000000000, {"from": get_account()}
        )
    print("mocks deployed...")