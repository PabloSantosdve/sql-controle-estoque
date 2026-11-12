-- Produtos com preço de venda acima de R$ 8,00, do mais caro ao mais barato
SELECT nome, preco_venda
FROM produto
WHERE preco_venda > 8
ORDER BY preco_venda DESC;

-- Quantos produtos existem em cada categoria, agrupando por categoria
SELECT categoria, COUNT(*) AS quantidade
FROM produto
GROUP BY categoria;

-- Quantos produtos existem em cada categoria, mas apenas categorias com mais de 1 produto
SELECT categoria, COUNT(*) AS quantidade
FROM produto
GROUP BY categoria
HAVING COUNT(*) > 1;

-- Para cada lote, mostre o nome do produto, a razão social do fornecedor e a validade, do lote que vence primeiro para o que vence por último
SELECT p.nome, f.razao_social, l.validade
FROM lote l
JOIN produto p ON l.sku = p.sku
JOIN fornecedor f ON l.id_fornecedor = f.id_fornecedor
ORDER BY l.validade ASC;

-- Quantas unidades foram vendidas (saida_venda) em cada lote, do que mais vendeu para o que menos vendeu
SELECT id_lote, SUM(quantidade) AS unidades_vendidas
FROM movimentacao_estoque
WHERE tipo = 'saida_venda'
GROUP BY id_lote
ORDER BY unidades_vendidas DESC;

-- Qual o saldo atual de cada lote, ou seja, o total de entradas menos o total de saídas?
SELECT id_lote, 
    SUM(CASE WHEN tipo = 'entrada_compra' OR tipo = 'entrada_devolucao' THEN quantidade 
    ELSE -quantidade 
    END) AS saldo
FROM movimentacao_estoque
GROUP BY id_lote;

-- Quais lotes vencem nos próximos 30 dias e ainda têm saldo em estoque? Mostre o id do lote, o nome do produto, a validade e o saldo, do que vence primeiro para o que vence por último
WITH saldo_por_lote AS (
    SELECT l.id_lote, p.nome, l.validade,
           COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                             ELSE -me.quantidade
                        END), 0) AS saldo
    FROM lote l
    JOIN produto p ON l.sku = p.sku
    LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
    GROUP BY l.id_lote, p.nome, l.validade
)
SELECT id_lote, nome, validade, saldo
FROM saldo_por_lote
WHERE validade BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
  AND saldo > 0
ORDER BY validade ASC;

-- Quais produtos estão com o saldo total abaixo do estoque mínimo, inclusive os que nunca tiveram movimentação? Mostre o nome, o saldo total e o estoque mínimo.
WITH saldo_por_produto AS (
    SELECT p.nome,
           COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                             ELSE -me.quantidade
                        END), 0) AS saldo_total,
           p.estoque_minimo
    FROM produto p
    LEFT JOIN lote l ON p.sku = l.sku
    LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
    GROUP BY p.sku, p.nome, p.estoque_minimo
)
SELECT nome, saldo_total, estoque_minimo
FROM saldo_por_produto
WHERE saldo_total < estoque_minimo;

-- Quantas movimentações cada usuário registrou, do que mais registrou para o que menos? Mostre o nome do usuário e a quantidade.
SELECT u.nome, COUNT(me.id_movimentacao) AS quantidade_movimentacoes
FROM usuario u
LEFT JOIN movimentacao_estoque me ON u.id_usuario = me.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY quantidade_movimentacoes DESC, u.nome;

-- Quais lotes já venceram e ainda têm saldo maior que zero? Mostre o id do lote, o nome do produto, a validade e o saldo, do vencido há mais tempo para o mais recente.
WITH saldo_por_lote AS (
    SELECT l.id_lote, p.nome, l.validade,
           COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                             ELSE -me.quantidade
                        END), 0) AS saldo
    FROM lote l
    JOIN produto p ON l.sku = p.sku
    LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
    GROUP BY l.id_lote, p.nome, l.validade
)
SELECT id_lote, nome, validade, saldo
FROM saldo_por_lote
WHERE validade < CURRENT_DATE AND saldo > 0
ORDER BY validade ASC;