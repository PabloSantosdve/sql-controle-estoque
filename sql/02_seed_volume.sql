-- Dados de exemplo em volume (para o painel de BI)
-- Executar DEPOIS do 01_schema.sql e do 02_seed.sql, num banco recém-criado
-- Acrescenta: 3 usuários, 8 localizações, 4 fornecedores, 15 produtos,
-- 30 lotes e 191 movimentações (212 no total, com as do seed base)

-- Usuários (IDs 4 a 6)
INSERT INTO usuario (nome) VALUES
('Juliana Costa'),
('Marcos Lima'),
('Patrícia Souza');

-- Localizações (IDs 5 a 12)
INSERT INTO localizacao (corredor, prateleira, posicao) VALUES
('C', 1, 'P1'),
('C', 2, 'P2'),
('D', 1, 'P1'),
('D', 2, 'P3'),
('D', 3, 'P4'),
('E', 1, 'P1'),
('E', 2, 'P2'),
('E', 3, 'P5');

-- Fornecedores (IDs 4 a 7)
INSERT INTO fornecedor (razao_social, cnpj, email, telefone, prazo_entrega_dias) VALUES
('Bebidas Vale Dourado LTDA',         '45678901000123', 'pedidos@valedourado.com.br',        '(11) 5678-9012', 4),
('Massas Nonna Rosa Indústria LTDA',  '56789012000134', 'vendas@nonnarosa.com.br',           '(19) 3210-4567', 6),
('Conservas Mar e Terra LTDA',        '67890123000145', 'comercial@mareterra.com.br',        '(13) 2109-8765', 7),
('Café Montanha Alta LTDA',           '78901234000156', 'atendimento@montanhaalta.com.br',   '(35) 3456-1234', 3);

-- Produtos (PROD006 a PROD020)
INSERT INTO produto (sku, ean, nome, descricao, categoria, unidade_medida, estoque_minimo, estoque_maximo, preco_venda) VALUES
('PROD006', '7891000000006', 'Macarrão Espaguete 500g',               'Pacote de macarrão espaguete com 500g',                        'Massas',             'UN', 200, 500,  5.90),
('PROD007', '7891000000007', 'Macarrão Parafuso 500g',                'Pacote de macarrão parafuso com 500g',                         'Massas',             'UN',  60, 400,  5.70),
('PROD008', '7891000000008', 'Molho de Tomate 340g',                  'Sachê de molho de tomate tradicional com 340g',                'Molhos e Conservas', 'UN',  60, 500,  3.49),
('PROD009', '7891000000009', 'Milho em Conserva 200g',                'Lata de milho verde em conserva com 200g',                     'Molhos e Conservas', 'UN',  60, 500,  4.29),
('PROD010', '7891000000010', 'Sardinha em Óleo 125g',                 'Lata de sardinha em óleo comestível com 125g',                 'Molhos e Conservas', 'UN',  50, 400,  6.99),
('PROD011', '7891000000011', 'Café Torrado e Moído 500g',             'Pacote de café torrado e moído com 500g',                      'Café e Chás',        'UN', 200, 400, 18.90),
('PROD012', '7891000000012', 'Refrigerante Cola 2L (fardo com 6)',    'Fardo com 6 garrafas de refrigerante sabor cola de 2 litros',  'Bebidas',            'CX',  30, 250, 38.40),
('PROD013', '7891000000013', 'Suco de Uva Integral 1L',               'Garrafa de suco de uva integral com 1 litro',                  'Bebidas',            'UN',  40, 300, 11.90),
('PROD014', '7891000000014', 'Água Mineral 500ml (fardo com 12)',     'Fardo com 12 garrafas de água mineral sem gás de 500ml',       'Bebidas',            'CX',  40, 300, 14.40),
('PROD015', '7891000000015', 'Biscoito Cream Cracker 400g',           'Pacote de biscoito cream cracker com 400g',                    'Biscoitos',          'UN', 120, 400,  5.20),
('PROD016', '7891000000016', 'Biscoito Recheado 130g',                'Pacote de biscoito recheado sabor chocolate com 130g',         'Biscoitos',          'UN',  60, 600,  2.99),
('PROD017', '7891000000017', 'Farinha de Trigo 1kg',                  'Pacote de farinha de trigo tipo 1 com 1kg',                    'Grãos e Cereais',    'UN',  60, 400,  5.49),
('PROD018', '7891000000018', 'Sal Refinado 1kg',                      'Pacote de sal refinado iodado com 1kg',                        'Mercearia',          'UN',  50, 300,  2.49),
('PROD019', '7891000000019', 'Queijo Mussarela Fatiado',              'Queijo mussarela fatiado, vendido por quilo',                  'Laticínios',         'KG',  40, 300, 42.00),
('PROD020', '7891000000020', 'Iogurte Natural 170g (bandeja com 6)',  'Bandeja com 6 potes de iogurte natural de 170g',               'Laticínios',         'CX', 120, 300, 11.70);

