-- Tabela para o Cardápio de Cafés
CREATE TABLE Cardapio (
    id_cardapio INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- Tabela para as Comandas dos Clientes
CREATE TABLE Comanda (
    id_comanda INT PRIMARY KEY AUTO_INCREMENT,
    data DATE NOT NULL,
    numero_mesa INT,
    nome_cliente VARCHAR(255)
);

-- Tabela para relacionar os itens do cardápio a cada comanda
CREATE TABLE ItensComanda (
    id_comanda INT,
    id_cardapio INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_comanda, id_cardapio),
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_cardapio) REFERENCES Cardapio(id_cardapio)
);

-- Inserindo cafés no cardápio
INSERT INTO Cardapio (nome, descricao, preco_unitario) VALUES
('Espresso', 'Café puro e forte extraído sob alta pressão.', 5.00),
('Cappuccino', 'Espresso com leite vaporizado e uma cremosa espuma de leite.', 8.50),
('Latte', 'Uma dose de espresso com uma maior quantidade de leite vaporizado.', 9.00),
('Mocha', 'Uma deliciosa combinação de espresso, leite vaporizado e calda de chocolate.', 12.00),
('Macchiato', 'Espresso "manchado" com uma pequena quantidade de leite.', 6.50);

-- Inserindo algumas comandas
INSERT INTO Comanda (data, numero_mesa, nome_cliente) VALUES
('2025-10-01', 5, 'João Silva'),
('2025-10-01', 2, 'Maria Oliveira'),
('2025-10-02', 8, 'Carlos Pereira'),
('2025-10-02', 5, 'Ana Souza');

-- Inserindo os itens nas comandas
INSERT INTO ItensComanda (id_comanda, id_cardapio, quantidade) VALUES
-- Comanda 1 (João Silva) - Dois tipos de café
(1, 1, 2), -- 2 Espressos
(1, 2, 1), -- 1 Cappuccino

-- Comanda 2 (Maria Oliveira) - Apenas um tipo de café
(2, 3, 1), -- 1 Latte

-- Comanda 3 (Carlos Pereira) - Três tipos de café
(3, 5, 1), -- 1 Macchiato
(3, 4, 2), -- 2 Mochas
(3, 1, 1), -- 1 Espresso

-- Comanda 4 (Ana Souza) - Apenas um tipo de café
(4, 2, 2); -- 2 Cappuccinos

SELECT
    id_cardapio,
    nome,
    descricao,
    preco_unitario
FROM
    Cardapio
ORDER BY
    nome ASC;


SELECT
    c.id_comanda,
    c.data,
    c.numero_mesa,
    c.nome_cliente,
    card.nome AS nome_cafe,
    card.descricao,
    ic.quantidade,
    card.preco_unitario,
    (ic.quantidade * card.preco_unitario) AS preco_total_item
FROM
    Comanda c
JOIN
    ItensComanda ic ON c.id_comanda = ic.id_comanda
JOIN
    Cardapio card ON ic.id_cardapio = card.id_cardapio
ORDER BY
    c.data,
    c.id_comanda,
    nome_cafe;

SELECT
    c.id_comanda,
    c.data,
    c.numero_mesa,
    c.nome_cliente,
    SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda
FROM
    Comanda c
JOIN
    ItensComanda ic ON c.id_comanda = ic.id_comanda
JOIN
    Cardapio card ON ic.id_cardapio = card.id_cardapio
GROUP BY
    c.id_comanda
ORDER BY
    c.data;


SELECT
    c.id_comanda,
    c.data,
    c.numero_mesa,
    c.nome_cliente,
    SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda
FROM
    Comanda c
JOIN
    ItensComanda ic ON c.id_comanda = ic.id_comanda
JOIN
    Cardapio card ON ic.id_cardapio = card.id_cardapio
GROUP BY
    c.id_comanda
HAVING
    COUNT(ic.id_cardapio) > 1 -- Apenas comandas com mais de um tipo de café.
ORDER BY
    c.data;



SELECT
    c.data,
    SUM(ic.quantidade * card.preco_unitario) AS faturamento_total_dia
FROM
    Comanda c
JOIN
    ItensComanda ic ON c.id_comanda = ic.id_comanda
JOIN
    Cardapio card ON ic.id_cardapio = card.id_cardapio
GROUP BY
    c.data
ORDER BY
    c.data;


