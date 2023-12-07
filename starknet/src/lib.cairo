// 0x018a77a46f9e8d742aa9642bb5e3fb510eda6b8ebc1ac36f6109e1c60d6f838a

#[starknet::contract]
mod gotit {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        seed: LegacyMap::<u128, u256>,
    }

    #[l1_handler]
    fn get(
        ref self: ContractState,
        from_address: felt252,
        id: u128,
        seed: u256,
        eth_account: felt252,
        starknet_account: ContractAddress
    ) -> felt252 {
        self.seed.write(id, seed);

        from_address
    }

    #[external(v0)]
    fn get_seed(self: @ContractState, id: u128) -> u256 {
        self.seed.read(id)
    }
}

