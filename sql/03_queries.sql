-- ============================================================
-- 03_queries.sql - Consultas de negócio do controle de estoque
-- Executar DEPOIS do 01_schema.sql e do 02_seed.sql.
--
-- Cada consulta traz a pergunta de negócio que ela responde e uma
-- nota "Conceito" com a ideia de SQL que ela usa.
-- As consultas de validade usam a data de hoje (CURRENT_DATE),
-- então o resultado muda com o passar do tempo.
-- ============================================================

-- 1) Produtos com preço de venda acima de R$ 8,00, do mais caro ao mais barato
-- Conceito: WHERE filtra as linhas; ORDER BY ... DESC ordena do maior para o menor.
SELECT nome, preco_venda
FROM produto
WHERE preco_venda > 8
ORDER BY preco_venda DESC;

-- 2) Quantos produtos existem em cada categoria?
-- Conceito: GROUP BY junta as linhas com o mesmo valor (aqui, a mesma categoria)
-- e COUNT(*) conta quantas linhas há em cada grupo.
-- Regra: toda coluna do SELECT que não está dentro de uma função (COUNT, SUM...)
-- precisa estar no GROUP BY.
SELECT categoria, COUNT(*) AS quantidade
FROM produto
GROUP BY categoria;

-- 3) Quais categorias têm mais de 1 produto?
-- Conceito: HAVING filtra GRUPOS, depois de agrupar e contar.
-- O WHERE filtra linhas ANTES de agrupar, por isso não enxerga o COUNT(*).
SELECT categoria, COUNT(*) AS quantidade
FROM produto
GROUP BY categoria
HAVING COUNT(*) > 1;

-- 4) Para cada lote, qual o produto, o fornecedor e a validade, do que vence primeiro para o que vence por último?
-- Conceito: JOIN junta tabelas usando as chaves estrangeiras. O ON diz qual coluna
-- de uma tabela casa com qual coluna da outra. Os apelidos (l, p, f) encurtam os nomes.
-- O JOIN comum só devolve linhas que têm par nas duas tabelas.
SELECT p.nome, f.razao_social, l.validade
FROM lote l
JOIN produto p ON l.sku = p.sku
JOIN fornecedor f ON l.id_fornecedor = f.id_fornecedor
ORDER BY l.validade ASC;

-- 5) Quantas unidades foram vendidas em cada lote, do que mais vendeu para o que menos vendeu?
-- Conceito: SUM soma os valores de uma coluna. O WHERE filtra só as saídas por venda
-- antes da soma. O texto 'saida_venda' precisa ser idêntico ao gravado na tabela.
SELECT id_lote, SUM(quantidade) AS unidades_vendidas
FROM movimentacao_estoque
WHERE tipo = 'saida_venda'
GROUP BY id_lote
ORDER BY unidades_vendidas DESC;

-- 6) Qual o saldo atual de cada lote, ou seja, o total de entradas menos o total de saídas?
-- Conceito: CASE funciona como um "se... então..." dentro da consulta. Aqui ele devolve
-- a quantidade positiva nas entradas e negativa nas saídas, e o SUM soma tudo com o sinal.
-- O saldo é CALCULADO a partir do histórico, e não guardado numa coluna.
SELECT id_lote,
       SUM(CASE WHEN tipo IN ('entrada_compra', 'entrada_devolucao') THEN quantidade
                ELSE -quantidade
           END) AS saldo
FROM movimentacao_estoque
GROUP BY id_lote
ORDER BY id_lote;

-- 7) Quais lotes vencem nos próximos 30 dias e ainda têm saldo em estoque?
--    Mostre o id do lote, o nome do produto, a validade e o saldo, do que vence primeiro para o que vence por último
-- Conceito: WITH (CTE) dá um nome a uma consulta, que passa a ser usada como se fosse uma tabela
-- no SELECT seguinte. Serve para separar em duas etapas: 1) calcular o saldo; 2) filtrar.
-- O nome só existe durante este comando.
-- LEFT JOIN mantém TODAS as linhas da tabela da esquerda (lote), mesmo sem movimentação;
-- as colunas da direita vêm vazias (NULL) quando não há par.
-- COALESCE devolve o primeiro valor que não é NULL: aqui transforma "sem saldo" em 0.
-- CURRENT_DATE é a data de hoje; INTERVAL soma um período; BETWEEN inclui as duas pontas.
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

