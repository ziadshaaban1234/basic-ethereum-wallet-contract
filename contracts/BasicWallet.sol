// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract BasicWallet {
    mapping(address => uint256) private balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    uint256 private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, "Reentrant call");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external lock {
        require(balances[msg.sender] >= amount, "Not enough balance");
        balances[msg.sender] -= amount;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit Withdrawn(msg.sender, amount);
    }

    function transferTo(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough balance");
        require(to != address(0), "Invalid address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transferred(msg.sender, to, amount);
    }

    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
}
