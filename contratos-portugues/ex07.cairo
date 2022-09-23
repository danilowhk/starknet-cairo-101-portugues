// ######## Ex 07
// # Entendendo funções para comparar valores
// Neste esse exercício você precisara:
// - Usar a função "claim_points()" desse contrato
// - Seus pontos será creditado pelo contrato

// ######## Referências
// Documentação ainda está sendo escrita. Você pode encontrar respostas nesse arquivo
// https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/cairo/common/math.cairo

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_nn,
    assert_le,
    assert_lt,
    assert_in_range,
)

from contracts.utils.ex00_base import (
    terc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
    _terc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
) {
    ex_initializer(_terc20_address, _players_registry, _workshop_id, _exercise_id);
    return();
}

//
// Funções externas
// Chamando essa função irá simplesmente creditar 2 pontos para o endereço especificado no parametro
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}(
    value_a: felt, value_b: felt
){
    // Lendo o endereço do usuário que esta chamando a funçãp
    let (sender_address) = get_caller_address();
    // Checando que os valores passados são corretos
    with_attr error_message("value_a shouldn't be 0"){
        assert_not_zero(value_a);
    }

    with_attr error_message("value_b shouldn't be negative") {
        assert_nn(value_b);
    }

    with_attr error_message("value _a and value_b should be different"){
        assert_not_equal(value_a, value_b);
    }

    with_attr error_meesage("value_a should be <= 75"){
        assert_le(value_a, 75);
    }

    with_attr error_message("value_a should be between 40 and 69"){
        assert_in_range(value_a, 40, 70);
    }

    with_attr error_message("value_b should be < 1") {
        assert_lt(value_b,1);
    }
    // Checando se o usuário validou o exercício antes
    validate_exercise(sender_address);
    // Enviando pontos para os endereço especificado como parametro
    distribute_points(sender_address,2);
    return();
}

