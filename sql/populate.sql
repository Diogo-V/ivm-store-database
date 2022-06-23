CREATE TABLE categoria (
    nome VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_categoria PRIMARY KEY (nome)
);

CREATE TABLE categoria_simples (
    nome VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_categoria_simples PRIMARY KEY (nome),
    constraint fk_categoria_simples_nome foreign key(nome) references categoria(nome)
);

CREATE TABLE super_categoria (
    nome VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_super_categoria PRIMARY KEY (nome),
    constraint fk_super_categoria_nome foreign key(nome) references categoria(nome)
);


CREATE TABLE tem_outra (
    super_categoria VARCHAR(80) NOT NULL,
    categoria VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_tem_outra PRIMARY KEY (categoria),
    constraint fk_tem_outra_super_categoria foreign key(super_categoria) references super_categoria(nome),
    constraint fk_tem_outra_categoria foreign key(categoria) references categoria(nome) 
);


CREATE TABLE produto (
    ean numeric(13, 0)	not null UNIQUE,
    cat VARCHAR(80) NOT NULL,
    descr VARCHAR(256) NOT NULL,
    CONSTRAINT pk_produto PRIMARY KEY (ean),
    CONSTRAINT fk_produto FOREIGN KEY(cat) REFERENCES categoria(nome)
);


CREATE TABLE tem_categoria(
    ean numeric(13,0) not null UNIQUE,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT fk_tem_categoria_ean FOREIGN KEY(ean) REFERENCES produto(ean),
    CONSTRAINT fk_tem_categoria_nome FOREIGN KEY(nome) REFERENCES categoria(nome)
);


