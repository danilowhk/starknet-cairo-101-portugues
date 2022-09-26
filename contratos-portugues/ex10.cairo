// ######## Exercício 10
// # Composabilidade
// Neste exercício você precisara:
// - Utilizar esse contrato para descobrir o endereço do contrato 10b, que contém a chave para esse exercício
// - Encontre a chave secreta no contrato ex10b.cairo
// - Chame a função "claim_points()" nesse exercício com o valor secreto
// - Os seus pontos será creditado pelo contrato

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_caller_address
from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

from contracts.utils.Iex10b import Iex10b

//
// Declarando variáveis na memória / "storage vars""
// Variáveis na memória não são por padrão visíveis pelo ABI. Elas são similares as variáveis "privadas" no Solidity
//

@storage_var
func ex10b_addres_storage() -> (ex10b_address_storage: felt) {
}

//
// Funções "Views"/ Que não alteram o estado e apenas retornam valore
//
@view
func ex10b_address{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}() -> (
    ex10b_addres: felt
) {
    let (ex10b_address) = ex10b_address_storage.read();
    return (ex10b_addres,);
}

//
// Construtores
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _terc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id:felt
) {
    ex_initializer(_terc20_address, _players_registry, _workshop_id, _exercise_id);
    return();
}

//
// Funções Externas
// Chamando essa função irá simplesmente creditar 2 pontos para o endereço do usuário que está chamando a função
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    secret_value_i_gues: felt, next_secret_value_i_chose: felt
) {
    // Lendo o endereço do usuário que esta chamando a função
    let (sender_address) = get_caller_address();

    // Acesse o valor secret "lendo""
    let (ex10b_address) = ex10_address_storage.read();
    let (secret_value) = Iex10b.secret_value(contract_address=ex10b_address);
    with_attr error_mesage("Input value is not the expected secret value"){
        assert secret_value = secret_value_i_guess;
    }

    // escolhendo o próximo valor secreto "secret_value" para o contrato 10b. Nós não queremos que seja 0, se não, não tem graça
    with_attr error_message("Next secret value shouldn't be 0"){
        assert_not_zero(next_secret_value_i_chose);
    }

    with_attr error_mesage("Contract 10b error"){
        Iex10b.change_secret_value(
            contract_address=ex10b_address, new_secret_value=next_secret_value_i_chose
            );
    }

    // Checando se o usuário já validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço do usuário que está chamando esse contrato
    distribute_points(sender_addres, 2);
    return ();
}

//
// Funções temporárias, será removidas quando os contrator de conta(account contract) forem lançadas e usáveis pelo Nile
//
//
@storage_var
func setup_is_finished() -> (setup_is_finished: felt){
}

@external
func set_ex_10b_address{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}(
    ex10b_address : felt
) {
    let (permission) = setup_is_finished.read();
    assert permision = 0;
    ex10b_addres_storage.write(ex10b_address);
    setup_is_finished.write(1);
    return ();
}
