// SPDX-License-Identifier: MIT
// 0x081dc2733d92a18d297CD770590FACE57B577a2C

pragma solidity ^0.8.4;

contract Test {
    constructor() {}

    function test() public payable returns (bytes32, uint256) {
        uint256[] memory data = new uint256[](6);
        uint256 seed = 74972505546522576923818356636106108867838777210876644873069541021231591033714;
        uint128 low = uint128(seed);
        uint128 high = uint128(seed >> 128);

        data[
            0
        ] = 0x018a77a46f9e8d742aa9642bb5e3fb510eda6b8ebc1ac36f6109e1c60d6f838a;
        data[1] = 1;
        data[2] = low;
        data[3] = high;
        data[4] = uint256(uint160(address(this)));
        data[
            5
        ] = 0x00d0c2b4aB3d70769B34DFfA5Ee5eee11a54cD1D6dA4E89bf97AFa8bA35770f1;

        return
            Starknet(0xde29d060D45901Fb19ED6C6e959EB22d8626708e)
                .sendMessageToL2{value: msg.value}(
                0x018a77a46f9e8d742aa9642bb5e3fb510eda6b8ebc1ac36f6109e1c60d6f838a,
                0x01962ff092d95f8556c80858905718710284206123c65fbd6e5ca7e076b21c15,
                data
            );
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