CREATE TABLE ivm (
    num_serie numeric(10,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_ivm PRIMARY KEY (num_serie, fabricante)
);

CREATE TABLE ponto_de_retalho (
    nome VARCHAR(80) NOT NULL UNIQUE,
    distrito VARCHAR(80) NOT NULL,
    concelho VARCHAR(80) NOT NULL,
    CONSTRAINT pk_ponto_de_retalho PRIMARY KEY (nome)
);


CREATE TABLE instalada_em(
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    local VARCHAR(80) NOT NULL,
    CONSTRAINT pk_instalada_em PRIMARY KEY (num_serie, fabricante),
    CONSTRAINT fk_instalada_em_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    CONSTRAINT fk_instalada_em_local FOREIGN KEY(local) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE prateleira (
    nro numeric(16,0) not null UNIQUE,
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    altura numeric(4, 1) not null,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT pk_prateleira PRIMARY KEY (nro, num_serie, fabricante),
    CONSTRAINT fk_prateleira_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    CONSTRAINT fk_prateleira_nome FOREIGN KEY(nome) REFERENCES categoria(nome)
);


CREATE TABLE planograma (
    ean numeric(13,0) not null,
    nro numeric(16,0) not null,
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    faces numeric (4,0) NOT NULL,
    unidades numeric (7,0) NOT NULL,
    loc VARCHAR(80) NOT NULL,
    CONSTRAINT pk_planograma PRIMARY KEY (ean, nro, num_serie, fabricante),
    CONSTRAINT fk_planograma_ean FOREIGN KEY(ean) REFERENCES produto(ean),
    CONSTRAINT fk_planograma_prateleira FOREIGN KEY(nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE retalhista(
    tin numeric(16,0) NOT NULL UNIQUE,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT pk_retalhista PRIMARY KEY (tin)
);

CREATE TABLE responsavel_por(
    tin numeric(16,0) NOT NULL,
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    nome_cat VARCHAR(80) NOT NULL,
    CONSTRAINT pk_responsavel_por PRIMARY KEY (num_serie, fabricante),
    CONSTRAINT fk_responsvale_por_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    CONSTRAINT fk_responsvale_por_tin FOREIGN KEY(tin) REFERENCES retalhista(tin),
    CONSTRAINT fk_responsvale_por__nome_categoria FOREIGN KEY(nome_cat) REFERENCES categoria(nome)
);


CREATE TABLE evento_reposicao(
    ean numeric(13,0) not null,
    nro numeric(16,4) not null,
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    tin numeric(16,0) NOT NULL,
    unidades numeric(16,0)NOT NULL,
    instante TIMESTAMP  NOT NULL UNIQUE,
    CONSTRAINT pk_evento_reposicao PRIMARY KEY (ean, nro, num_serie, fabricante, instante),
    CONSTRAINT fk_evento_reposicao_planograma FOREIGN KEY(ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
    CONSTRAINT fk_evento_reposicao_tin FOREIGN KEY(tin) REFERENCES retalhista(tin)
);


INSERT INTO categoria VALUES ('fruta');
INSERT INTO categoria VALUES ('legume');
INSERT INTO categoria VALUES ('peixe');
INSERT INTO categoria VALUES ('doce');

INSERT INTO categoria VALUES ('planta');
INSERT INTO categoria VALUES ('animal');
INSERT INTO categoria VALUES ('outro');
INSERT INTO categoria VALUES ('Frutos');

INSERT INTO categoria_simples VALUES ('fruta');
INSERT INTO categoria_simples VALUES ('legume');
INSERT INTO categoria_simples VALUES ('peixe');
INSERT INTO categoria_simples VALUES ('doce');
INSERT INTO categoria_simples VALUES ('Frutos');


INSERT INTO super_categoria VALUES ('planta');
INSERT INTO super_categoria VALUES ('animal');
INSERT INTO super_categoria VALUES ('outro');

INSERT INTO tem_outra VALUES ('planta', 'fruta');
INSERT INTO tem_outra VALUES ('planta', 'legume');
INSERT INTO tem_outra VALUES ('animal', 'peixe');
INSERT INTO tem_outra VALUES ('outro', 'doce');
INSERT INTO tem_outra VALUES ('outro', 'Frutos');

INSERT INTO produto VALUES (7962, 'legume', 'batatas');
INSERT INTO produto VALUES (7963, 'legume', 'cenouras');
INSERT INTO produto VALUES (7964, 'fruta', 'bananas');
INSERT INTO produto VALUES (7965, 'doce', 'chocolate');
INSERT INTO produto VALUES (7966, 'legume', 'beterraba');
INSERT INTO produto VALUES (7968, 'legume', 'espinafres');
INSERT INTO produto VALUES (7972, 'doce', 'bolachas');
INSERT INTO produto VALUES (7973, 'peixe', 'atum');
INSERT INTO produto VALUES (7974, 'peixe', 'cavala');
INSERT INTO produto VALUES (7976, 'fruta', 'figos');
INSERT INTO produto VALUES (7977, 'fruta', 'Amoras');
INSERT INTO produto VALUES (7978, 'fruta', 'Ameixas');
INSERT INTO produto VALUES (7979, 'fruta', 'tomate');

INSERT INTO tem_categoria VALUES (7962, 'legume');
INSERT INTO tem_categoria VALUES (7963, 'legume');
INSERT INTO tem_categoria VALUES (7964, 'fruta');
INSERT INTO tem_categoria VALUES (7965, 'doce');
INSERT INTO tem_categoria VALUES (7966, 'legume');
INSERT INTO tem_categoria VALUES (7968, 'legume');
INSERT INTO tem_categoria VALUES (7972, 'doce');
INSERT INTO tem_categoria VALUES (7973, 'peixe');
INSERT INTO tem_categoria VALUES (7974, 'peixe');
INSERT INTO tem_categoria VALUES (7976, 'fruta');
INSERT INTO tem_categoria VALUES (7977, 'fruta');
INSERT INTO tem_categoria VALUES (7978, 'fruta');
INSERT INTO tem_categoria VALUES (7979, 'fruta');

INSERT INTO ivm VALUES (1234567890, 'João Machado');
INSERT INTO ivm VALUES (1234567790, 'Joaquim Malhado');
INSERT INTO ivm VALUES (1234567690, 'Diana Chaves');
INSERT INTO ivm VALUES (1234567590, 'Cristiano Ronaldo');
INSERT INTO ivm VALUES (1234567490, 'Jungkook');
INSERT INTO ivm VALUES (1234567290, 'Quim Barreiros');
INSERT INTO ivm VALUES (1234567390, 'Tony Carreira');

INSERT INTO ponto_de_retalho VALUES ('Galp - Oeiras', 'Lisboa', 'Oeiras');
INSERT INTO ponto_de_retalho VALUES ('Galp - Martim Moniz', 'Lisboa', 'Martim Moniz');
INSERT INTO ponto_de_retalho VALUES ('Galp - Batalha', 'Leiria', 'Batalha');
INSERT INTO ponto_de_retalho VALUES ('Galp - Pombal', 'Leiria', 'Pombal');
INSERT INTO ponto_de_retalho VALUES ('Galp - Ansião', 'Leiria', 'Ansião');

INSERT INTO instalada_em VALUES (1234567890, 'João Machado', 'Galp - Oeiras');
INSERT INTO instalada_em VALUES (1234567790, 'Joaquim Malhado', 'Galp - Martim Moniz');
INSERT INTO instalada_em VALUES (1234567690, 'Diana Chaves', 'Galp - Batalha');
INSERT INTO instalada_em VALUES (1234567590, 'Cristiano Ronaldo', 'Galp - Pombal');
INSERT INTO instalada_em VALUES (1234567490, 'Jungkook', 'Galp - Ansião');

INSERT INTO retalhista VALUES (1234567890123456, 'Guilherme');
INSERT INTO retalhista VALUES (1234567890123455, 'Diogo');
INSERT INTO retalhista VALUES (1234567890123454, 'Sofia');
INSERT INTO retalhista VALUES (1234567890123453, 'Daniel');
INSERT INTO retalhista VALUES (1234567890123452, 'Jimin');
INSERT INTO retalhista VALUES (1234567890123458, 'Quim Barreiros');
INSERT INTO retalhista VALUES (1234567890123459, 'Tony Carreira');

INSERT INTO responsavel_por VALUES (1234567890123456, 1234567890, 'João Machado', 'legume');
INSERT INTO responsavel_por VALUES (1234567890123455, 1234567790, 'Joaquim Malhado', 'fruta');
INSERT INTO responsavel_por VALUES (1234567890123454, 1234567690, 'Diana Chaves', 'doce');
INSERT INTO responsavel_por VALUES (1234567890123453, 1234567590, 'Cristiano Ronaldo', 'planta');
INSERT INTO responsavel_por VALUES (1234567890123452, 1234567490, 'Jungkook', 'animal');
INSERT INTO responsavel_por VALUES (1234567890123458, 1234567290, 'Quim Barreiros', 'Frutos');
INSERT INTO responsavel_por VALUES (1234567890123459, 1234567390, 'Tony Carreira', 'Frutos');

INSERT INTO prateleira VALUES (30278567341, 1234567890, 'João Machado', 12, 'fruta');
INSERT INTO prateleira VALUES (30278567342, 1234567890, 'João Machado', 22, 'legume');
INSERT INTO prateleira VALUES (30278567343, 1234567890, 'João Machado', 32, 'peixe');
INSERT INTO prateleira VALUES (30278567344, 1234567790, 'Joaquim Malhado', 343, 'legume');
INSERT INTO prateleira VALUES (30278567345, 1234567790, 'Joaquim Malhado', 443, 'doce');
INSERT INTO prateleira VALUES (30278567346, 1234567790, 'Joaquim Malhado', 543, 'peixe');
INSERT INTO prateleira VALUES (30278567347, 1234567690, 'Diana Chaves', 14, 'fruta');
INSERT INTO prateleira VALUES (30278567348, 1234567690, 'Diana Chaves', 24, 'doce');
INSERT INTO prateleira VALUES (30278567349, 1234567690, 'Diana Chaves', 34, 'legume');
INSERT INTO prateleira VALUES (30278567350, 1234567590, 'Cristiano Ronaldo', 676, 'legume');
INSERT INTO prateleira VALUES (30278567351, 1234567590, 'Cristiano Ronaldo', 776, 'peixe');
INSERT INTO prateleira VALUES (30278567352, 1234567590, 'Cristiano Ronaldo', 876, 'fruta');
INSERT INTO prateleira VALUES (30278567353, 1234567490, 'Jungkook', 367, 'doce');
INSERT INTO prateleira VALUES (30278567354, 1234567490, 'Jungkook', 467, 'fruta');
INSERT INTO prateleira VALUES (30278567355, 1234567490, 'Jungkook', 567, 'peixe');

INSERT INTO planograma VALUES (7962, 30278567350, 1234567590, 'Cristiano Ronaldo', 9096, 4324, 'cima');
INSERT INTO planograma VALUES (7963, 30278567344, 1234567790, 'Joaquim Malhado', 7677, 42425, 'baixo');
INSERT INTO planograma VALUES (7964, 30278567354, 1234567490, 'Jungkook', 3464, 1234, 'esquerda');
INSERT INTO planograma VALUES (7965, 30278567348, 1234567690, 'Diana Chaves', 5240, 868, 'direita');
INSERT INTO planograma VALUES (7966, 30278567342, 1234567890, 'João Machado', 6065, 667, 'esquerda');
INSERT INTO planograma VALUES (7968, 30278567342, 1234567890, 'João Machado', 9731, 9845, 'baixo');
INSERT INTO planograma VALUES (7972, 30278567353, 1234567490, 'Jungkook', 9377, 364, 'direita');
INSERT INTO planograma VALUES (7973, 30278567346, 1234567790, 'Joaquim Malhado', 3070, 233, 'baixo');
INSERT INTO planograma VALUES (7974, 30278567346, 1234567790, 'Joaquim Malhado', 4663, 2143, 'cima');
INSERT INTO planograma VALUES (7976, 30278567352, 1234567590, 'Cristiano Ronaldo', 8725, 5832, 'direita');
INSERT INTO planograma VALUES (7977, 30278567352, 1234567590, 'Cristiano Ronaldo', 8999, 2547, 'esquerda');
INSERT INTO planograma VALUES (7978, 30278567352, 1234567590, 'Cristiano Ronaldo', 9132, 7656, 'baixo');
INSERT INTO planograma VALUES (7979, 30278567352, 1234567590, 'Cristiano Ronaldo', 5160, 1222, 'cima');

INSERT INTO evento_reposicao VALUES (7962, 30278567350, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 4, '2021-01-10 00:00:00'); 
INSERT INTO evento_reposicao VALUES (7963, 30278567344, 1234567790, 'Joaquim Malhado',1234567890123455, 3, '2021-01-01 00:00:00');
INSERT INTO evento_reposicao VALUES (7964, 30278567354, 1234567490, 'Jungkook', 1234567890123452, 4, '2021-10-05 00:00:00');
INSERT INTO evento_reposicao VALUES (7965, 30278567348, 1234567690, 'Diana Chaves', 1234567890123454, 5, '2021-08-04 00:00:00');
INSERT INTO evento_reposicao VALUES (7966, 30278567342, 1234567890, 'João Machado', 1234567890123456, 6, '2021-12-25 00:00:00');
INSERT INTO evento_reposicao VALUES (7968, 30278567342, 1234567890, 'João Machado', 1234567890123456, 7, '2021-12-26 00:00:00');
INSERT INTO evento_reposicao VALUES (7972, 30278567353, 1234567490, 'Jungkook', 1234567890123452, 8, '2021-09-08 00:00:00');
INSERT INTO evento_reposicao VALUES (7973, 30278567346, 1234567790, 'Joaquim Malhado', 1234567890123455, 9, '2021-03-08 00:00:00');
INSERT INTO evento_reposicao VALUES (7974, 30278567346, 1234567790, 'Joaquim Malhado', 1234567890123455, 2, '2021-07-09 00:00:00');
INSERT INTO evento_reposicao VALUES (7976, 30278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 1, '2021-01-09 00:00:00');
INSERT INTO evento_reposicao VALUES (7977, 30278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 14, '2021-04-12 00:00:00');
INSERT INTO evento_reposicao VALUES (7979, 30278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 4, '2021-03-09 00:00:00');