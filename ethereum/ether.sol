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
    uint256 constant GET = 0x0017c00f03de8b5bd58d2016b59d251c13056b989171c5852949903bc043bc27;
    uint256 constant SAMPLE = 0x000204f7e9243e4fca5489740ccd31dcd0a54619a7f4165cee73c191ef7271a1;

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

    // -----------------------------------------------------------------------

    function test() public payable returns (bytes32, uint256) {
        uint256[] memory data = new uint256[](5);
        uint256 seed = 74972505546522576923818356636106108867838777210876644873069541021231591033714;
        uint128 low = uint128(seed);
        uint128 high = uint128(seed >> 128);

        data[0] = 1;
        data[1] = uint256(low);
        data[2] = uint256(high);
        data[3] = uint256(uint160(address(this)));
        data[4] = 0x00d0c2b4aB3d70769B34DFfA5Ee5eee11a54cD1D6dA4E89bf97AFa8bA35770f1;

        (bytes32 msgHash, uint256 nonce) =
            IStarknet(STARKNET_CORE).sendMessageToL2{value: msg.value}(CC_STARKNET, GET, data);

        emit MessageHash(msgHash, nonce);

        return (msgHash, nonce);
    }

    function test2() public payable returns (bytes32, uint256) {
        uint256[] memory data = new uint256[](2);

        data[0] = 1;
        data[1] = 22222;

        (bytes32 msgHash, uint256 nonce) =
            IStarknet(STARKNET_CORE).sendMessageToL2{value: msg.value}(CC_STARKNET, SAMPLE, data);

        emit MessageHash(msgHash, nonce);

        return (msgHash, nonce);
    }
}
