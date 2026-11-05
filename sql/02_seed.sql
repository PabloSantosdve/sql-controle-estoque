
-- Controle de Estoque - dados de exemplo (distribuidora de alimentos)
-- Todos os dados são fictícios.
-- Executar DEPOIS do 01_schema.sql.


-- Tabelas independentes
INSERT INTO usuario (nome) VALUES
('Carlos Mendes'),
('Fernanda Oliveira'),
('Rafael Santos');

INSERT INTO localizacao (corredor, prateleira, posicao) VALUES
('A', 1, 'P1'),
('A', 2, 'P2'),
('B', 1, 'P1'),
('C', 3, 'P4');

INSERT INTO fornecedor (razao_social, cnpj, email, telefone, prazo_entrega_dias) VALUES
('Alimentos Bom Sabor LTDA',       '12345678000190', 'contato@bomsabor.com.br',        '(11) 3456-7890', 3),
('Distribuidora Campo Verde LTDA', '23456789000101', 'vendas@campoverde.com.br',       '(11) 2345-6789', 5),
('Laticínios Serra Azul LTDA',     '34567890000112', 'comercial@serraazul.com.br',     '(11) 4567-8901', 2);

INSERT INTO produto (sku, ean, nome, descricao, categoria, unidade_medida, estoque_minimo, estoque_maximo, preco_venda) VALUES
('PROD001', '7891000000001', 'Arroz Tipo 1 5kg',                  'Pacote de arroz branco tipo 1 com 5kg',                  'Grãos e Cereais',  'UN', 20,  200,  29.90),
('PROD002', '7891000000002', 'Feijão Carioca 1kg',                'Pacote de feijão carioca tipo 1 com 1kg',                'Grãos e Cereais',  'UN', 30,  300,   8.50),
('PROD003', '7891000000003', 'Óleo de Soja 900ml',                'Garrafa de óleo de soja refinado com 900ml',             'Óleos e Gorduras', 'UN', 25,  250,   7.99),
('PROD004', '7891000000004', 'Leite Integral 1L (caixa com 12)',  'Caixa com 12 unidades de leite integral UHT de 1 litro', 'Laticínios',       'CX', 10,  100,  65.88),
('PROD005', '7891000000005', 'Açúcar Refinado a granel',          'Açúcar refinado vendido a granel, por quilo',            'Açúcar e Doces',   'KG', 100, 1000,  4.20);

-- Tabela dependente (aponta para produto, fornecedor e localizacao)
INSERT INTO lote (sku, id_fornecedor, id_localizacao, validade, preco_custo) VALUES
('PROD001', 2, 1, '2027-06-30', 22.50),
('PROD002', 2, 2, '2027-03-15',  6.10),
('PROD003', 1, 3, '2026-11-12',  5.80),
('PROD004', 3, 4, '2026-12-10', 52.00),
('PROD004', 3, 4, '2027-02-20', 56.50),
('PROD005', 1, 1, '2027-08-31',  3.10);

-- Executar DEPOIS dos INSERT de usuario, lote e demais tabelas.
INSERT INTO movimentacao_estoque (id_lote, id_usuario, tipo, quantidade, data_hora, documento_origem) VALUES
-- Entradas iniciais e vendas de setembro
(1, 1, 'entrada_compra',     150, '2026-09-10 09:15:00', 'NF-3001'),
(2, 1, 'entrada_compra',     120, '2026-09-10 09:40:00', 'NF-3002'),
(1, 3, 'saida_venda',         40, '2026-09-18 11:00:00', 'PED-1001'),
(2, 3, 'saida_venda',         50, '2026-09-18 11:00:00', 'PED-1001'),
-- Outubro
(4, 2, 'entrada_compra',      60, '2026-10-01 08:30:00', 'NF-3008'),
(1, 3, 'saida_venda',         30, '2026-10-02 15:10:00', 'PED-1002'),
(2, 3, 'saida_venda',         40, '2026-10-02 15:10:00', 'PED-1002'),
(3, 2, 'entrada_compra',     100, '2026-10-05 10:05:00', 'NF-3010'),
(6, 1, 'entrada_compra',     800, '2026-10-10 14:20:00', 'NF-3012'),
(6, 3, 'saida_venda',        200, '2026-10-12 09:30:00', 'PED-1003'),
(4, 3, 'saida_venda',         20, '2026-10-15 16:00:00', 'PED-1004'),
(3, 3, 'saida_venda',         30, '2026-10-18 10:45:00', 'PED-1005'),
(5, 2, 'entrada_compra',      50, '2026-10-20 08:45:00', 'NF-3015'),
(1, 3, 'saida_venda',         20, '2026-10-22 13:25:00', 'PED-1006'),
(2, 3, 'saida_venda',         20, '2026-10-22 13:25:00', 'PED-1006'),
(6, 3, 'saida_venda',        150, '2026-10-25 09:50:00', 'PED-1007'),
(3, 3, 'saida_venda',         25, '2026-10-25 09:50:00', 'PED-1007'),
-- Venda de leite que atravessa dois lotes (regra FEFO)
(4, 3, 'saida_venda',         40, '2026-10-28 14:30:00', 'PED-1008'),
(5, 3, 'saida_venda',          5, '2026-10-28 14:30:00', 'PED-1008'),
-- Devolução e avaria
(1, 2, 'entrada_devolucao',    5, '2026-10-30 11:15:00', 'DEV-001'),
(5, 1, 'saida_avaria',         2, '2026-11-02 08:20:00', 'AVARIA-001');