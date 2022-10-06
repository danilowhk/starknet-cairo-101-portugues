// ######## Ex 14
// Um exercício todos em um / All in one
// Agora é sua vez de brilhar
// Crie e deploie/deploy um contrato que valide varios exercício em apenas uma transação ereceba os 2 pontos
// Voce quer agregar os seus pontos em apenas uma conta? Então use isso https://github.com/starknet-edu/points-migrator

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.uint256 import Uint256, uint256_sub, uint256_le, uint256_lt
from contracts.token.IERC20 import IERC20
from contracts.token.ex00_base import (
    tderc20_address,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

@contract_interface
namespace IAllInOneContract {
    func validate_various_exercises() {
    }
}

//
// Construtor
//
@constructor
func constructor{sycall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _tderc20_address: felt, _players_registry: felt, _workshop_id: felt, _exercise_id: felt
) {
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id);
    return ();
}

//
// Funções externas
//

@external
func claim_points{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){
    alloc_locals;
    // Lendo o endereço do usuário que esta chamando o contrato
    let (sender_address) = get_caller_address();
    // Lendo o endereço do contrato ERC20
    let (erc20_address) = tderc20_address();
    // Lendo o balanço do usuário antes de chamar o contrato
    let (balance_pre_call) = IERC20.balanceOf(
        constract_address= erc20_address, account=sender_address
    );

    // Chamando a função "validate_various_exercise()" do contrato que está chamando a função
    IAllInOneContract.validate_various_exercise(contract_addres=sender_address);

    // Lendo o balanço do contrato antes de chamar-lo
    let (balance_post_call) = IERC20.balanceOf(
        contract_address=erc20_address, account=sender_address
    );
    // Verificando que o usuário coletou alguns pontos
    let (has_caller_collected_points) = uint256_lt(balance_pre_call, balance_post_call);
    with_attr error_message("You did not collect any points"){
        assert has_caller_collected_points = 1;
    }
    // Ler quantos pontos foram coletados
    let collected_points: Uint256 = uint256_sub(balance_post_call, balance_pre_call);
    // Checando que pelo menos 20 pontos foram coletados
    let points_objective: Uint256 = Uint256(20,0);
    let (has_caller_collected_enough_points) = uint256_le(points_objective, collected_points);

    with_attr error_message("You did not collect enough points") {
        assert has_caller_collected_enough_points = 1;
    }

    // Checando se o usuário validou o exercício antes
    validate_exercise(sender_address);
    // Enviando os pontos para o endereço do usuário
    distribute_points(sender_address, 2);
    return ();
}