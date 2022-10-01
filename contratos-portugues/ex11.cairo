// ######## Exercício 11
// # Importando funções
// Nesse exercício você precisara:
// - Ler esse contrato e entender como funções importadas/importar funções de outro contrato funciona
// - Encontre o contrato de qual é importado
// - Leia o código e entenda o que é esperado de você

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_caller_address

// Esse contrato importa funções de outro arquivo além do outro exercício, tome cuidado
from contracts.utils.ex11_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
    validate_answers,
    ex11_secret_value,
)

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
)   {
    ex_intitializer(_terc20_address, _players_registry, _workshop_id, _exercise_id);
    return ();
}

//
// Funções Externas
// Chamando esse função ira creditar 2 pontos para o endereço especificado nos parâmetros
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    secret_value_i_guess: felt, next_secret_value_i_chose: felt
) {
    alloc_locals;
    // Lendo o endereço do endereço que está chamando esse contrato e salvando em "local"/local para eveur referencias revocadas/revoked references
    let (local sender_address) = get_caller_address();
    // Checando se a reposta está correta
    validate_answers(sender_address, secret_value_i_guess, next_secret_value_i_chose);
    // Checando se o usuário validou o exercício antes
    validate_exercise(sender_address);
    // Enviando pontos para o endereço que está chamando esse contrato
    distribute_points(sender_address,2);
    return ();
}