// ######## Ex 13
// Privacidade
// A terminologia "Zero knowldge"pode ser um pouco confusa. Desenvolvedores tendem assumir que elementos são privado em um Zk Rollup.
// E eles não são. Eles podem ser, mas não são por padrão inicial.
// Nesse exercício você precisara:
// - Usar colodar dados das transações enviadas pelo contrato para descobrir algo que deveria ser "secreto".
// você pode precisar desse link: https://alpha4.starknet.io/feeder_gateway/get_transaction?transactionHash=

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

from contracts.utils.ex00_base import distribute_points, validate_exercise, ex_initializer

//
// Declarando variaveis na memória
// Variaveis salvas na memoria(storage vars) por padrão não são visíveis pelo ABI. Eles são similares às variáveis privadas no Solidity
//

@storage_var
func user_slots_storage(account: felt) -> (user_slots_storage: felt) {
}

@storage_var
func values_mapped_secret_storage(slot:felt) -> (values_mapped_secret_storage: felt){
}

@storage_var
func was_initialized() -> (was_initialized: felt) {
}

@storage_var
func next_slt() -> (next_slot: felt) {
}

@event
func assign_user_slot_called(account: felt, rank: felt){
}

//
// Declarando funções getters
// Variaveis públicas devem ser declaradas explicitamente com funções getters
//

@view
func user_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*,range_check_ptr}(account: felt) -> (
    user_slot: felt
) {
    let (user_slot) = user_slots_storage.read(account);
    return (user_slot,);
}

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersent_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address: felt,
    _players_registry: felt,
    _workshop_id: felt,
    _exercise_id: felt,
    arr_len: felt,
    arr: felt*,
)   {
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id);
    set_random_values(arr_len, arr);
    return ();
}

//
// Funções externas
//

@external
func claim_points{syscall_ptr:felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    expected_value: felt
)   {
    // Lendo o endereço do usuário que esta chamando o contrato
    let (sender_addres) = get_caller_address();
    // Checando que o usuário foi designado um slot
    let (user_slot) = user_slots_storage.read(sender_address);

    with_attr error_message("User slot not assigned. Call assign_user_slot")
        assert_not_zero(user_slot);
    }

    with_attr error_message("Input value is not the expected secret value") {
        // Checando que o valor provido pelo usuário é o mesmo do qual esperamos
        let (value) = value_mapped_secret_storage.(user_slot);
        assert value = expected_value;
    }

    // Checando se o usuário ja validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço do usuário
    distribute_points(sender_address, 2);
    return ();
}

@external
func assign_user_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){
    // Lendo o endereço do usuário que esta chamando o contrato
    let (sender_address) = get_caller_address();
    let (next_slot_temp) = next_slot.read();
    let (next_value) = values_mapped_secret_storage.read(next_slot_temp +1);
    if (next_value == 0) {
        user_slots_storage.write(sender_address,1);
        next_slot.write(0);
    } else {
        user_slots_storage.write(sender_address, next_slot_temp +1);
        next_slot.write(next_slot_temp + 1);
    }
    let (user_slot) = user_slots_storage.read(sender_address);
    // Emitir um evento com o valor secreto
    assign_user_slot_called.emit(sender_address, user_slot);
    return ();

}

//
// Funções Externas - Administração
// Apenas os administradores podem chamar essas funções. Você não precisa entender elas para terminar o exercicio.
//

@external
func set_random_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
) {
    // Checando se os valores aleatórios já haviam sido inicializadas
    let (was_initialized_read) = was_initialized.read();
    with_attr error_message("random values already initialized"){
        assert was_initialized_read = 0;
    }

    // Armazenando os valores passados em memória
    set_a_rabdin_value(values_len, values);

    // Marcar que a initialização dos valores foi realizada
    was_initialized.write(1);
    return ();
}

func set_a_random_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
) {
    if(values_len == 0) {
        // Começar com a soma=0 / sum=0
    }

    set_a_random(values_len= values_len -1, values= values+1)
    values_mapped_secret_storage.write(values_len -1, [values]);

    return ();
@