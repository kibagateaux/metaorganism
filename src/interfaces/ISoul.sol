pragma solidity ^0.8.17;

import { IOrganism } from './IOrganism.sol';
import { ISafeProtocolPlugin } from './ISafeProtocolPlugin.sol';

/**
 * @title Soul
 * @dev - Controller for a MetaOrg. Also eligibility contract for hats on a MetaOrg
 */
interface ISoul is IOrganism, ISafeProtocolPlugin {
    /**
     * @notice - Returns true if the cell is identified as a part of the organism by this soul
     * @dev - if true allows cell to operate within the organism e.g. signal
     * @param cell - Address of the organism to let through the membrane into organism
     */
    function membrane(address cell) external returns(bool);

    /**
     * @notice - defines how much of a resource cell consumes and/or creates.
     * @dev - if true allows cell to operate within the organism e.g. signal
     * @param resource - Address of the organism to let through the membrane into organism
     * @return - (consumption, creation)
     */
    function libido(address resource) external returns(uint256, uint256);

    /**
     * @notice - standard solidity fallback function for extensability
     * @dev - nonpayable, all funds should be sent/held in the MetaOrg
     * @param  - 
     * @return - MUST return ISafeProtocolPlugin.Tx || ISafeProtocolPlugin.RootAccess.
                First bit denotes which - 0 = Tx, 1 = RootAccess
     */
    
    fallback(bytes calldata) external returns (bytes memory);
}