// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address owner;
    AggregatorV3Interface public priceFeed;

    address[] public funders;
    constructor (address _priceFeed) public {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getEntrenceFee() public view returns(uint256) {
        uint256 minimumUSD = 50 * 10 ** 18;
        uint256 price = getPrice();
        uint256 precession = 1 * 10 ** 18;
        return (minimumUSD * precession) / price;
    }

    function fund() public payable {
        // minimum amount is 50$
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "not enough ether");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion () public view returns(uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate (uint256 ethAmount) public view returns(uint256) {
        uint256 currentEthPrice = getPrice();
        uint256 convertUSDToEth = (currentEthPrice * ethAmount) / 1000000000000000000;
        return convertUSDToEth;
    }

    // using the modifiers only if we want to execute some task by the admin/owner of the contract
    modifier  onlyModifier {
        require(msg.sender == owner, "you are not allowed to withdraw");
        _;
    }

    function withdraw () payable onlyModifier public {
        // we want to identify who this money is going to be sent to
        // in this case we are sending money to the sender
        // we are sending the intire amount to the sender
        // then only the owner of this contract who's going to withdraw
        // msg.sender.transfer(address(this).balance);
        (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");
        require(sent, "there is a problem!");
        for (uint256 funderIndex = 0; funders.length > funderIndex; funderIndex++) {
            address funder = funders[funderIndex];
            // set each address to a 0 value
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}