// SPDX-License_Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../SimpleStorage/SimpleStorage";

contract StorageFactory is SimpleStorage {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)
        public
    {
        // Need Address and ABI of the contract
        // Application Binary Interface can be retrieved from the import
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(
            _simpleStorageNumber
        );
    }

    function sfRetrieve(uint256 _simpleStorageIndex)
        public
        view
        returns (uint256)
    {
        return
            SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]))
                .retrieve();
    }
}
