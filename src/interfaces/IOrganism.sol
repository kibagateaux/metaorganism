interface IOrganism {
   
    /**
    * @notice blob = 1. an amorphous mass 2. a semi-liquid collection of objects
    *           Signals with primaryResource that we should collaborate with some cell* @dev - alias = transduce
    * @param subCell - cell to be created
    * @param amount - amount of resources to be used to create the cell
    */
    function blob(address subCell, uint256 amount) external returns(bool);
    function signalSub(address subCell, uint256 amount) external returns(bool);

    /**
    * @notice glob = 1. to stick to 2. gobbing blobs
    *           Signals with primaryResource that we should collaborate with some cell
    *       
    * @dev - TODO should we add peerSubCell as param bc you need to signal how woe integrate, not just who we integrate with?
    * @param peerCell - cell to be created
    * @param peerAmount - amount of peer's primary resources to signal on them to join the cell
    * @param selfAmount - amount of primary resources to signal that peer should connect with our us
    */
    function glob(address peerCell, uint256 peerAmount, uint256 selfAmount) external returns(bool);
    function signalPeer(address peerCell, uint256 peerAmount, uint256 selfAmount) external returns(bool);


    /**
    * @notice - flob = 1. to spit 2. to be uncoordinated.
    *           Implies this is a coordination failure and should be avoided
    *           Burns primaryResource to signal that some cell should be attacked. `amount` is unrecoverable by signaler
    * @dev - 
    * @param enemyCell - cell to be created
    * @param amount - amount of primary resources to signal that peer should connect with our us
    */
    function flob(address enemyCell, uint256 amount) external returns(bool);
    function signalEnemy(address enemyCell, uint256 amount) external returns(bool);

    function decompose(bytes calldata requisitions) external returns(bool);
}