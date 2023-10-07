pragma solidity ^0.8.17;

import {
    LifeCycles
} from "../Panspermia.sol";
import { IOrganism } from './IOrganism.sol';

interface IMetaOrg is IOrganism {
    event Blobbin(address indexed soul, address indexed subCell, uint256 amount);
    event Globbin(address indexed soul, address indexed peerCell, uint256 peerAmount, uint256 selfAmount);
    event Flobbin(address indexed soul, address indexed enemyCell, uint256 amount);

    /// Immutable Life Variables 
    /**
    * @notice - what the org is trying to do overall
    * @return - raw string or URI (IPFS hash , website, etc.)
    */
    function willToLive() external view returns(string memory);
    /**
     * @notice - the different decision making frameworks and operating models the organism uses throughout its life
     * @param cycle - life cycle to get preconfigured  soul for
     * @return - address of soul for target cycle
     */
    function souls(uint8) external view returns(address);
    
    /// Dynamic Life Variables 
    function activeCycle() external view returns(uint8);
    function activeSoul() external view returns(address);
    
    /// Life Cycle Functions
    /**
    * @notice - If MetaOrg should change into a new life cycle and the Soul controlling it
    * @dev - check internal _mutate() for more details
    * @return [newCycle, newSoul] - MetaOrg lifecycle and Soul after mutation completes
    */ 
    function mutate() external returns(LifeCycles, address);

    /// Plasma

    /// Reproduction
    /**
    * @notice - Friendly forking a new MetaOrg out of the existing org
    * @param requisitions - resources that new org will be seeded with
    * @param asRoot - if existing subCell
    * @return - if MetaOrg accepts signalers love for the peer/subcell
    */ 
    function mitosis(bytes[] calldata requisitions, bool asRoot) external returns(bool);
    
    /**
    * @notice - Registering new cell DNA into MetaOrg to be able to start signaling
    * @dev soul.membrane(subCell) SHOULD always fail before transduce() is called
    * @param requisitions - resources that new org will be seeded with
    * @param helix - desired permissions for new cell
    * @return - if MetaOrg accepts cell's registration
    */ 
    function transduce(address subCell, uint64 helix) public returns(bool);

    /// AntiPhage
    /**
    * @notice - Onboarding cell into MetaOrg to be able to start acting.
    * @dev flob() SHOULD always fail before tPose() is called
    * @param requisitions - resources that new org will be seeded with
    * @param asRoot - if existing subCell
    * @return - if MetaOrg accepts signalers love for the peer/subcell
    */ 
    function tPose(address) external returns(bool);
    function killCancer(address, uint256) external returns(bool);

    // Nucleus 
    function takeLSD() external returns(bool); // lets them update Egos, can also cause immediate death locking all Organism functions

}