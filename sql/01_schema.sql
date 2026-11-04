-- Controle de Estoque e Logística - criação das tabelas
-- Banco: PostgreSQL

-- Apaga as tabelas antes de criar, para o script poder rodar várias vezes.
-- Ordem: primeiro as que dependem de outras (filhas), depois as "pai".
DROP TABLE IF EXISTS movimentacao_estoque;
DROP TABLE IF EXISTS lote;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS localizacao;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS produto;
-- Tabelas independentes (não apontam para ninguém)
create table usuario (
  id_usuario integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome varchar(100) NOT NULL
);
create TABLE localizacao (
  id_localizacao integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  corredor varchar(20) NOT NULL,
  prateleira integer NOT NULL,
  posicao varchar(20) NOT NULL
);
create TABLE fornecedor (
  id_fornecedor integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  razao_social varchar(150) NOT NULL,
  cnpj varchar(14) UNIQUE NOT NULL,
  email varchar(100) NOT NULL,
  telefone varchar(20) NOT NULL,
  prazo_entrega_dias integer NOT NULL
);
create TABLE produto (
  sku varchar(50) PRIMARY KEY,
  ean varchar(20) UNIQUE NOT NULL,
  nome varchar(80) NOT NULL,
  descricao varchar(200),
  categoria varchar(100),
  unidade_medida varchar(10) NOT NULL,
  estoque_minimo integer NOT NULL,
  estoque_maximo integer NOT NULL,
  preco_venda decimal(10,2) NOT NULL check (preco_venda >= 0)
);

-- Tabelas dependentes
create TABLE lote (
  id_lote integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  sku varchar(50) NOT NULL,
  id_fornecedor integer NOT NULL,
  id_localizacao integer NOT NULL,
  validade date NOT NULL,
  preco_custo decimal(10,2) NOT NULL,
  FOREIGN KEY (sku) REFERENCES produto (sku),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor),
  FOREIGN KEY (id_localizacao) REFERENCES localizacao (id_localizacao)
);
create TABLE movimentacao_estoque (
  id_movimentacao integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_lote integer NOT NULL,
  id_usuario integer NOT NULL,
  tipo varchar(30) NOT NULL
    CHECK (tipo in ('entrada_compra', 'entrada_devolucao', 'saida_venda', 'saida_avaria')),
  quantidade integer check (quantidade > 0) NOT NULL,
  data_hora timestamp NOT NULL,
  documento_origem varchar(80),
  FOREIGN KEY (id_lote) REFERENCES lote (id_lote),
  FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);
