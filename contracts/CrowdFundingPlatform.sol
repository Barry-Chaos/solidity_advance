// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./CrowdFundingProject.sol";

contract CrowdFundingPlatform is Initializable, UUPSUpgradeable, OwnableUpgradeable {

    address[] public projects;

    event ProjectCreated(address projectAddress, address creator, string description, uint256 goalAmount, uint256 deadline);

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function createProject(string memory _description, uint256 _goalAmount, uint256 _duration) public {
        CrowdFundingProject project = new CrowdFundingProject();
        project.initialize(msg.sender, _description, _goalAmount, _duration);
        projects.push(address(project));

        emit ProjectCreated(address(project), msg.sender, _description, _goalAmount, block.timestamp + _duration);
    }

    function getProjects() public view returns (address[] memory) {
        return projects;
    }
}