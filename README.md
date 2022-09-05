# StarkNet Cairo 101

**Comece com o Cairo com este simples tutorial.
Complete os puzzles/exercícios, obtenha tokens e aprenda sobre os contratos inteligentes da StarkNet!**

## Introdução

### Isenção de responsabilidade

Não espere qualquer benefício desse tutorial a não ser aprender sobre algumas coisas interessentas e sobre a StarkNet, o primeiro rollup de validade para fins gerais no Ethereum Mainnnet.

A StarkNet ainda está em Alfa. Isto significa que o desenvolvimento está em andamento, e que a tinta não está seca em todos os cantos. A maior parte ainda ira melhorar, por enquanto, testamos e fazemos as coisas funcionarem com um pouco de fita adesiva aqui e ali!

### Como funciona





**Complete os exercícios e obtenha tokens!**
Este workshop é um conjunto de contratos inteligentes "deployed"/ "implantados" / "lançados" na StarkNet Alpha na testnet. Cada contrato inteligente é um exercício/puzzle/desafio - que esboça uma característica da linguagem dos contratos inteligentes em Cairo.

A conclusão do exercício irá creditá-lo com pontos sob a forma de uma [ficha ERC20] (contratos/token/TDERC20.cairo).





Este workshop centra-se na *leitura* do código em Cairo e dos contratos inteligentes da StarkNet para que possa compreender a sua sintaxe. Não precisa codar ou instalar nada na sua máquina para a seguir e completar os desafios.





Os primeiros dois exercícios do tutorial pode levar um tempinho, mas segurem-se! Uma vez lá(depois dos dois primeiros exercícios), as coisas fluirão mais facilmente. Voce esta aprendendo!


### Onde estou, o que é esse repositório?

Este workshop é o primeiro de uma série destinada a ensinar como construir e desenvolver na StarkNet. Veja o seguinte:

