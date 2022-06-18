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
    ean numeric(10,4)	not null UNIQUE,
    cat VARCHAR(80) NOT NULL,
    descr VARCHAR(256) NOT NULL,
    CONSTRAINT pk_produto PRIMARY KEY (ean),
    CONSTRAINT fk_produto FOREIGN KEY(cat) REFERENCES categoria(nome)
);


CREATE TABLE tem_categoria(
    ean numeric(10,4) not null UNIQUE,
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
    nro numeric(16,4) not null UNIQUE,
    num_serie numeric(16,0) NOT NULL,
    fabricante VARCHAR(80) NOT NULL,
    altura numeric(4, 1) not null,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT pk_prateleira PRIMARY KEY (nro, num_serie, fabricante),
    CONSTRAINT fk_prateleira_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    CONSTRAINT fk_prateleira_nome FOREIGN KEY(nome) REFERENCES categoria(nome)
);


CREATE TABLE planograma (
    ean numeric(16,4) not null,
    nro numeric(16,4) not null,
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
    ean numeric(16,4) not null,
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
