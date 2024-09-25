# Contrato Inteligente de Venda de Imóveis

Este é um contrato inteligente em Solidity para gerenciar a venda de imóveis (apartamento) utilizando tecnologia blockchain. O contrato permite a autoexecução das vendas, tratando as interações entre comprador e vendedor, incluindo penalidades por cancelamento e expiração do contrato.

## Visão Geral

O contrato foi projetado para facilitar a venda de um apartamento, com os seguintes recursos:
- Autoexecução da venda quando o comprador envia o pagamento exato.
- Cancelamento iniciado pelo vendedor, com uma penalidade paga ao comprador.
- Um tempo de expiração após o qual o contrato se torna inválido.
- Registro do comprador após a compra bem-sucedida.

## Detalhes do Contrato

### 1. **Enumeração de Estado**
O contrato usa um `enum State` para representar os possíveis status do apartamento:
- `Available`: O apartamento está disponível para venda.
- `Sold`: O apartamento foi vendido.
- `Cancelled`: A venda foi cancelada.

### 2. **Estrutura do Apartamento**
A struct `Apartment` contém os seguintes detalhes:
- `description`: Uma descrição curta do apartamento.
- `price`: O preço do apartamento em wei (menor unidade de Ether).
- `seller`: O endereço do vendedor (a pessoa que implantou o contrato).
- `state`: O estado atual do apartamento (Disponível, Vendido, Cancelado).

### 3. **Comprador**
O contrato registra o endereço do comprador assim que o apartamento é comprado com sucesso.

### 4. **Penalidade por Cancelamento**
Se o vendedor cancelar a venda antes de ser concluída, ele deve pagar uma penalidade de 5% ao comprador.

### 5. **Tempo de Expiração**
O contrato tem um limite de tempo. Se o apartamento não for comprado dentro da duração definida, o contrato expirará e o apartamento não estará mais disponível para venda.

## Funções

### 1. `buy()`: Comprar o Apartamento
- Permite que um comprador adquira o apartamento enviando o preço exato.
- O pagamento é automaticamente transferido para o vendedor, e o estado do apartamento é atualizado para `Sold` (Vendido).
- Exige que a venda ainda esteja disponível e que o contrato não tenha expirado.

### 2. `cancelSale()`: Cancelar a Venda
- O vendedor pode cancelar a venda antes de ser concluída.
- O comprador (se houver) recebe de volta um valor de penalidade equivalente a 5% do preço do apartamento.
- O estado do apartamento é atualizado para `Cancelled` (Cancelado).

### 3. `getApartmentState()`: Verificar o Estado da Venda
- Retorna uma string indicando o estado atual do apartamento:
  - "Available" se o apartamento estiver à venda.
  - "Sold" se o apartamento foi comprado.
  - "Cancelled" se a venda foi cancelada.
  - "Expired" se o contrato ultrapassou o tempo de expiração.

### 4. `timeUntilExpiration()`: Verificar o Tempo Restante
- Retorna o tempo restante (em segundos) até que o contrato expire.
- Retorna `0` se o contrato já tiver expirado.

## Uso

1. Implemente o contrato em uma blockchain compatível com Ethereum.
2. Após a implementação, o vendedor pode inicializar o apartamento com uma descrição, preço e duração (limite de tempo para o contrato).
3. O comprador pode chamar a função `buy()` para comprar o apartamento, enviando a quantidade exata de Ether especificada.
4. O vendedor pode cancelar a venda usando a função `cancelSale()`, com uma penalidade paga ao comprador.
5. O estado do apartamento e o tempo restante podem ser verificados usando as funções `getApartmentState()` e `timeUntilExpiration()`.

## Licença

Este projeto é licenciado sob a Licença MIT.