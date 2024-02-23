// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultContract {
    struct Grant {
        address donor;
        address beneficiary;
        uint256 amount;
        uint256 releaseTime;
        bool claimed;
    }

    mapping(address => Grant) public grants;

    event GrantCreated(address indexed donor, address indexed beneficiary, uint256 amount, uint256 releaseTime);
    event GrantClaimed(address indexed beneficiary, uint256 amount);

    function createGrant(address _beneficiary, uint256 _releaseTime) external payable {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(_releaseTime > block.timestamp, "Release time must be in the future");
        require(msg.value > 0, "Invalid amount");

        Grant storage grant = grants[msg.sender];
        require(grant.amount == 0, "Donor can only have one active grant");

        grant.donor = msg.sender;
        grant.beneficiary = _beneficiary;
        grant.amount = msg.value;
        grant.releaseTime = _releaseTime;
        grant.claimed = false;

        emit GrantCreated(msg.sender, _beneficiary, msg.value, _releaseTime);
    }

    function claimGrant() external {
        Grant storage grant = grants[msg.sender];
        require(grant.beneficiary == msg.sender, "Only beneficiary can claim the grant");
        require(grant.amount > 0, "No grant available");
        require(!grant.claimed, "Grant already claimed");
        require(block.timestamp >= grant.releaseTime, "Release time not reached yet");

        grant.claimed = true;
        payable(msg.sender).transfer(grant.amount);

        emit GrantClaimed(msg.sender, grant.amount);
    }
}
