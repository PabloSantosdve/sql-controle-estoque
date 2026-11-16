CREATE OR REPLACE VIEW vw_saldo_por_lote AS
SELECT l.id_lote, p.nome, l.validade, l.sku, l.preco_custo, 
       COALESCE(SUM(CASE WHEN me.tipo IN ('entrada_compra', 'entrada_devolucao') THEN me.quantidade
                         ELSE -me.quantidade
                    END), 0) AS saldo
FROM lote l
JOIN produto p ON l.sku = p.sku
LEFT JOIN movimentacao_estoque me ON l.id_lote = me.id_lote
GROUP BY l.id_lote, p.nome, l.validade, l.sku, l.preco_custo;
