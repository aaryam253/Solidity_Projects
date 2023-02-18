// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

// Interfaces compile down to an ABI (Application Binary Interface)
// To interact with other smart contracts, you always need an ABI
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


// All units are in Gwei (10^8), not wei (10^18). 
// 1 Eth = 10^8 Gwei = 10^18 Wei
contract FundMe {
    // Libraries are only deployed once at a specific address and their code is reused
    // Using keyword --> used to attach library functions in context of a contract
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    // Function can be used to pay for something when using payable keyword
    function fund() public payable {
        // $50 converted to Gwei
        uint256 minimumUSD = 50 * 10 ** 8;
        // In case the require criteria is not yet, transaction is reverted
        // (i.e. sender gets their money back and the gas they spent)
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        // Keywords in every transaction (sender and value)
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    // Returns price in Gwei
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer);
    }

    // Returns price in USD
    /*
    Math in Solidity --> if an overflow occurs, solidity wraps around integers when they reach
    their max cap.
    After v0.8, solidity performs these checks for us, at the cost of a little bit more gas
    */
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10 ** 8);
        return ethAmountInUsd;
    }

    // Modifiers --> change behaviour of function in declarative way
    modifier onlyOwner {
        // Require msg.sender = owner of the contract (set owner using contructors)
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        // Sends some ethereum to whoever it's being called from
        // This keyword --> the contract you're currently in
        msg.sender.transfer(address(this).balance);

        // Reset all funders who already participated
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}