
pragma solidity ^0.4.24;

// import { } from "@safe";

/**
 * @title Panspermia
 * @notice - Define the constants of life for all organisms
 * @dev - Should be able to skip from any cycle to another one e.g.
 *        Inseminating -> Dying. Reproducing -> Incubating
 */
enum LifeCycles {
    // birth cycles
    Inseminating,
    Incubating,
    // main (healthy) cycles
    Discovering,
    Growing,
    Reproducing,
    // death cycles
    Dying,
    Recycling,
}

// TODO these should all be Hats and MetaOrg defines eligibility for each
// which could be # love staked or something else
enum BioRoles {
    Plasma,     // creates stability within org
    StemCell,   // create new things within org - interconnections, new organelles, etc.
    Membrane,   // separate external good vs bad things 
    Enzyme,     // facilitate internal or external interactions
    Antiphage,  // separate internal good vs bad things
    Nucleus,    // control org(s) and their actions
}

struct MetaOrgDNA {
    // remove would just be hats and check that
    // mapping(BioRoles => bool) roles; // how organelle can operate
    mapping(LifeCycles => bool) supportingCycles; // when organelle can operate
    mapping(address => uint256) loves; // cell -> staked
}

/**
 * @title - 
 * @notice - deploys a new Safe smart account with MetaOrg configuration
 */
function blobify(address parent) public pure returns(address) {
    // deploy smart account
    // setup default MetaOrg modules
    // if parent != 0, add modules for default parent org
    return address(0);
}