| Topic | GitHub repo |
| ------------------------------------------- | -------------------------------------------------------------------------------------- |
| Aprenda a ler o código do Cairo (está aqui) | [Cairo 101](https://github.com/starknet-edu/starknet-cairo-101) |
| Implantar e personalizar um ERC721 NFT | [StarkNet ERC721](https://github.com/starknet-edu/starknet-erc721) |
| Implantar e personalizar um token ERC20 | [StarkNet ERC20](https://github.com/starknet-edu/starknet-erc20) |
| Construir umm Dapp multi layer | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge)
| Debugue facilmente os seus contratos no Cairo | [StarkNet debug](https://github.com/starknet-edu/starknet-debug) |
| Desenvolva o seu próprio contrato de conta | [abstracção de conta na StarkNet](https://github.com/starknet-edu/starknet-accounts) | [abstracção de conta na StarkNet](https://github.com/starknet-edu/starknet-accounts)

### Fornecer feedback & obter ajuda

Uma vez que tenha terminado o seu trabalho neste tutorial, o seu feedback será muito apreciado!

**Por favor, preencha [este formulário](https://forms.reform.app/starkware/untitled-form-4/kaes2e) para nos dizer o que podemos fazer para o tornar melhor. (Atualmente esse formulário está em inglês)**





E se tiver dificuldade durante a sua jornada, nos avise! Este workshop destina-se a ser o mais acessível possível; queremos caso ele não cumpra o seu propósito.





Tem alguma pergunta? Junte-se ao nosso [servidor Discord](https://starknet.io/discord), registe-se, e junte-se ao canal #tutorials-support.

Está interessado em se inscrever a workshops online sobre como aprender e desenvolver na StarkNet? [Subscreva aqui](http://eepurl.com/hFnpQ5)


### Contribuição

Este projeto/workshop pode melhorar e irá evoluir à medida que a StarkNet amadurecer. As suas contribuições são bem-vindas! Aqui estão algumas coisas que pode fazer para ajudar:

- Crie uma versão com uma tradução para a sua língua nativa
- Corrija bugs se encontrar alguns
- Acrescente explicações nos comentários dos exercícios, se achar que necessita de mais explicações
- Adicione exercícios que mostram a sua característica favorita do Cairo

### Idiomas

Está disponível uma versão em mandarim 中文版本请查看这里[aqui](https://github.com/starknet-edu/starknet-cairo-101/tree/mandarin).


## Começando

### Criar uma carteira de contrato inteligente

**Para completar o tutorial precisa de recolher pontos.** Estes pontos serão propriedade de uma carteira de contrato inteligente que precisa de utilizar.

- A forma mais fácil de criar um é utilizar Argent X ([download da extensão do chrome](https://chrome.google.com/webstore/detail/argent-x-starknet-wallet/dlcobpjiigpikoobohmabehhmhfoodbb/) ou [verificar o repositório deles](https://github.com/argentlabs/argent-x)) ou Braavos ([download da extensão do chrome](https://chrome.google.com/webstore/detail/braavos-wallet/jnlgamecbpmbajjfhmmmlhejkemejdma)). Estas soluções de carteira são semelhantes ao o que o Metamask é para o Ethereum e permitem os usuarios iniciar transacções e interagir com aplicações e aplicativos na StarkNet.
- Siga as instruções para instalar a extensão e implantar uma conta de contrato inteligente (pode demorar cerca de 5 minutos a ser implantada). Note que na StarkNet existe apenas um tipo de contas - contas de contrato inteligentes (isto chama-se Abstração de Conta), em contraste com o Ethereum, onde existem carteiras e contratos inteligentes. Em outras palavras, cada carteira na StarkNet é um contrato inteligente e não há distinção entre eles e outros contratos inteligentes. Portanto, para criar uma nova carteira, é necessário implementar uma transacção que publique a sua carteira de contrato inteligente na rede.
- Certifique-se de que está na rede testnet Goerli.
- Os pontos do tutorial são mantidos em ERC20 com o contrato `[0x5c6b1379f1d4c8a4f5db781a706b63a885f3f9570f7863629e99e2342ac344c](https://goerli.voyager.online/contract/0x5c6b1379f1d4c8a4f5db781a706b63a885f3f9570f7863629e99e2342ac344c)`. Clique em "Adicionar Token" na sua carteira instalada e adicione esse endereço como token para obter o seu saldo de pontos! Caso tenha adicionado com sucesso, um novo token chamado SC101 (starknet-cairo-101) irá aparecer na sua carteira.
- Ligue [Voyager](https://voyager.online/) ao seu contrato inteligente de conta. A Voyager é o explorador de blocos da StarkNet (o equivalente do Etherscan para Ethereum) e permite-lhe navegar pelo estado da blockchain, ver todas as transacções e o seu estado. Ao ligar a Voyager à sua carteira, poderá transmitir as suas transações através da sua carteira.
- Para executar transações na testnet da Goerli StarkNet ** você precisará da testnet ETH para pagar as "gas fees"**. Para obter os seus primeiros testnet ETH, vá à [faucet](https://faucet.goerli.starknet.io/) e siga as instruções. Pode demorar alguns minutos, mas deverá receber algum L2 Goerli ETH na sua carteirapara que possa executar transações na Goerli testnet.

### Resolver exercícios & Obter pontos

**Cada exercício é um contrato inteligente separado.** Contém um código que, quando executado correctamente, irá distribuir pontos para o seu endereço.

Os pontos são distribuídos pela função `distribute_points()` enquanto a função `validate_exercise' regista que completou o exercício (pode obter pontos apenas uma vez). O seu objectivo é o seguinte:

![Gráfico](assets/diagram.png)




### Usando o Voyager

Neste tutorial, vamos interagir com os nossos contratos através do [Voyager](https://goerli.voyager.online/), o explorador de blocos da StarkNet. Por favor, certifique-se de que conectou a Voyager a sua conta contrato! Isto permitira voce transmitir as suas transacções através da sua carteira.

Ao procurar um contrato/transacção, certifique-se sempre de que está na versão Goerli da Voyager!

- Acesse às suas transacções com um URL do formato: [https://goerli.voyager.online/tx/your-tx-hash](https://goerli.voyager.online/tx/your-tx-hash).
- Acesse a um contrato com um URL do formato: [https://goerli.voyager.online/contract/your-contract-address](https://goerli.voyager.online/contract/your-contract-address)
- Acesse às funções de leitura/escrita do contrato com o separador "ler/escrever contrato" no Voyager.




## Endereços dos exercícios e contratos

| Tópico | Código do contrato | Contrato na Voyager |
| ------------------------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Contador de pontos ERC20 | [Contador de pontos ERC20](contracts/token/TDERC20.cairo) | [Link](https://goerli.voyager.online/contract/0x5c6b1379f1d4c8a4f5db781a706b63a885f3f9570f7863629e99e2342ac344c) |
| Sintáxe Geral | [Ex01](contracts/ex01.cairo) | [Link](https://goerli.voyager.online/contract/0x29e2801df18d7333da856467c79aa3eb305724db57f386e3456f85d66cbd58b) |
| Variáveis de armazenamento, getters, afirmações | [Ex02](contracts/ex02.cairo) | [Link](https://goerli.voyager.online/contract/0x18ef3fa8b5938a0059fa35ee6a04e314281a3e64724fe094c80e3720931f83f) |
| Ler e salvar variáveis no armazenamento | [Ex03](contracts/ex03.cairo) | [Link](https://goerli.voyager.online/contract/0x79275e734d50d7122ef37bb939220a44d0b1ad5d8e92be9cdb043d85ec85e24) |
| Mappings | [Ex04](contracts/ex04.cairo) | [Link](https://goerli.voyager.online/contract/0x2cca27cae57e70721d0869327cee5cb58098af4c74c7d046ce69485cd061df1) | [Link
| Visibilidade de Variáveis | [Ex05](contracts/ex05.cairo) | [Link](https://goerli.voyager.online/contract/0x399a3fdd57cad7ed2193bdbb00d84553cd449abbdfb62ccd4119eae96f827ad) |
|Visibilidade de funções| [Ex06](contracts/ex06.cairo) | [Link](https://goerli.voyager.online/contract/0x718ece7af4fb1d9c82f78b7a356910d8c2a8d47d4ac357db27e2c34c2424582)   |
| Comparando Valores | [Ex07](contracts/ex07.cairo) | [Link](https://goerli.voyager.online/contract/0x3a1ad1cde69c9e7b87d70d2ea910522640063ccfb4875c3e33665f6f41d354a)  |
| Recursões nível 1 (Recursions) | [Ex08](contracts/ex08.cairo) | [Link](https://goerli.voyager.online/contract/0x15fa754c386aed6f0472674559b75358cde49db8b2aba8da31697c62001146c) | [Link
| Recursões nível 2 (Recursions)| [Ex09](contracts/ex09.cairo) | [Link](https://goerli.voyager.online/contract/0x2b9fcc1cfcb1ddf4663c8e7ac48fc87f84c91a8c2b99414c646900bf7ef5549)  |
| Composabilidade (Composability) | [Ex10](contracts/ex10.cairo) | [Link](https://goerli.voyager.online/contract/0x8415762f4b0b0f44e42ac1d103ac93c3ea94450a15bb65b99bbcc816a9388) |
| Importando funções | [Ex11](contracts/ex11.cairo) | [Link](https://goerli.voyager.online/contract/0xab5577b9be8948d89dbdba63370a3de92e72a23c4cacaea38b3a74eec3a872) |
| Eventos | [Ex12](contracts/ex12.cairo) | [Link](https://goerli.voyager.online/contract/0x24d15e02ddaa19d7ecd77204d35ed9bfff00a0cabc62eb3da5ba7680e44baf9) |
| Privacidade na StarkNet | [Ex13](contracts/ex13.cairo) | [Link](https://goerli.voyager.online/contract/0x2bae9190076c4252289b8a8671277cef57318192cff20c736808b0c71095895) |
| Multicall | [Ex14](contracts/ex14.cairo) | [Link](https://goerli.voyager.online/contract/0xed7ddffe1370fbbc1974ab8122d1d9bd7e3da8d829ead9177ea4249b4caef1) | [Link

### Contando os seus pontos


Os seus pontos serão creditados na sua carteira instalada; embora isto possa levar algum tempo. Se quiser monitorar a sua contagem de pontos em tempo real, também pode ver o seu saldo no voyager!


- Ir ao [contador ERC20](https://goerli.voyager.online/contract/0x5c6b1379f1d4c8a4f5db781a706b63a885f3f9570f7863629e99e2342ac344c#readContract) na Voyager, no separador "ler contrato".
- Introduza o seu endereço na função "balanceOf".

Pode também verificar o seu progresso geral [aqui](https://starknet-tutorials.vercel.app).


### Estado da transacção


Enviou uma transação, e esta é mostrada como "não detectada" na Voyager? Isto pode significar duas coisas:


- A sua transacção está pendente e será incluída num bloco em breve. Será então visível no Voyager.
- A sua transacção foi inválida e NÃO será incluída num bloco (não existe tal coisa como uma transacção falhada na StarkNet).

Pode (e deve) verificar o estado da sua transacção com o seguinte URL [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=), onde pode anexar o hash da sua transacção.



## Reutilização deste projecto

- Clone o repo na sua máquina.
- Prepare o ambiente seguindo [estas instruções](https://starknet.io/docs/quickstart.html#quickstart).
- Instale [Nilo](https://github.com/OpenZeppelin/nile).
- Teste compilar o projeto.

```bash
nile compile
```
