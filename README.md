# Projeto Lógico de Banco de Dados — E-commerce

Este repositório contém o mapeamento do modelo conceitual de e-commerce para o **modelo lógico relacional**, com os refinamentos EER pedidos no desafio, o script de criação do esquema, uma massa de dados para teste e consultas SQL cobrindo diferentes cláusulas.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `schema.sql` | DDL — criação de todas as tabelas, com PK, FK e constraints |
| `dados.sql` | Massa de dados de teste (INSERTs) |
| `consultas.sql` | Consultas SQL organizadas por cláusula, cada uma respondendo a uma pergunta de negócio |

## Refinamentos EER aplicados

**1. Cliente PF ou PJ (especialização disjunta e total)**
A tabela `cliente` guarda as colunas `cpf` e `cnpj`, ambas opcionais, com uma `CHECK constraint` garantindo que **exatamente uma** das duas esteja preenchida — nunca as duas, nunca nenhuma. Essa é a estratégia de mapeamento de generalização/especialização quando as subclasses têm poucos atributos próprios: em vez de criar tabelas separadas `cliente_pf` e `cliente_pj`, os atributos específicos ficam na própria tabela-base, com a constraint garantindo a exclusividade.

**2. Cliente pode ter mais de uma forma de pagamento**
Criada a tabela `forma_pagamento`, em relacionamento 1:N com `cliente` — um cliente pode cadastrar cartão de crédito, débito, boleto e/ou Pix. A tabela `pagamento` (a transação em si, ligada a um pedido) referencia qual forma cadastrada foi usada naquela compra.

**3. Entrega com status e código de rastreio**
Tabela `entrega`, em relacionamento 1:1 com `pedido` (FK `id_pedido` com `UNIQUE`), guardando `status` (preparando, em trânsito, entregue, extraviado) e `codigo_rastreio`.

## Outras decisões de mapeamento

- Os relacionamentos N:N do modelo conceitual (`Pedido`×`Produto` e `Produto`×`Fornecedor`) viraram tabelas associativas com **chave primária composta**: `item_pedido` (quantidade e preço unitário no momento da venda) e `produto_fornecedor` (quantidade em estoque por fornecedor).
- `Fornecedor` e `Vendedor` foram modelados como tabelas separadas (papéis diferentes no negócio), mas ambos guardam `cnpj` — permitindo identificar quando a mesma empresa atua nos dois papéis (ver consulta 8 em `consultas.sql`).
- Todas as FKs seguem a integridade referencial das tabelas-pai; nenhuma exclusão em cascata foi definida, para evitar perda acidental de histórico de pedidos.

## Como executar

```bash
mysql -u seu_usuario -p < schema.sql
mysql -u seu_usuario -p < dados.sql
mysql -u seu_usuario -p < consultas.sql
```

## Consultas incluídas

`consultas.sql` cobre, cada uma comentada com a pergunta que responde:
- Recuperação simples (`SELECT`)
- Filtros (`WHERE`)
- Atributos derivados (ex.: subtotal = quantidade × preço)
- Ordenação (`ORDER BY`)
- Filtros de grupo (`HAVING`)
- Junções entre tabelas (`JOIN`), incluindo perguntas de negócio como: quantos pedidos por cliente, se algum vendedor também é fornecedor, relação de produtos/fornecedores/estoques e relação de nomes de fornecedores e produtos.
