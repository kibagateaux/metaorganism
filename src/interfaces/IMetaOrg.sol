import {IERC20} from "solady/tokens/IERC20.sol";
// import {Hats} from "hatsprotocol";

import {
    LifeCycles
} from "../Panspermia.sol";

interface IMetaOrg is IERC20 {
    function currentCycle() external view returns(LifeCycles);
    function egos(uint8) external view returns(address);
    

    function mutate() external returns(LifeCycles, address);

    // stake to a suborg
    function love(uint256, address) external returns(bool);

    // Plasma

    // Stem Cell
    function birth(address[] _egos) external returns(address);

    // AntiPhage
    function tPose(address) external returns(bool);
    function killCancer(address, uint256) external returns(bool);

    // Nucleus 
    function takeLSD() external returns(bool); // lets them update Egos

}