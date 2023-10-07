import { Test } from 'forge-std/Test.sol';


// Foundry testing framework best practivces
// https://book.getfoundry.sh/forge/invariant-testing#invariant-targets
// https://book.getfoundry.sh/forge/invariant-testing#handler-functions
// https://book.getfoundry.sh/forge/invariant-testing#function-level-assertions
// https://book.getfoundry.sh/forge/invariant-testing?highlight=invariant#actor-management

/**
 * @title BaseMetaOrgTestSetup
 * @dev - functionality for complex invariant testing and p2p metaorganism agent based modeling 
*/
contract BaseMetaOrgTestSetup is Test {    
    address[] public actors;
    address internal currentActor;

    address[] public cells;
    address internal currentCell;

    modifier useActor(uint256 actorIndexSeed) {
        currentActor = actors[bound(actorIndexSeed, 0, actors.length - 1)];
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    modifier useOrganism(uint256 cellIndexSeed) {
        currentCell = actors[bound(cellIndexSeed, 0, cells.length - 1)];
        vm.startPrank(currentCell);
        _;
        vm.stopPrank();
    }

    /**
    */
    function blob(
        uint256 assets,
        uint256 actorIndexSeed,
        uint256 cellIndexSeed
    ) public virtual useActor(actorIndexSeed) {

    }
}