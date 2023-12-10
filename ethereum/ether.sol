// SPDX-License-Identifier: MIT
// 0x63feb1704da0d3d537796b0c630e6ed340faf958

pragma solidity ^0.8.4;

contract Test {
    event MessageHash(bytes32 msgHash, uint256 nonce);

    constructor() {}

    function test() public payable returns (bytes32, uint256) {
        uint256[] memory data = new uint256[](5);
        uint256 seed = 74972505546522576923818356636106108867838777210876644873069541021231591033714;
        uint128 low = uint128(seed);
        uint128 high = uint128(seed >> 128);

        data[0] = 1;
        data[1] = uint256(low);
        data[2] = uint256(high);
        data[3] = uint256(uint160(address(this)));
        data[
            4
        ] = 0x00d0c2b4aB3d70769B34DFfA5Ee5eee11a54cD1D6dA4E89bf97AFa8bA35770f1;

        (bytes32 msgHash, uint256 nonce) = Starknet(
            0xde29d060D45901Fb19ED6C6e959EB22d8626708e
        ).sendMessageToL2{value: msg.value}(
            0x076130542bcc89b85d6d0570ce1a16fb4a8a4b40cdcc53cad9a69d69f94ee88b,
            0x0017c00f03de8b5bd58d2016b59d251c13056b989171c5852949903bc043bc27,
            data
        );

        emit MessageHash(msgHash, nonce);

        return (msgHash, nonce);
    }

    function test2() public payable returns (bytes32, uint256) {
        uint256[] memory data = new uint256[](2);

        data[0] = 1;
        data[1] = 22222;

        (bytes32 msgHash, uint256 nonce) = Starknet(
            0xde29d060D45901Fb19ED6C6e959EB22d8626708e
        ).sendMessageToL2{value: msg.value}(
            0x076130542bcc89b85d6d0570ce1a16fb4a8a4b40cdcc53cad9a69d69f94ee88b,
            0x000204f7e9243e4fca5489740ccd31dcd0a54619a7f4165cee73c191ef7271a1,
            data
        );

        emit MessageHash(msgHash, nonce);

        return (msgHash, nonce);
    }
}

interface Starknet {
    // https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/starknet/solidity/StarknetMessaging.sol
    function sendMessageToL2(
        uint256 toAddress,
        uint256 selector,
        uint256[] calldata payload
    ) external payable returns (bytes32, uint256);
}
