// ######## Exercício 12
// Eventos
// Nesse exercício você precisara:
// - Usar uma das funções para ser designado um valor privado
// - Usar uma outra função para emitir eventos do valor privado
// - Os seus pontos serão creditados pelo contrato

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
import starkware.starknet.common.syscalls import get_caller_address

from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Declarando variáveis em memória (storage vars)
// Variaáveis em memória (Storage vars) por padrão não são visíveis pelo ABI. Eles são similares as variáveis "privadas" no Solidity
//

@storage_var
func user_slots_storage(account: felt) -> (user_slots_storage:felt){
}

@storage_var
func values_mapped_secret_storage(slot: felt) -> (values_mapped_secret_storage: felt){
}

@storage_var
func was_initialized() -> (was_initialized: felt) {
}

@storage_var
func next_slot() -> (next_slot: felt) {
}

@event
func assign_user_slot_called(account:felt, secret_value:felt){
}

//
// Declarando funções getters 
// Variáveis públicas devem ser declaradas explicitamente com funções getters
//

@view
func user_slots{syscall_ptr: felt*, pederesen_ptr: HashBuiltin*, range_check_ptr}(account: felt) ->(
    user_slot: felt
) {
    let (user_slot) = user_slots_storage.read(account);
    return (user_slot,);
}

//
// Construtores
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
)   {
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
    // Lendo o endereço do usuário que esta chamando esse contrato
    let (sender_address) = get_caller_address();
    // Checando se o usuário tem um slot designado
    let (user_slot) = user_slots_storage.read(sender_address);
    with_attr error_message("User slot not assigned. Call assign_user_slot"){
        assert_not_zero(user_slot);
    }

    // Checando se o valor que foi provido pelo usuário é o valor que esperamos
    // Continuamos(O time da Starkware) com prilantragens
    // Ou não?
    let (value) = values_mapped_secret_storage.read(user_slot);
    with_attr error_message("Input value is not the expected secret value"){
        assert value = expected_value;
    }

    // Checando se o usuário já validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço do usuário que está chamando o contrato
    distribute_points(sender_address, 2);
    return ();
}

@external
func assign_user_slot{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}() {
    //  Lendo o endereço do usuário que está chamando o contrato
    let (sender_address) = get_caller_address();
    let (next_slot_temp) = next_slot.read();
    let (next_value) = values_mapped_secret_storage.read(next_slot_temp + 1);
    if (next_value == 0) {
        user_slots_storage.write(sender_address,1);
        next_slot.write(0);
    } else {
        user_slots_storage.write(sender_address, next_slot_temp +1);
        next_slot.write(next_slot_temp +1);
    }
    let (user_slot) = user_slots_storage.read(sender_address);
    let (secret_value) = values_mapped_secret_storage.read(user_slot);
    // Emitir o evento com o valor secreto
    assign_user_slot_called.emit(sender_address, secret_value + 32);
    return ();
}

//
// Funções externas - Administração
// Apenas administradores podem chamas essas funções. Você não precisa entender-las para finalizar o exercício.
//

@external
func set_random_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_otr}(
    values_len: felt, values: felt*
)   {
    //  Checar se os valores aleatórios ja foram inicializados
    let (was_initialized_read) = was_initialized.read();
    with_attr error_message("random value already initialized"){
        assert was_initialized_read = 0;
    }

    // Armazenando os valores aleatórios providos
    set_a_random_value(values_len, values);

    // Marca que o armazenamento dos valores aleatórios foi finalizada
    was_initialized.write(1);
    return();
}

func set_a_random_value{syscall_ptr: felt* , pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
)   {
    if (values_len == 0) {
        // Começa com "sum=0" / soma = 0
        return ();
    }

    set_a_random_value(values_len=values_len -1 , values=values +1);
    values_mapped_secret_storage.write(values_len -1 , [values]);

    return ();
}



