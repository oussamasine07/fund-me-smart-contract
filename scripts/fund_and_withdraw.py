from brownie import  config, network, FundMe
from scripts.helpfull_scripts import get_account

def fund():
    account = get_account()
    fund_me = FundMe[-1]
    get_entrance_fee = fund_me.getEntrenceFee()
    print(f"entrence fee is {get_entrance_fee}")
    print("funding...")
    # call fundingfunction to feed the contract
    fund_me.fund({"from": account, "value": get_entrance_fee})

def withdraw():
    account = get_account()
    fund_me = FundMe[-1]
    print("widrawing funds")
    fund_me.withdraw({ "from": account })

def main():
    fund()
    withdraw()