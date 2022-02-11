from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpfull_scripts import get_account, deploy_mocks, local_blockchain_environment


def deploy_fund_me():
    account = get_account()
    # give the address to the deploy function
    
    # to work with the price feed address dynamicly, we need to pass the price feed address to the constructor
    # if we are in the prisistent network like rinkeby, use the associated network
    # else use a mock of the network
    if network.show_active() not in local_blockchain_environment:
        price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address


    fund_me = FundMe.deploy(
        price_feed_address, 
        { "from": account }
    )
    get_price = fund_me.getPrice()
    print(get_price)


def main():
    deploy_fund_me()