pragma solidity ^0.8.17;

/**
 * @dev Interface of the ERC165 standard, as defined in
 * https://eips.ethereum.org/EIPS/eip-165[EIP]
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements a function
            with the same selector as `interfaceId`.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}