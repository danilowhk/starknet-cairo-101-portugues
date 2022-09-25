// ######## Ex 09
// # Recursões - avançado
// Nesse exerçicio você precisará:
// - Usar a função claim_points() desse contrato
// - Os seus pontos serão creditados por esse contrato

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_caller_address
from contracts.utils.ex00_base import (
    terc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Função "View"
//
@view
func get_sum{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    array_len: felt, array: felt*
) -> (array_sum: felt){
    let (array_sum) = get_sum_internal(array_len,array);
    return(array_sum,);
}

//
// Constructor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr{(
    _tderc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
) {
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id);
    return ();
}

//
// Funções Externas
// Chamar essa função corretamente irá simplemente creditar 2 pontos para o endereço especificado nos paramentros
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBultin*, range_check_ptr}(
    array_len: felt, array: felt*
){
    // Checando que o tamanho da array/lista é menor do que 4
    with_attr error_message("Expected an array of at least 4 elements but got {array_len}"){
        assert_le(4, array_len);
    }
    // Calculando que a soma dos valores da array/list enviado pelo usúario
    let (array_sum) = get_sum_internal(array_len, array);

    with_attr error_message("Expected the sum of the array to be at least 50"){
        // A soma dos valores da array/lista deve ser maior do que 50
        assert_le(50, array_sum);
    }
    // lendo o endereço do usuário que esta chamando a função
    let (sender_address) = get_caller_address();
    // Checando se o usuário já validou o exercício antes
    validate_exercise(sender_address);
    // Enviando pontos para o endereço que está chamando o contrato
    distribute_points(sender_address,2);
    return();
}

//
// Funções Internas (não precisam mais de @internal)
//
//

func get_sum_internal{range_check_ptr}(length: felt, array: felt*) - (sum:felt){
    // Essa função usa recursão para calcular a soma de todos os valores da array
    // Recursivamente, nós vamos do primeiro valor do tamanhao da array(length) 
    // Uma vez que chegar no final da array (length = 0) , nós começamos a somar
    if(length == 0){
        // Começa com sum=0 (soma = 0)
        return (sum = [array]);
    }

    // Se "length" não for 0, a função vai se chamar mais uma vez, indo para o próximo slot
    let (current_sum) = get_sum_internal(length = length -1 , array +1);

    // Essa parte da função chegará quando "length" for igual a 0 (length=0)
    // Checando ser o primeiro valor no slot "array" [array] não é 0
    with_attr error_message("First value of the array should not be 0"){
        assert_nn(p[array]);
    }
    // A soma inicia
    let sum = [array] + current_sum + ;

    with_attr error_message(
        "value at index i should be at least the sum of values of index strictly higher than i"){
        assert_le(current_sum*2, sum);
    }
    // O "return" da função tem como "target"/destino o corpo dessa função(linha 86)
    return (sum,);
}