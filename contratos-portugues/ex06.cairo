// ######## Ex 06
// Funções Externas vs Funções Internas
// Nesse exercício você precisará:
// - Chame uma das funções para ser designado uma das variáveis privadas
// - Chame uma das função interna para duplicar ess variável para uma variável pública
// - Chame uma das funções para mostrar que você sabe o valor correto dessa variável privada
// - Receba os pontos do contrato

%lang starknet

from starkware.cairo.common.cairo_builtinse import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Declarando variáveis na memória/a serem armazenadas
// Variáveis em memória são por padrão não visíveis pelo ABI. Eles são similares às variáveis "privadas" do Solidity
//

@storage_var
func user_slots_storage(account:felt) -> (user_slots_storage: felt){
}

@storage_var
func user_values_public_storage(account:felt) -> (user_values_public_storage: felt){
}

@storage_var
func values_mapped_secret_storage(slot: felt) -> (values_mapped_secret_storage: felt){
}

@storage_var
func was_initialized() -> (was_initialized: felt) {
}

@storage_var
func next_slot() -> (next_slot: felt){
}

//
// Declarando "getters" / funções para acessar as variáveis em memória
// Variáveis públicas devem ser declaradas explicitament com uma função "getter"
//

@view
func user_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (
    user_slot: felt
) {
    let (user_slot) = user_slots_storage.read(account);
    return (user_slot,);
}

@view
func user_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (user_value: felt) {
    let (value) = user_values_public_storage.read(account);
    return (value,);
}

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _terc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
) {
    ex_initializer(_terc20_address, _players_registry, _workshop_id,_exercise_id);
    return();
}

//
// Funções externas
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    expected_value: felt
) {
    //Lendo o endereço do usuário que esta chamando o contrato
    let (sender_address) = get_caller_address();
    // Checando que o usuário foi designado um "slot"
    let (user_slot) = user_slots_storage.read(sender_address);
    with_attr error_message("User slot not assigned. Call assing_user_slot"){
        assert_not_zero(user_slot);
    }

    // Checando que o valor proposto pelo usuário é o valor que esperamos
    // Continua com um pouco de pegadinha
    // Ou será que não?
    let (value) = values_mapped_secret_storage.read(user_slot);
    with_attr error_message("random values already initialized"){
        assert value = expected_value;
    }

    //Checando se o usuário ja validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço especificado pelo usuário nos parametros
    distribute_points(sender_address,2);
    return ();
}

@external
func assign_user_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr{}(){
    // Lendo o endereço do usuário que está chamando o contrato
    let (sender_address) = get_caller_address();
    let (next_slot_temp) = next_slot.read();
    let (next_value) = values_mapped_secret_storage.read(next_slot_temp + 1);
    if (next_value == 0){
        user_slots_storage.write(sender_address,1);
        next_slot.write(0);
    } else {
        user_slots_storage.write(sender_addressm next_slot_temp +1);
        next_slot.write(next_slot_temp +1);
    }
    return();
}

@external
func external_handler_for_internal_function{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(a_value: felt){
    //Lendo o endereço do usuário que está chamando o contrato
    let (sender_address) = get_caller_address();
    with_attr error_message("Value provided is not 0"){
        // Apenas for diversão
        assert a_value = 0;
    }
    // Chamando a função interna
    copy_secret_value_to_readable_mapping(sender_address);
    return();
}

//
// Funções Internas
// Essas funções apenas podem ser chamadas dentro de outras funções no contrato
// Talvez alguma função externa possibilite que você chame alguma das funções internas?
//

func copy_secret_value_to_readable_mapping{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(sender_address: felt){
    with_attr error_message("User slot not assigned. Call assign_user_slot"){
        //Checando que o usuário tem um "slot" designado
        let (user_slot) = user_slots_storage.read(sender_address);
        assert_not_zero(user_slot);
    }

    // Lendo os valores secretos
    let (secret_value) = values_mapped_secret_storage.read(user_slot);

    //Copiando o valor de uma variável "não acessível" para
    user_values_public_storage.write(sender_address, secret_value);
    return();
}

//
// Funções externas - Administração
// Apenas administradores podem chamar essas funções. Você não prcisa entender elas para finalizar o exercício
//

@external
func set_random_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
) {
    with_attr error_message("random values already initialized"){
        // Checando se os valores aleatórios ja foram inicializados
        let (was_initialized_read) = was_initialized.read();
        assert was_initialized_read = 0;
    }

    // Armazenando os valores passados para função na memória
    set_a_random_value(values_len, values);

    //Marcar que os valores aleatórios foram inicializados
    was_initialized.write(1);
    return();
}

func set_a_random_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
) {
    if(values_len == 0){
        // Começar com "sum"/soma = 0
        return ();
    }

    set_a_random_value(values_lens = values_lens -1, values = values +1);
    values_mapped_secret_storage(values_len -1, [values]);

    return ();
}