// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {IERC165} from "./interfaces/IERC165.sol";
import {ISoul} from "./interfaces/ISoul.sol";
import {IMetaOrg} from "./interfaces/IMetaOrg.sol";
import {ISafeProtocolPlugin} from "./interfaces/ISafeProtocolPlugin.sol";

import {ERC20} from "@solady/tokens/ERC20.sol";
import {EIP712} from "@solady/utils/EIP712.sol";

import { 
    Organism,
    OrganismDNA,
    LifeCycles,
    CellDNA,
    CellRoles,
    Resource,

    blobify,
    blobifyWithParentalControls,
    activeInPhase,
    hasRelation,
} from "./Panspermia.sol";


/**
 * @dev - Inherit Organism first so storage is laid out correctly and Souls can access in delegatecalls
*/
abstract contract MetaOrg is Organism, IMetaOrg, ERC20, EIP712 {
    string public willToLive; // per organism, not part of DNA

    constructor() {/*cries from the pain of consciouness*/}

    /**
     * @notice - Initialize the MetaOrg with the souls that will manage it
     * @param primaryResource_ - Main resource that MetaOrg stewards
     * @param souls_ - Smart accounts to manage organisms for each life cycle
     */
    function initialize(
        address primaryResource_,
        uint256 dailyResourceDose,
        address[] memory souls_,
        string storage willToLive_
    ) public {
        require(self.primaryResource != address(0), "MO: Already initialized");
        require(souls_.length == 8, "MO: not enuf soul");
        
        self.primaryResource = primaryResource_;
        self.currentCycle = LifeCycles.Inseminating;
        self.requestedResources[primaryResource_] = Resource({
            recommendedDailyDose: dailyResourceDose,
            currentDosage: 0
        });

        for(uint8 i; i < 4;) {
            require(souls_[i] != address(0), "MO: No Soul!");
            self.souls[uint8(i)] = souls_[i];
            // let souls manage our metaresources
            _approve(address(this), souls_[i], type(uint256).max);
            unchecked { i++; }
        }

        willToLive = willToLive_;
    }

    // "modifiers"
    function _assertOnlyActiveSoul() internal view {
        require(msg.sender == activeSoul(), "MO: Only active ego can call");
    }

    function activeCycle() public view returns(uint8) {
        return uint8(self.currentCycle);
    }

    function activeSoul() public view returns(address) {
        return self.souls[uint8(self.currentCycle)];
    }

    function mutate() public returns(LifeCycles, address){
        // What do wen org dies but is still relied on by other orgs? mutual death?
        return _mutate();
    }

    function signalSub(address subCell, uint256 amount) public returns(bool) {
        return blob(subCell, amount);
    }

    function blob(address subCell, uint256 amount) public returns(bool) {
        require(self.cells[subCell].helix != uint64(0)); // cell hasnt been merged into org yet
        address soul = activeSoul();
        ISoul(soul).blob(
            subCell,
            amount
        );
        emit Blobbin(soul, subCell, amount);

        return true;
        // TODO @Abstract2Soul
        // - when can you signal. How to accept them into org. initial life cycle, etc.
        // - how to handle signalers leaving org
    }

    function signalPeer(address peerCell, uint256 peerAmount, uint256 selfAmount) public returns(bool) {
        return glob(peerCell, peerAmount, selfAmount);
    }

    function glob(address peerCell, uint256 peerAmount, uint256 selfAmount) public returns(bool) {
        address soul = activeSoul();
        ISoul(soul).signalPeer(
            peerCell,
            peerAmount,
            selfAmount
        );
        emit Globbin(soul, peerCell, peerAmount, selfAmount);
        return true;
    }

    function signalEnemy(address peerCell, uint256 peerAmount, uint256 selfAmount) public returns(bool) {
        return glob(peerCell, peerAmount, selfAmount);
    }

    function flob(address enemyCell, uint256 amount) public returns(bool) {
        address soul = activeSoul();
        ISoul(soul).signalPeer(
            peerCell,
            peerAmount,
            selfAmount
        );
        emit Flobbin(soul, peerCell, peerAmount, selfAmount);
        return true;
    }


    /**
        * @notice - endosymbiotic process of a new cell joining the MetaOrg
        * @dev - people ca signal with a cell subCell before edoSymbiosis and could be the reason its allowed in
        * @return - if cell has succesfully initiated its life cycle within the org
     */
    function transduce(address subCell, uint64 helix) public returns(bool) {
        // TODO @Abstract2Soul
        // - when can you grow. How to accept them into org. initial life cycle, etc.
        LifeCycles _currentCycle = self.currentCycle;
        require(_currentCycle == LifeCycles.Reproducing || _currentCycle == LifeCycles.Growing);
        
        // TODO require soul to verify acceptance of new cell.
        // Update DNA helix with LifeCycle/role

        // CellDNA storage dna = self.cells[subCell];
        self.cells[subCell] = CellDNA({
            currentCycle: LifeCycles.Inseminating,
            helix: helix,
            signal: 0
        });

        return true;
    }

    /**
     * @notice - Allows a new MetaOrg cell to split from this MetaOrg and take some of its resources
     * @dev - Only callable by a cell in the Growing or Reproducing phase
        * @param requisitions - calls to resources contracts to transfer to new cell
        * @param asRoot - if requisitions should be called from MetaOrg directly or from Safe MetaOrg controls
        * @return shenanigans - SafeAction or SafeTransaction to execute to complete the split
     */
    function mitosis(bool asRoot, string calldata willToLive, bytes[] calldata requisitions)
        public
        returns(ISafeProtocolPlugin.Action[] memory shenanigans)
    {
        LifeCycles _currentCycle = self.currentCycle;

        // TODO @Abstract2Soul
        // can only fork if in a phase change
        if(_currentCycle == LifeCycles.Exploring) {
            CellDNA memory dna = self.cells[msg.sender];
            require(activeInPhase(dna.helix, uint8(LifeCycles.Exploring)));
            if(dna.signal > (totalSupply() * 2 / 100)) {
                // TODO @Abstract2Soul
                // TODO figure out exit rights, access/resource controls per cell/helix
                // _decompose();
            }
            // birth new org
            globify(address(this), self.plasmaMembranes[0], willToLive);
            // send assets/permissions/etc to new organism
            shenanigans[0] = ISafeProtocolPlugin.Action({
                to: payable(address(this)),
                value: 0,
                data: abi.encodeWithSignature(
                    "decompose(bytes[])",
                    requisitions
                )
            });
        } else if (_currentCycle == LifeCycles.Dying) {
            CellDNA memory dna = self.cells[msg.sender];
            require(activeInPhase(dna.helix, uint8(LifeCycles.Dying)));
            
            if(dna.signal > (totalSupply() * 2 / 100)) {
                // TODO @Abstract2Soul
                // TODO figure out exit rights, access/resource controls per cell/helix
                // _decompose();
            }
            // birth new org
            blobify(willToLive);
            // send assets/permissions/etc to new organism
            shenanigans[0] = ISafeProtocolPlugin.Action({
                to: payable(address(this)),
                value: 0,
                data: abi.encodeWithSignature(
                    "decompose(bytes[])",
                    requisitions
                )
            });
        }
    }

    /**
    * @notice - Start transferring resources away from this MetaOrganism if it is dying
    * @dev - Only callable by any Autophage role
    * @param requisitions - resource to transfer away - ERC20, ERC721, Hat, etc.
    */
    function _decompose(bytes calldata requisitions) internal returns(bool) {
        require(self.currentCycle == LifeCycles.Recycling);
        
        CellDNA memory dna = self.cells[msg.sender];
        require(activeInPhase(dna.helix, uint8(LifeCycles.Dying)));

        // TODO @Abstract2Soul
        // TODO figure out exit rights, access/resource controls per cell/helix
        // TODO multicall contract?
        activeSoul().decompose(requisitions);
        // return as root SafeTransaction for account to execute directly

        return true;
    }

    /**
     * @notice - Update lifecycle that an organism is in and the oul that manages it
     * @return currentLifecycle - lifecycle that the organism is in post-mutation
     * @return soul - smart account that manages the organism in the current lifecycle
     */
    function _mutate() internal returns(LifeCycles, address){
        // check to see what cycle we SHOULD be in
        // if different change cycle and current operator
        // how do we let people decide how/when things should be changed
        // TODO @Abstract2Soul
        return (self.currentCycle, address(this));
    }

    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return interfaceId == type(IERC165).interfaceId ||
                interfaceId == type(IMetaOrg).interfaceId;
    }
}
