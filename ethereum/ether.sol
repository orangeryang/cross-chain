// SPDX-License-Identifier: MIT
// 0x6FdCDc13307ed6f2eb93013FdA18852Cc9078B52

pragma solidity ^0.8.4;

// starknet core contract
interface IStarknet {
    // https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/starknet/solidity/StarknetMessaging.sol
    function sendMessageToL2(uint256 toAddress, uint256 selector, uint256[] calldata payload)
        external
        payable
        returns (bytes32, uint256);
}

// cc contract on ethereum
interface IDungeons {
    // 0x55819665a67D84D5A9476B7Ee0310c205a70fE75
    function seeds(uint256 id) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract Test {
    event MessageHash(bytes32 msgHash, uint256 nonce);

    // cc on ethereum
    address constant CC_ETH = 0x55819665a67D84D5A9476B7Ee0310c205a70fE75;

    // starknet core contract on goerli
    address constant STARKNET_CORE = 0xde29d060D45901Fb19ED6C6e959EB22d8626708e;

    // target contract on starknet
    uint256 constant CC_STARKNET = 0x004d026d61777f03c9779ef6d8c1d2998be4fd598bbda14d3b0376daacbb26ba;
    // function selector
    uint256 constant RELATE = 0x02309e968b8f851ab48a62bde0b1f89c1bed2fdb5559d14c94bc6fdee675d5b4;

    // address owner;
    constructor() {
        // owner = msg.sender;
    }

    function relate(uint256 tokenId, uint256 starknetAddress) public payable returns (bytes32, uint256) {
        address ccOwner = IDungeons(CC_ETH).ownerOf(tokenId);
        require(ccOwner == msg.sender, "not ccOwner");
        uint256 seed = IDungeons(CC_ETH).seeds(tokenId);

        uint256[] memory data = new uint256[](5);
        // token_id: u128
        data[0] = tokenId;
        // seed: u256
        data[1] = uint256(uint128(seed));
        data[2] = uint256(uint128(seed >> 128));
        //eth_account: felt252
        data[3] = uint256(uint160(address(ccOwner)));
        // starknet_account: felt252
        data[4] = starknetAddress;

        (bytes32 msgHash, uint256 nonce) =
            IStarknet(STARKNET_CORE).sendMessageToL2{value: msg.value}(CC_STARKNET, RELATE, data);

        emit MessageHash(msgHash, nonce);

        return (msgHash, nonce);
    }

}
