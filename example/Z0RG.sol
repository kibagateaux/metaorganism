import { MetaOrg } from '../src/MetaOrg.sol';

contract God {
    constructor(address openSoul) {
        MetaOrg zorg = new MetaOrg();
        zorg.initialize(address(0), 100 ether, [
            openSoul,
            openSoul,
            openSoul,
            openSoul,
            openSoul,
            openSoul,
            openSoul
        ]);
        // zorg.blob("ETH Gobbler", "Z0RG Treasury Management", "0x0");
        // zorg.blob("NooType Nation", "Z0RG Vision & Strategy") // All Souls use Jubjub cards;
    }
    
    function _mutate() internal override {
        // Z0RG is self. We are void. We are everything at once, no need to mutate.
        return (LifeCycles.Reproducing, address(this));
    }
}