-- Lotes (IDs 7 a 36): 2 por produto novo, na ordem dos produtos
-- (sku, id_fornecedor, id_localizacao, validade, preco_custo)
INSERT INTO lote (sku, id_fornecedor, id_localizacao, validade, preco_custo) VALUES
('PROD006', 5,  5, '2027-03-20',  4.10), ('PROD006', 5,  6, '2027-06-18',  4.30),
('PROD007', 5,  5, '2027-04-10',  3.95), ('PROD007', 5,  6, '2027-07-22',  4.15),
('PROD008', 6,  7, '2027-02-14',  2.40), ('PROD008', 6,  7, '2027-08-30',  2.55),
('PROD009', 6,  7, '2027-05-05',  2.95), ('PROD009', 6,  8, '2027-09-12',  3.10),
('PROD010', 6,  8, '2027-03-01',  4.80), ('PROD010', 6,  8, '2027-10-15',  5.05),
('PROD011', 7,  9, '2027-01-31', 13.20), ('PROD011', 7,  9, '2027-04-25', 13.90),
('PROD012', 4, 10, '2027-02-28', 27.50), ('PROD012', 4, 10, '2027-05-30', 28.70),
('PROD013', 4, 10, '2026-11-28',  8.10), ('PROD013', 4, 11, '2027-03-12',  8.40),
('PROD014', 4, 11, '2027-06-30',  9.60), ('PROD014', 4, 12, '2027-09-30', 10.10),
('PROD015', 2,  1, '2027-01-20',  3.50), ('PROD015', 2,  2, '2027-04-18',  3.70),
('PROD016', 2,  2, '2027-02-09',  1.95), ('PROD016', 2,  3, '2027-05-21',  2.10),
('PROD017', 2,  3, '2027-03-27',  3.80), ('PROD017', 2,  3, '2027-08-08',  3.95),
('PROD018', 2,  1, '2028-01-15',  1.55), ('PROD018', 2,  1, '2028-06-15',  1.65),
('PROD019', 3, 12, '2026-11-10', 31.00), ('PROD019', 3, 12, '2026-12-02', 33.50),
('PROD020', 3, 12, '2026-11-14',  8.20), ('PROD020', 3, 11, '2026-12-12',  8.60);

-- Movimentações dos lotes novos (id_lote > 6), geradas por fórmulas.
-- Quantidade comprada por lote: 100 + (id_lote % 5) * 50, ou seja, entre 100 e 300.

-- 1) Uma entrada por compra em cada lote novo (entre 17/08 e 15/09)
INSERT INTO movimentacao_estoque (id_lote, id_usuario, tipo, quantidade, data_hora, documento_origem)
SELECT l.id_lote,
       1 + (l.id_lote % 6),
       'entrada_compra',
       100 + (l.id_lote % 5) * 50,
       TIMESTAMP '2026-08-10 08:00:00' + (l.id_lote % 40) * INTERVAL '1 day',
       'NF-' || (4000 + l.id_lote)
FROM lote l
WHERE l.id_lote > 6;

-- 2) Cinco vendas por lote novo, uma a cada 10 dias depois da entrada
INSERT INTO movimentacao_estoque (id_lote, id_usuario, tipo, quantidade, data_hora, documento_origem)
SELECT l.id_lote,
       1 + ((l.id_lote + g.n) % 6),
       'saida_venda',
       FLOOR((100 + (l.id_lote % 5) * 50) * (0.08 + (l.id_lote % 4) * 0.03))::integer,
       TIMESTAMP '2026-08-10 14:30:00' + (l.id_lote % 40) * INTERVAL '1 day' + g.n * INTERVAL '10 days',
       'PED-' || (2000 + l.id_lote * 10 + g.n)
FROM lote l
CROSS JOIN generate_series(1, 5) AS g(n)
WHERE l.id_lote > 6;

-- 3) Uma avaria (2% da compra) nos lotes de id múltiplo de 7
INSERT INTO movimentacao_estoque (id_lote, id_usuario, tipo, quantidade, data_hora, documento_origem)
SELECT l.id_lote,
       1 + (l.id_lote % 6),
       'saida_avaria',
       GREATEST(1, FLOOR((100 + (l.id_lote % 5) * 50) * 0.02))::integer,
       TIMESTAMP '2026-10-20 09:00:00' + (l.id_lote % 10) * INTERVAL '1 day',
       'AVARIA-' || l.id_lote
FROM lote l
WHERE l.id_lote > 6 AND l.id_lote % 7 = 0;

-- 4) Uma devolução de 5 unidades nos lotes de id múltiplo de 5
INSERT INTO movimentacao_estoque (id_lote, id_usuario, tipo, quantidade, data_hora, documento_origem)
SELECT l.id_lote,
       1 + (l.id_lote % 6),
       'entrada_devolucao',
       5,
       TIMESTAMP '2026-10-25 11:00:00' + (l.id_lote % 7) * INTERVAL '1 day',
       'DEV-' || l.id_lote
FROM lote l
WHERE l.id_lote > 6 AND l.id_lote % 5 = 0;