-- 8) Quais produtos estão com o saldo total abaixo do estoque mínimo, inclusive os que nunca tiveram movimentação?
--    Mostre o nome, o saldo total e o estoque mínimo.
-- Conceito: dois LEFT JOIN em cadeia (produto -> lote -> movimentação) mantêm até os
-- produtos que nunca receberam lote. Sem o COALESCE, o saldo desses produtos seria NULL,
-- e a comparação "NULL < estoque_minimo" nunca é verdadeira, então eles sumiriam do alerta.
-- O cálculo fica uma vez só na etapa 1 (WITH); o filtro na etapa 2 é uma comparação simples.
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

-- 9) Quantas movimentações cada usuário registrou, do que mais registrou para o que menos?
--    Mostre o nome do usuário e a quantidade.
-- Conceito: COUNT(*) conta linhas, e o LEFT JOIN cria uma linha mesmo para quem não registrou nada,
-- então ele seria contado como 1. COUNT(coluna) só conta as linhas em que a coluna tem valor,
-- e por isso usamos a chave primária da movimentação: quem não registrou nada fica com 0.
-- O segundo critério do ORDER BY (u.nome) desempata quando a quantidade é igual.
SELECT u.nome, COUNT(me.id_movimentacao) AS quantidade_movimentacoes
FROM usuario u
LEFT JOIN movimentacao_estoque me ON u.id_usuario = me.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY quantidade_movimentacoes DESC, u.nome;

-- 10) Quais lotes já venceram e ainda têm saldo maior que zero?
--     Mostre o id do lote, o nome do produto, a validade e o saldo, do vencido há mais tempo para o mais recente.
-- Conceito: mesma etapa 1 da consulta 7 (saldo por lote). Aqui o filtro compara a validade com
-- CURRENT_DATE: um lote vencido que já foi todo vendido não é problema, por isso saldo > 0.
-- Observação: um lote que vence HOJE só entra nesta lista a partir de amanhã.
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

-- 11) Qual o valor do estoque de cada produto (saldo de cada lote × preço de custo do lote)?
--     Mostre o nome do produto e o valor total, do maior para o menor.
-- Conceito: o preço de custo mora no LOTE, e o mesmo produto pode ter lotes com custos diferentes
-- (como o leite). Por isso a conta é feita lote a lote (saldo × custo) e só depois somada por produto.
-- A subconsulta dentro do JOIN calcula o saldo de cada lote e funciona como uma tabela temporária
-- chamada sl (saldo do lote).
WITH valor_estoque_por_produto AS (
    SELECT p.nome,
           SUM(sl.saldo * sl.preco_custo) AS valor_total_estoque
    FROM produto p
    JOIN (
        SELECT l.id_lote, l.sku, l.preco_custo,
               COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                                 ELSE -me.quantidade
                            END), 0) AS saldo
        FROM lote l
        LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
        GROUP BY l.id_lote, l.sku, l.preco_custo
    ) sl ON p.sku = sl.sku
    GROUP BY p.sku, p.nome
)
SELECT nome, valor_total_estoque
FROM valor_estoque_por_produto
ORDER BY valor_total_estoque DESC;

-- 12) Qual o faturamento de cada produto (unidades vendidas × preço de venda)?
--     Mostre o nome do produto e o faturamento total, do maior para o menor.
-- Conceito: aqui só importam as saídas por venda, então o WHERE já resolve o filtro, sem CASE.
-- Como há uma etapa só, não precisa de WITH. Ele vale a pena quando separa duas etapas.
-- Limitação: usa o preço de venda ATUAL do produto para todas as vendas, mesmo as antigas.
SELECT p.nome, SUM(me.quantidade * p.preco_venda) AS faturamento_total
FROM produto p
JOIN lote l ON p.sku = l.sku
JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
WHERE me.tipo = 'saida_venda'
GROUP BY p.sku, p.nome
ORDER BY faturamento_total DESC;