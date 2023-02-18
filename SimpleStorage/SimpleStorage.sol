pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    // This will get initialised to the null value (i.e. 0 for unsigned numbers)
    // Default access specifier is internal
    uint256 num;

    struct People {
        uint256 favNum;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavNum;

    // Memory and storage
    // Memory - data only stored during execution of the function
    // Storage - data persisted after function is executed
    function addPerson(string memory _name, uint256 _favNum) public {
        people.push(People(_favNum, _name));
        nameToFavNum[_name] = _favNum;
    }

    function store(uint256 _favouriteNum) public {
        num = _favouriteNum;
    }

    // View and pure are non changing functions
    function retrieve() public view returns (uint256) {
        return num;
    }

    // Pure functions purely perform mathematical operations
    function multiply(uint256 favNum) public pure returns (uint256) {
        return favNum * 2;
    }
}
