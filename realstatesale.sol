// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RealEstateSale {
    // Estado do contrato: disponível, vendido, cancelado
    enum State { Available, Sold, Cancelled }

    // Informações do apartamento
    struct Apartment {
        string description;
        uint256 price;
        address payable seller;
        State state;
    }

    Apartment public apartment;

    // Comprador do apartamento
    address public buyer;

    // Penalidade por cancelamento
    uint256 public cancellationPenaltyPercent = 5;

    // Prazo de validade do contrato
    uint256 public expirationTime;

    // Construtor para inicializar o apartamento
    constructor(string memory _description, uint256 _price, uint256 _duration) {
        apartment = Apartment({
            description: _description,
            price: _price,
            seller: payable(msg.sender),
            state: State.Available
        });
        expirationTime = block.timestamp + _duration; // Prazo em segundos
    }

    // Função para comprar o apartamento
    function buy() public payable {
        require(apartment.state == State.Available, "Apartamento nao disponivel para venda");
        require(msg.value == apartment.price, "Valor incorreto enviado");
        require(block.timestamp <= expirationTime, "O prazo de validade do contrato expirou");

        // Transferir o valor para o vendedor
        apartment.seller.transfer(apartment.price);

        // O comprador é registrado e o estado do apartamento é atualizado
        buyer = msg.sender;
        apartment.state = State.Sold;
    }

    // Função para cancelar a venda com penalidade
    function cancelSale() public {
        require(apartment.state == State.Available, "Venda nao pode ser cancelada");
        require(msg.sender == apartment.seller, "Somente o vendedor pode cancelar");

        // Penalidade por cancelamento
        uint256 penaltyAmount = (apartment.price * cancellationPenaltyPercent) / 100;
        payable(buyer).transfer(penaltyAmount); // Penalidade paga ao comprador

        apartment.state = State.Cancelled;
    }

    // Função para consultar o estado da venda
    function getApartmentState() public view returns (string memory) {
        if (apartment.state == State.Available) {
            if (block.timestamp > expirationTime) {
                return "Contrato expirado";
            }
            return "Apartamento disponivel para venda";
        } else if (apartment.state == State.Sold) {
            return "Apartamento vendido";
        } else if (apartment.state == State.Cancelled) {
            return "Venda cancelada";
        } else {
            return "Estado desconhecido";
        }
    }

    // Função para consultar o prazo de validade do contrato
    function timeUntilExpiration() public view returns (uint256) {
        if (block.timestamp >= expirationTime) {
            return 0;
        }
        return expirationTime - block.timestamp;
    }
} 