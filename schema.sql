-- ============================================================
-- Esquema Lógico — E-commerce
-- Mapeamento do modelo conceitual, com refinamentos EER:
--   - Cliente PF/PJ (especialização disjunta, via CHECK)
--   - Cliente pode cadastrar mais de uma forma de pagamento
--   - Entrega com status e código de rastreio
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Cliente: especialização PF/PJ mapeada na própria tabela.
-- CHECK garante que nunca existam cpf e cnpj preenchidos ao mesmo tempo,
-- nem os dois vazios (todo cliente é PF ou PJ).
CREATE TABLE cliente (
    id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    cpf             VARCHAR(11) UNIQUE,
    cnpj            VARCHAR(14) UNIQUE,
    CONSTRAINT chk_cliente_pf_pj CHECK (
        (cpf IS NOT NULL AND cnpj IS NULL) OR
        (cpf IS NULL AND cnpj IS NOT NULL)
    )
);

CREATE TABLE endereco (
    id_endereco     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    logradouro      VARCHAR(150) NOT NULL,
    cidade          VARCHAR(80) NOT NULL,
    estado          CHAR(2) NOT NULL,
    cep             VARCHAR(9) NOT NULL,
    tipo            ENUM('entrega','cobranca') NOT NULL DEFAULT 'entrega',
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE categoria (
    id_categoria    INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE fornecedor (
    id_fornecedor   INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    cnpj            VARCHAR(14) NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    email           VARCHAR(150)
);

CREATE TABLE vendedor (
    id_vendedor     INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    cnpj            VARCHAR(14) NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    email           VARCHAR(150)
);

CREATE TABLE produto (
    id_produto      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    descricao       VARCHAR(300),
    preco           DECIMAL(10,2) NOT NULL,
    id_categoria    INT NOT NULL,
    id_vendedor     INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor)
);

-- Associação N:N entre produto e fornecedor; guarda o estoque por fornecedor.
CREATE TABLE produto_fornecedor (
    id_produto          INT NOT NULL,
    id_fornecedor       INT NOT NULL,
    quantidade_estoque  INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto, id_fornecedor),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE pedido (
    id_pedido       INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    id_endereco     INT NOT NULL,
    data_pedido     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('aberto','pago','enviado','entregue','cancelado') NOT NULL DEFAULT 'aberto',
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

-- Associação N:N entre pedido e produto, com os dados próprios da venda.
CREATE TABLE item_pedido (
    id_pedido       INT NOT NULL,
    id_produto      INT NOT NULL,
    quantidade      INT NOT NULL,
    preco_unitario  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- Refinamento: cliente pode cadastrar mais de uma forma de pagamento (1:N).
CREATE TABLE forma_pagamento (
    id_forma_pagamento  INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente          INT NOT NULL,
    tipo                ENUM('cartao_credito','cartao_debito','boleto','pix') NOT NULL,
    detalhes            VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Pagamento é a transação de um pedido específico, usando uma das formas cadastradas.
CREATE TABLE pagamento (
    id_pagamento        INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido           INT NOT NULL UNIQUE,
    id_forma_pagamento  INT NOT NULL,
    valor               DECIMAL(10,2) NOT NULL,
    data_pagamento      DATETIME,
    status              ENUM('pendente','aprovado','recusado') NOT NULL DEFAULT 'pendente',
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id_forma_pagamento)
);

-- Refinamento: entrega com status e código de rastreio.
CREATE TABLE entrega (
    id_entrega              INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido               INT NOT NULL UNIQUE,
    status                  ENUM('preparando','em_transito','entregue','extraviado') NOT NULL DEFAULT 'preparando',
    codigo_rastreio         VARCHAR(30),
    data_envio              DATETIME,
    data_entrega_prevista   DATE,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);
