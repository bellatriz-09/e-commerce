USE ecommerce;

INSERT INTO cliente (nome, email, telefone, cpf, cnpj) VALUES
('Ana Souza',              'ana.souza@email.com',     '93991112222', '12345678901', NULL),
('Carlos Lima',            'carlos.lima@email.com',   '93991113333', '23456789012', NULL),
('Comércio Silva Ltda',    'contato@silvacomercio.com','9332214455', NULL, '11222333000144'),
('Beatriz Prado',          'bia.prado@email.com',     '93991114444', '34567890123', NULL),
('Distribuidora Norte ME', 'vendas@distnorte.com',    '9333322211', NULL, '22333444000155');

INSERT INTO endereco (id_cliente, logradouro, cidade, estado, cep, tipo) VALUES
(1, 'Rua das Mangueiras, 120', 'Santarém', 'PA', '68000-000', 'entrega'),
(2, 'Av. Tapajós, 500',        'Santarém', 'PA', '68010-000', 'entrega'),
(3, 'Rua Comércio, 45',        'Belém',    'PA', '66000-000', 'cobranca'),
(4, 'Travessa das Flores, 78', 'Santarém', 'PA', '68005-000', 'entrega'),
(5, 'Av. Industrial, 900',     'Belém',    'PA', '66020-000', 'entrega');

INSERT INTO categoria (nome) VALUES
('Eletrônicos'), ('Informática'), ('Casa e Cozinha'), ('Livros');

INSERT INTO fornecedor (nome, cnpj, telefone, email) VALUES
('Distribuidora Norte ME',  '22333444000155', '9333322211', 'vendas@distnorte.com'),
('TechParts Distribuidora', '33444555000166', '9133345566', 'contato@techparts.com'),
('Casa & Cia Atacado',      '44555666000177', '9155667788', 'atacado@casaecia.com');

INSERT INTO vendedor (nome, cnpj, telefone, email) VALUES
('Distribuidora Norte ME',   '22333444000155', '9333322211', 'vendas@distnorte.com'),
('Loja Digital Amazônia',    '55666777000188', '9144556677', 'contato@digitalamazonia.com');

INSERT INTO produto (nome, descricao, preco, id_categoria, id_vendedor) VALUES
('Smartphone X200',              'Smartphone 128GB, 6GB RAM',     1499.90, 1, 2),
('Notebook Prime 15',            'Notebook i5, 8GB RAM, SSD 256GB',3299.00, 2, 2),
('Fone Bluetooth Bass',          'Fone de ouvido sem fio',          149.90, 1, 1),
('Panela de Pressão 5L',         'Panela de pressão em alumínio',   189.90, 3, 1),
('Livro: Banco de Dados na Prática','Livro técnico sobre modelagem', 89.90, 4, 2);

INSERT INTO produto_fornecedor (id_produto, id_fornecedor, quantidade_estoque) VALUES
(1, 2, 40),
(2, 2, 15),
(3, 1, 100),
(3, 3, 30),
(4, 3, 60),
(5, 2, 25);

INSERT INTO pedido (id_cliente, id_endereco, data_pedido, status) VALUES
(1, 1, '2026-08-01 10:15:00', 'entregue'),
(1, 1, '2026-09-10 14:00:00', 'enviado'),
(2, 2, '2026-08-20 09:30:00', 'entregue'),
(3, 3, '2026-09-05 16:45:00', 'pago'),
(4, 4, '2026-09-15 11:00:00', 'aberto');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1499.90),
(1, 3, 2, 149.90),
(2, 4, 1, 189.90),
(3, 2, 1, 3299.00),
(4, 3, 1, 149.90),
(4, 5, 3, 89.90),
(5, 1, 1, 1499.90);

INSERT INTO forma_pagamento (id_cliente, tipo, detalhes) VALUES
(1, 'cartao_credito', 'Cartão final 4321'),
(1, 'pix',            'chave: ana.souza@email.com'),
(2, 'boleto',          NULL),
(3, 'cartao_credito',  'Cartão final 9988'),
(4, 'pix',             'chave: 34567890123');

INSERT INTO pagamento (id_pedido, id_forma_pagamento, valor, data_pagamento, status) VALUES
(1, 1, 1799.70, '2026-08-01 10:20:00', 'aprovado'),
(2, 2,  189.90, '2026-09-10 14:05:00', 'aprovado'),
(3, 3, 3299.00, '2026-08-20 09:35:00', 'aprovado'),
(4, 4,  419.60, '2026-09-05 16:50:00', 'aprovado');

INSERT INTO entrega (id_pedido, status, codigo_rastreio, data_envio, data_entrega_prevista) VALUES
(1, 'entregue',    'BR123456789PA', '2026-08-02 08:00:00', '2026-08-05'),
(2, 'em_transito', 'BR987654321PA', '2026-09-11 09:00:00', '2026-09-16'),
(3, 'entregue',    'BR456789123PA', '2026-08-21 08:30:00', '2026-08-24');
