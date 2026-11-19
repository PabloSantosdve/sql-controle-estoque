CREATE OR REPLACE VIEW vw_saldo_por_lote AS
SELECT l.id_lote, p.nome, l.validade, l.sku, l.preco_custo, 
       COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                         ELSE -me.quantidade
                    END), 0) AS saldo
FROM lote l
JOIN produto p ON l.sku = p.sku
LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
GROUP BY l.id_lote, p.nome, l.validade, l.sku, l.preco_custo;

-- View base para o Power BI: uma linha por movimentação, já com produto, categoria, fornecedor e usuário
CREATE OR REPLACE VIEW vw_movimentacao_detalhada AS
SELECT me.id_movimentacao,
       me.data_hora,
       me.tipo,
       me.quantidade,
       CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
            ELSE -me.quantidade
       END AS quantidade_com_sinal,
       me.documento_origem,
       me.id_lote,
       l.sku,
       p.nome AS produto,
       p.categoria,
       f.razao_social AS fornecedor,
       u.nome AS usuario
FROM movimentacao_estoque me
JOIN lote l ON me.id_lote = l.id_lote
JOIN produto p ON l.sku = p.sku
JOIN fornecedor f ON l.id_fornecedor = f.id_fornecedor
JOIN usuario u ON me.id_usuario = u.id_usuario;

-- Valor do estoque de cada produto (saldo de cada lote × custo do lote, somado por produto)
CREATE OR REPLACE VIEW vw_valor_estoque_por_produto AS
SELECT sku,
       nome AS produto,
       SUM(saldo * preco_custo) AS valor_estoque
FROM vw_saldo_por_lote
GROUP BY sku, nome;