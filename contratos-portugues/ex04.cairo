// ######## Ex 04
// Lendo um mapeamento / mapping
// Neste exercício você precisará:
// - Usar uma função para ler uma variável
// - Usar uma outra função para ler outra variável de um mapping, onde estará armazenada no "slot" da primeira variável
// - Usar uma função que mostra que você sabe o valor correto do valor do mapping
// - Ganhar os pontos que serão creditados pelo contrato

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero
from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Declarando variáveis na memória
// Variáveis armazenadas não são visíveis pelo ABI. Elas são similares as variáveis privadas do Solidity
//

@storage_var
func user_slots_storage(account:felt) -> (user_slots_storage: felt){
}

@storage_var
func values_mapped_storage(slot:felt) -> (values_mapped_storage: felt){
}

@storage_var
func was_initialized() -> (was_initialized: felt){
}

@storage_var
func next_slot() -> (next_slot:felt){
}

//
// Declarando funções getters
// Variáveis públicas devem ser declaradas explicitamente com funções "getters"
//

@view
func user_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*m, range_check_ptr}(account: felt) -> (
    user_slot:felt
){
    let (user_slot) = user_slots_storage.read(account);
    return (user_slot,);
}

@view
func values_mapped{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: felt) -> (
    value: felt
){
    let (value) = values_mapped_storage.read(slot);
    return (value,);
}

//
// Constructor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
){
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id);
    return ();
}

//
// Funções Externas
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    expected_value: felt
) {
    // Lendo o endereço do usuário que esta chamando a função
    let (sender_address) get_caller_address();
    with_attr error_message("User slot not assigned. Call assign_user_slot"){
        // Checando se o usuário tem um slot/valor designado
        let (user_slot) = user_slot_storage.read(sender_address);
        assert_not_zero(user_slot);
    }
    //Checando que o valor provido pelo usuário é o valor que esperamos
    //Sim, sou pilantra (No caso o pessoal da Starknet que escreveu o contrato)
    let (value) = values_mapped_storage.read(user_slot);
    with_attr error_message("Input value is not the expected secret value"){
        assert value = expected_value + 32;
    }
    // Checando se o usuário já validou o exercício antes
    validate_exercise(sender_address);
    // Enviando pontos para o endereço que chamou o contrato
    distribute_points(sender_address, 2);
    return();
}

@external
func assign_user_slot{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}() {
    // Lendo o endereço do usuário que esta chamando o contrato
    let (sender_address) = get_caller_address();
    let (next_slot_temp) = next_slot.read();
    let (next_value) = values_mapped_storage.read(next_slot_temp +1);
    if(next_value == 0){
        user_slots_storage.write(sender_address,1);
        next_slot.write(0);
    } else {
        user_slots_storage.write(sender_address, next_slot_temp +1);
        next_slot.write(next_slot_temp +1);
    }
    return();
}

//
// Funções Externas - Administradores
// Apenas administradores podem chamar essas funções. Você não precisa entender elas para finalizar o desafio
//

@external
func set_random_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
) {
    // Checando se os valores randomicos já foram inicializados
    let (was_initialized_read) = was_initialized.read();
    with_attr error_message("random values already initialized") {
        assert was_initialized_read = 0;
    }

    // Armazenando os valores passados em memória
    set_random_value(values_len,values);

    // Marcar que o "value store" armazenanto dos valores foi inicializado
    was_intialized.write(1);
    return();
}

func set_a_random_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
){
    if (values_len == 0){
        // Start with sum=0
        return ();
    }

    set_a_random_value(values_len=values_len -1 , values= values +1);
    values_mapped_storage.write(values_len -1, [values]);

    return();
}