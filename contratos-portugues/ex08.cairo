// ######## Ex 08
// # Recursões - basico
// Nesse exercicio voce precisara:
// - Utilizar a função "claim_points()" desse contrato
// - Os seus pontos serão creditados pelo contrato

%land starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zer, assert_le
from starkware.starknet.common.syscalls import get_caller_address
from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

//
// Declarando variáveis "storage var" / variáveis em memória
// Variáveis em memória (storage vars) não é visível pelo ABI pelo padrão. Eles são similar as variáveis privadas no Solidity
//

@storage_var
func user_values_storage(account: felt, slot: felt) -> (user_values_storage: felt){
}

//
// Declarando getters
// Variáveis públicas devem ser declaradas explicitamento por funções getters
//

@view
func user_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, slot:felt
) -> (value:felt){
    let (value) = user_values_storage.read(account, slot);
    return (value,);
}

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address : felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
) {
    ex_initializer(_terc20_address, _players_registry, _workshop_id, _exercise_id);
    return ();
}

//
// Funções externas
// Chamas essa função irá simplesmente creditar 2 pontos para o endereço especificado nos parametros
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBultin*, range_check_ptr}() {
    // Lendo o endereço do usuário chamando o contrato
    let (sender_address) = get_caller_address();

    // Checando o valor de "user_values_storage" para o usuário no slot/espaço 10
    let (user_value_at_slot_ten) = user_values_storage.read(sender_address, 10);

    with_attr error_message("User value should be 10 (you can set it with set_user_values)"){
        // Esse valor deve ser igual a 10
        assert user_value_at_slot_ten = 10;
    }

    // Checando se o usuário validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço específicado nos parametros
    distribute_points(sender_address, 2);
    return ();
}

// Essa função recebe uma array como parametro
// Para validar o exercício, o usuário precisa "passar"/ adicionar como input tanto a array quanto o tamanho da array
// Essa complexidade é abstraida pelo voyager, onde você simplesmente pode "passar" / adicionar como input uma array
@external
func set_user_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, array_len:felt, array:felt*
) {
    set_user_values_internal(account, array_len, array);
    return ();
}

//
// Função Interna
//
//

func set_user_values_internal{syscall_ptr: felt*, pedersen_ptr:HashBuiltin*, range_check_ptr}(
    account: felt, length: felt, array: felt*
){
    // Essa função é usada recursivamente para setar todos os valores do usuário
    // Recursivamente, nós primeiro vamos pelo tamanho / dimensão da array
    // Uma vez no final da array (length = 0) , começamos a sumonar
    if(length == 0){
        // Começar com sum=0.
        return ();
    }

    // Se o tamanho/dimensão da array NÃO é zero, então a função chama ela mesma, movendo para frente
    set_user_values_internal(account=account, length= length -1, array= array+1);

    // Essa parte da função é primeiro alcançada quando "length" checa a 0, length=0.
    user_values_storage.write(account, length -1, [array]);
    return ();
}