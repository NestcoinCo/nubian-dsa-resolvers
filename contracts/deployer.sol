
pragma solidity ^0.8.4;

interface IndexInterface {
    function master() external view returns (address);
}

interface ConnectorsInterface {
    function chief(address) external view returns (bool);
}

interface ConnectorInterface {
    function destruct() external;
}

contract Basics {
    IndexInterface bxdIndex =
        IndexInterface(0xC558A66098EFB3314E681F74f5bB08c396257D18);
    ConnectorsInterface connectorsContract =
        ConnectorsInterface(0x21cf3ea572473f22597DE28c80cA6BFF94416151);
}

contract DeployerAuth is Basics {
    mapping(address => bool) public deployer;

    modifier isChief {
        require(
            connectorsContract.chief(msg.sender) ||
                msg.sender == bxdIndex.master(),
            "not-an-chief"
        );
        _;
    }

    modifier isDeployer {
        require(deployer[msg.sender], "not-an-deployer");
        _;
    }

    /**
     * @dev Enable a Chief.
     * @param _userAddress Chief Address.
     */
    function enableChief(address _userAddress) external isChief {
        deployer[_userAddress] = true;
    }

    /**
     * @dev Disables a Chief.
     * @param _userAddress Chief Address.
     */
    function disableChief(address _userAddress) external isChief {
        delete deployer[_userAddress];
    }
}

contract ConnectorDeployer is DeployerAuth {
    function deploy(
        bytes memory code,
        uint256 connectorId,
        address destructConnector
    ) public isDeployer returns (address addr) {
        bytes32 salt = bytes32(connectorId);
        assembly {
            addr := create2(0, add(code, 0x20), mload(code), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        if (destructConnector != address(0))
            ConnectorInterface(destructConnector).destruct();
    }
}
