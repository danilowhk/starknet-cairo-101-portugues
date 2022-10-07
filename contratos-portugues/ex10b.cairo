// ######## Exercicio 10b
// # Composabilidate
// Esse exercício foi criado como um complemento do ex10, mas você não sabe aonde!
// Use o ex10 para encontrar o endereço desse conrtato e o voyager para ler do ex10b.
// Entao use o ex10 para recever os pontos

% lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from contracts.utils.Iex10 import Iex10

//
// Declarando variáveis em memória
// Variáveis em memória não são visieis por padrão pelo ABI. Elas são similares às variáveis privadadas no Solidity
//

@storage_var
func ex10_address_storage() -> (ex10_address_storage : felt) {
}

@storage_var
func secret_vale_storage() -> (secret_value_storage: felt) {
}

//
// Função View
//
@view
func ex10_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    ex10_address: felt
) {
    let (ex10_address) = ex10_address_storage.read();
    return (ex10_address,);
}

@view
func secret_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}()-> {
    secret_value: felt
}{
    let (secret_value) = secret_value_storage.read();
    return (secret_value,);
) 

//
// Construtor
//
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ex10_address: felt
) {
    ex10_address_storage.write(ex10_address);
    let (current_contract_address) = get_contract_address();
    Iex10.set_ex_10b_address(
        contract_address=ex10_address, ex_10b_address_=current_contract_address
    );
    return ();
}

//
// Funções Externas
// Chamando essa função ira simplesmente creditar 2 pontos ao endereço do usuário que esta chamando essa função
//

@external
func change_secret_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_secret_value : felt
) {
    // Apenas o ex10 pode chamar essa função
    only_ex10();
    // Alterando o valor secreto
    secret_value_storage.write(new_secret_value);
    return ();
}

//
// Função interna
//
//
func only_ex10{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    let (ex10_address) = ex10_address_storage.read();
    with_attr error_message("Only ex10 contract can call this function") {
        assert ex10_address = caller;
    }
    return ();
}
