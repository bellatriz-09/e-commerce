USE ecommerce;

-- ============================================================
-- 1) Recuperação simples — SELECT
-- Pergunta: quais produtos existem e a que preço?
-- ============================================================
SELECT nome, preco
FROM produto;


-- ============================================================
-- 2) Filtro — WHERE
-- Pergunta: quais produtos custam mais de R$ 100?
-- ============================================================
SELECT nome, preco
FROM produto
WHERE preco > 100;


-- ============================================================
-- 3) Atributo derivado
-- Pergunta: qual o subtotal (quantidade x preço) de cada item vendido?
-- ============================================================
SELECT id_pedido,
       id_produto,
       quantidade,
       preco_unitario,
       (quantidade * preco_unitario) AS subtotal
FROM item_pedido;


-- ============================================================
-- 4) Ordenação — ORDER BY
-- Pergunta: quais os produtos mais caros, do mais caro ao mais barato?
-- ============================================================
SELECT nome, preco
FROM produto
ORDER BY preco DESC;


-- ============================================================
-- 5) Quantos pedidos foram feitos por cada cliente?
-- (GROUP BY simples, sem filtro de grupo)
-- ============================================================
SELECT c.nome AS cliente,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_pedidos DESC;


-- ============================================================
-- 6) Filtro de grupo — HAVING
-- Pergunta: quais clientes fizeram mais de um pedido?
-- ============================================================
SELECT c.nome AS cliente,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(p.id_pedido) > 1;


-- ============================================================
-- 7) Quais clientes têm mais de uma forma de pagamento cadastrada?
-- (refinamento: cliente pode ter várias formas de pagamento)
-- ============================================================
SELECT c.nome AS cliente,
       COUNT(fp.id_forma_pagamento) AS qtd_formas_pagamento
FROM cliente c
JOIN forma_pagamento fp ON fp.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(fp.id_forma_pagamento) > 1;


-- ============================================================
-- 8) Algum vendedor também é fornecedor?
-- (junção pelo CNPJ, que identifica a mesma empresa nos dois papéis)
-- ============================================================
SELECT v.nome AS vendedor,
       f.nome AS fornecedor,
       v.cnpj
FROM vendedor v
JOIN fornecedor f ON f.cnpj = v.cnpj;


-- ============================================================
-- 9) Relação de produtos, fornecedores e estoques
-- ============================================================
SELECT pr.nome AS produto,
       f.nome AS fornecedor,
       pf.quantidade_estoque
FROM produto pr
JOIN produto_fornecedor pf ON pf.id_produto = pr.id_produto
JOIN fornecedor f ON f.id_fornecedor = pf.id_fornecedor
ORDER BY pr.nome;


-- ============================================================
-- 10) Relação de nomes dos fornecedores e nomes dos produtos
-- ============================================================
SELECT f.nome AS fornecedor,
       pr.nome AS produto
FROM fornecedor f
JOIN produto_fornecedor pf ON pf.id_fornecedor = f.id_fornecedor
JOIN produto pr ON pr.id_produto = pf.id_produto
ORDER BY f.nome;


-- ============================================================
-- 11) Junção mais complexa
-- Pergunta: detalhe completo de cada pedido — cliente, produto,
-- subtotal, status do pagamento e status/rastreio da entrega.
-- ============================================================
SELECT p.id_pedido,
       c.nome AS cliente,
       pr.nome AS produto,
       ip.quantidade,
       (ip.quantidade * ip.preco_unitario) AS subtotal,
       pg.status AS status_pagamento,
       e.status AS status_entrega,
       e.codigo_rastreio
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN produto pr ON pr.id_produto = ip.id_produto
LEFT JOIN pagamento pg ON pg.id_pedido = p.id_pedido
LEFT JOIN entrega e ON e.id_pedido = p.id_pedido
ORDER BY p.id_pedido;


-- ============================================================
-- 12) Combinando JOIN + atributo derivado + HAVING + ORDER BY
-- Pergunta: quais pedidos somam mais de R$ 500, do maior para o menor?
-- ============================================================
SELECT p.id_pedido,
       c.nome AS cliente,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > 500
ORDER BY valor_total DESC;


-- ============================================================
-- 13) Quantos clientes são PF e quantos são PJ?
-- (evidencia o refinamento de especialização Cliente PF/PJ)
-- ============================================================
SELECT CASE WHEN cpf IS NOT NULL THEN 'PF' ELSE 'PJ' END AS tipo_cliente,
       COUNT(*) AS total
FROM cliente
GROUP BY tipo_cliente;
