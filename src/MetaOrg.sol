// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { 
    LifeCycles,
    BioRoles,
    MetaOrgDNA,
    blobify
} from "./Panspermia.sol";

contract MetaOrg {
    LifeCycles public currentCycle;
    mapping(uint8 => address) public egos;
    mapping(address => MetaOrgDNA) public organelles;


    /**
        * @notice - Constructor
        * @dev - Initialize the organism from birth
        * @param _egos - Smart accounts to manage organisms for each life cycle
    */
    constructor(address[] _egos) {
        require(egos.length == 4, "MO: Only 5 egos allowed");
        for(uint256 i; i < 4; i++) {
            egos[i] = egos[i];
        }
    }

    function onlyActiveEgo() {
        require(msg.sender == egos[currentCycle], "MO: Only active ego can call");
    }

    function mutate() public returns(LifeCycles, address){
        return _mutate();
        // What do wen org dies but is still relied on by other orgs? mutual death?
    }


    function _mutate() internal returns(LifeCycles, address){
        // check to see what cycle we SHOULD be in
        // if different change cycle and current operator

        return (currentCycle, address(this));
    }

}
