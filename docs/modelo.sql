CREATE TABLE "usuario" (
  "id_usuario" integer PRIMARY KEY,
  "nome" varchar(100)
);

CREATE TABLE "localizacao" (
  "id_localizacao" integer PRIMARY KEY,
  "corredor" varchar(20),
  "prateleira" integer,
  "posicao" varchar(20)
);

CREATE TABLE "fornecedor" (
  "id_fornecedor" int PRIMARY KEY,
  "razao_social" varchar(150),
  "cnpj" varchar(14),
  "email" varchar(100),
  "telefone" varchar(20),
  "prazo_entrega_dias" integer
);

CREATE TABLE "produto" (
  "sku" varchar(50) PRIMARY KEY,
  "ean" varchar(20),
  "nome" varchar(80),
  "descricao" varchar(200),
  "categoria" varchar(100),
  "unidade_medida" integer,
  "estoque_minimo" integer,
  "estoque_maximo" integer,
  "preco_venda" decimal(10,2)
);

CREATE TABLE "lote" (
  "id_lote" int PRIMARY KEY,
  "sku" varchar(50),
  "id_fornecedor" int,
  "id_localizacao" integer,
  "validade" date,
  "preco_custo" decimal(10,2)
);

CREATE TABLE "movimentacao_estoque" (
  "id_movimentacao" int PRIMARY KEY,
  "id_lote" int,
  "id_usuario" integer,
  "tipo" varchar(30),
  "quantidade" int,
  "data_hora" timestamp,
  "documento_origem" varchar(80)
);

ALTER TABLE "lote" ADD FOREIGN KEY ("sku") REFERENCES "produto" ("sku") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "lote" ADD FOREIGN KEY ("id_fornecedor") REFERENCES "fornecedor" ("id_fornecedor") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "lote" ADD FOREIGN KEY ("id_localizacao") REFERENCES "localizacao" ("id_localizacao") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "movimentacao_estoque" ADD FOREIGN KEY ("id_lote") REFERENCES "lote" ("id_lote") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "movimentacao_estoque" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuario" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;
