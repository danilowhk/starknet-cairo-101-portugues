###### Ex 05
# Variáveis públicas e privadas
# Nesse exercício, você precisa:
# - Usar uma das funções para ser assignado uma variável privada
# - Usar uma função para copiar essa variável para uma variável públicas
# - Usar uma função para mostrar o valor correto da variável privada
# - Receber os pontos do contrato

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscall import get_caller_address

from contracts.utils.ex00_base import (
    tderc20_address,
    has_validated_exercise,
    distribute_points,
    validate_exercise,
    ex_initializer,
)

#
# Declarando variáveis para serem armazenadas na memória
# "Storage var" por padrão não são visíveis pelo ABI. Eles são similare as variáveis privadas no Solidity
#

# Você precisará ler as variáveis dos pontos/slots de memória. Mas nem todoas elas tem função getters.

@storage_var
func user_slots_storage(account: felt) -> (user_slots_storage :felt):
end

@storage_var
func user_values_public_storage(account: felt) -> (user_values_public_storage : felt):
end

@storage_var
func values_mapped_secret_storage(slot: felt) -> (values_mapped_secret_storage: felt):
end

@storage_var
func was_initialized() -> (was_initialized: felt):
end

@storage_var
func next_slot() -> (next_slot: felt):
end

#
# Declarando funções getters
# Variáveis públicas devem ser declaradas explicitament com uma função getter
#

@view
func user_slots{syscall_ptr: felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account: felt
) -> (user_slot : felt):
    let (user_slot) = user_slots_storage.read(account)
    return (user_slot)
end

@view
func user_values{syscall_ptr : felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (user_value: felt):
    let (value) = user_values_public_storage.read(account)
    return (value)
end

#
# Constructor
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _tderc20_address : felt _players_registry : felt, _workshop_id : felt, _exercise_id: felt
):
    ex_initializer(_tderc20_address, _players_registry, _workshop_id, _exercise_id)
    return()
end

#
# Funções externas
#

@external
func claim_points{syscall_ptr : felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    expected_value : felt
):

    # Lendo o endereço do usuário que está chamando a função
    let (sender_address) = get_caller_address()

    with_attr error_message("User slot not assigned, Call assign_user_slot"):
        # Checando se o usuário tem um variável designada
        let (user_slot) = user_slots_storage.read(sender_address)
        assert_not_zero(user_slot)
    end

    # Checando se o valor provido pelo usuário é um que nós esperamos
    # Pegadinha do malandro
    let (value) = values_mapped_secret_storage.read(user_slot)
    with_attr error_message("Input value is not the expected secret value"):
        assert value = expected_value + 23
    end

    # Checando se o usuário validour o exercício antes
    validate_exercise(sender_address)
    # Enviando os pontos para o endereço do usuário/especificado
    distribute_points(sender_address,2)
    return()
end

@external
func assign_user_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}():
    # Lendo o endereço do usuário
    let (sender_address) = get_caller_address()
    let (next_slot_temp) = next_slot.read()
    let (next_value) = values_mapped_secret_storage.read(next_slot_temp + 1)
    if next_value == 0:
        user_slots_storage.write(sender_address,1)
        next_slot.write(0)
    else:
        user_slots_storage.write(sender_address, next_slot_temp +1)
        next_slot.write(next_slot_temp +1)
    end
    return()
end

@external
func copy_secret_value_to_readable_mapping{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}():
    # Lendo o endereço do usuário que está chamando o contrato
    let(sender_address) = get_caller_address()

    with_attr error_message("User slot not assigned. Call assign_user_slot"):
        # Checando se o usuário tem um slot/valor designado
        let (user_slot) = user_slot_storage.read(sender_address)
        assert_not_zero(user_slot)
    end
    # Lendo o valor secreto 
    let (secret_value) = values_mapped_secret_storage.read(user_slot)

    # Copiando o valor do "não acessível" values_mapped_secret_storage para 
    user_values_public_storage.write(sender_address, secret_value - 23)
    return()
end

#
# Funções externas - Administrador
# Apenas administradores podem chamar essas funções. Você não precisa entender-las para finalizar o exercício
#

@external
func set_random_values{syscall_ptr: felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
    values_len : felt, values: felt*
):

    # Checar se um valor randomico já foi inicializado
    let (was_initialized_read) = was_initialized.read()
    with_attr error_message("random values already initialized"):
        assert was_initialized_read = 0
    end
    # Armazenando valores dos argumentos nesse ponto de memória
    set_a_random_value(values_len,values)

    # Marcar que o armazenamento já foi inicializado
    was_initialized.write(1)
    return()
end

func set_a_random_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    values_len: felt, values: felt*
):
    if values_len == 0:
        # Start with sum=0.
        return ()
    end

    set_a_random_value(values_len=values_len -1 , values=values +1)
    values_mapped_secret_storage.write(values_len -1, [values])

    return()
end

