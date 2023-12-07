// 0x076130542bcc89b85d6d0570ce1a16fb4a8a4b40cdcc53cad9a69d69f94ee88b

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

