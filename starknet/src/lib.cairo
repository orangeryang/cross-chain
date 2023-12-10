// 0x076130542bcc89b85d6d0570ce1a16fb4a8a4b40cdcc53cad9a69d69f94ee88b

#[starknet::contract]
mod gotit {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        seed: LegacyMap::<u256, u256>,
        sam: LegacyMap::<u128, u128>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BeCalled: BeCalled,
        Sampled: Sampled
    }

    #[derive(Drop, starknet::Event)]
    struct BeCalled {
        #[key]
        from_address: felt252,
        #[key]
        id: u256,
        seed: u256,
        eth_account: felt252,
        starknet_account: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct Sampled {
        #[key]
        from_address: felt252,
        #[key]
        id: u128,
        seed: u128
    }

    #[l1_handler]
    fn get(
        ref self: ContractState,
        from_address: felt252,
        id: u256,
        seed: u256,
        eth_account: felt252,
        starknet_account: ContractAddress
    ) -> felt252 {
        self.emit(BeCalled { from_address, id, seed, eth_account, starknet_account });

        self.seed.write(id, seed);

        from_address
    }

    #[l1_handler]
    fn sample(
        ref self: ContractState, from_address: felt252, id: felt252, seed: felt252,
    ) -> felt252 {
        let id: u128 = id.try_into().unwrap();
        let seed: u128 = seed.try_into().unwrap();

        self.emit(Sampled { from_address, id, seed });

        self.sam.write(id, seed);

        from_address
    }

    #[external(v0)]
    fn get_seed(self: @ContractState, id: u256) -> u256 {
        self.seed.read(id)
    }
}

