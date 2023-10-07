import {IERC165} from "./IERC165.sol";

/**
 * @title ISafeProtocolPlugin - An interface that a Safe plugin should implement
 */
interface ISafeProtocolPlugin is IERC165 {

    struct Action {
        address payable to;
        uint256 value;
        bytes data;
    }

    struct Tx {
        Action[] actions;
        uint256 nonce;
        bytes32 metadataHash;
    }

    struct RootAccess {
        Action action;
        uint256 nonce;
        bytes32 metadataHash;
    }

    /**
     * @notice A funtion that returns name of the plugin
     * @return name string name of the plugin
     */
    function name() external view returns (string memory name);

    /**
     * @notice A function that returns version of the plugin
     * @return version string version of the plugin
     */
    function version() external view returns (string memory version);

    /**
     * @notice A function that returns information about the type of metadata provider and its location.
     *         For more information on metadata provider, refer to https://github.com/safe-global/safe-core-protocol-specs/.
     * @return providerType uint256 Type of metadata provider
     * @return location bytes
     */
    function metadataProvider() external view returns (uint256 providerType, bytes memory location);

    /**
     * @notice A function that indicates permissions required by the.
     * @dev Permissions types and value: EXECUTE_CALL = 1, CALL_TO_SELF = 2, EXECUTE_DELEGATECALL = 4.
     *      These values can be sumed to indicate multiple permissions. e.g. EXECUTE_CALL + CALL_TO_SELF = 3
     * @return permissions Bit-based permissions required by the plugin.
     */
    function requiresPermissions() external view returns (uint8 permissions);
}