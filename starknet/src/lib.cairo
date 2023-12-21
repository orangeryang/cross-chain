// 0x004d026d61777f03c9779ef6d8c1d2998be4fd598bbda14d3b0376daacbb26ba

// this should be integrated into C&C contract
#[starknet::contract]
mod gotit {
    use core::array::ArrayTrait;
    use core::traits::TryInto;
    use core::option::OptionTrait;
    use starknet::{
        ContractAddress, EthAddress, contract_address_try_from_felt252, send_message_to_l1_syscall,
        SyscallResult
    };

    #[storage]
    struct Storage {
        relater: felt252,
        eth_owner: LegacyMap::<u128, felt252>,
        seeds: LegacyMap::<u128, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Related: Related,
    }

    #[derive(Drop, starknet::Event)]
    struct Related {
        from_address: felt252,
        #[key]
        id: u128,
        seed: u256,
        #[key]
        eth_account: felt252,
        starknet_account: ContractAddress
    }

    #[external(v0)]
    fn get_eth_owner(self: @ContractState, id: u256) -> felt252 {
        self.eth_owner.read(id.try_into().unwrap())
    }

    #[external(v0)]
    fn get_seeds(self: @ContractState, id: u256) -> u256 {
        self.seeds.read(id.try_into().unwrap())
    }

    #[external(v0)]
    fn set_relater(ref self: ContractState, eth_address: felt252) {
        let test: EthAddress = eth_address.try_into().expect('invalid eth address');
        self.relater.write(eth_address);
    }

    #[external(v0)]
    fn get_relater(self: @ContractState) -> felt252 {
        self.relater.read()
    }

    // Since the relationship between token IDs and owners is one-to-one
    // but the relationship between addresses is not necessarily one-to-one
    // we have chosen token ID as a more granular association

    #[l1_handler]
    fn relate(
        ref self: ContractState,
        from_address: felt252,
        id: u128,
        seed: u256,
        eth_account: felt252,
        starknet_account: felt252
    ) -> felt252 {
        assert(self.relater.read() == from_address, 'invalid relater');

        let starknet_account: ContractAddress = contract_address_try_from_felt252(starknet_account)
            .expect('invalid starknet address');

        self.emit(Related { from_address, id, seed, eth_account, starknet_account });

        self.seeds.write(id, seed);
        self.eth_owner.write(id, eth_account);

        from_address
    }

    #[external(v0)]
    fn send_to_l1(
        ref self: ContractState, to: felt252, input: Array<felt252>
    ) -> SyscallResult<()> {
        send_message_to_l1_syscall(to, input.span())
    }
}

