USE ecommerce;

SELECT nome, preco
FROM produto;

SELECT nome, preco
FROM produto
WHERE preco > 100;

SELECT id_pedido,
       id_produto,
       quantidade,
       preco_unitario,
       (quantidade * preco_unitario) AS subtotal
FROM item_pedido;

SELECT nome, preco
FROM produto
ORDER BY preco DESC;

SELECT c.nome AS cliente,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_pedidos DESC;

SELECT c.nome AS cliente,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(p.id_pedido) > 1;

SELECT c.nome AS cliente,
       COUNT(fp.id_forma_pagamento) AS qtd_formas_pagamento
FROM cliente c
JOIN forma_pagamento fp ON fp.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(fp.id_forma_pagamento) > 1;

SELECT v.nome AS vendedor,
       f.nome AS fornecedor,
       v.cnpj
FROM vendedor v
JOIN fornecedor f ON f.cnpj = v.cnpj;

SELECT pr.nome AS produto,
       f.nome AS fornecedor,
       pf.quantidade_estoque
FROM produto pr
JOIN produto_fornecedor pf ON pf.id_produto = pr.id_produto
JOIN fornecedor f ON f.id_fornecedor = pf.id_fornecedor
ORDER BY pr.nome;

SELECT f.nome AS fornecedor,
       pr.nome AS produto
FROM fornecedor f
JOIN produto_fornecedor pf ON pf.id_fornecedor = f.id_fornecedor
JOIN produto pr ON pr.id_produto = pf.id_produto
ORDER BY f.nome;

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

SELECT p.id_pedido,
       c.nome AS cliente,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > 500
ORDER BY valor_total DESC;

SELECT CASE WHEN cpf IS NOT NULL THEN 'PF' ELSE 'PJ' END AS tipo_cliente,
       COUNT(*) AS total
FROM cliente
GROUP BY tipo_cliente;
