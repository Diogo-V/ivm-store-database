DROP TABLE IF EXISTS categoria cascade;
DROP TABLE IF EXISTS categoria_simples cascade;
DROP TABLE IF EXISTS super_categoria cascade;
DROP TABLE IF EXISTS tem_outra cascade;
DROP TABLE IF EXISTS tem_categoria cascade;
DROP TABLE IF EXISTS produto cascade;
DROP TABLE IF EXISTS ivm cascade;
DROP TABLE IF EXISTS ponto_de_retalho cascade;
DROP TABLE IF EXISTS instalada_em cascade;
DROP TABLE IF EXISTS prateleira cascade;
DROP TABLE IF EXISTS planograma cascade;
DROP TABLE IF EXISTS retalhista cascade;
DROP TABLE IF EXISTS responsavel_por cascade;
DROP TABLE IF EXISTS evento_reposicao cascade;


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
    ean numeric(10,4)	not null UNIQUE,
    nome VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT fk_tem_categoria_ean FOREIGN KEY(ean) REFERENCES produto(ean),
    CONSTRAINT fk_tem_categoria_nome FOREIGN KEY(nome) REFERENCES categoria(nome)
);


CREATE TABLE ivm (
    num_serie numeric(10,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_ivm PRIMARY KEY (num_serie,fabricante)
);

CREATE TABLE ponto_de_retalho (
    nome VARCHAR(80) NOT NULL UNIQUE,
    distrio VARCHAR(80) NOT NULL,
    concelho VARCHAR(80) NOT NULL,
    CONSTRAINT pk_ponto_de_retalho PRIMARY KEY (nome)
);


CREATE TABLE instalada_em(
    num_serie numeric(16,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    local VARCHAR(80) NOT NULL,
    CONSTRAINT pk_instalada_em PRIMARY KEY (num_serie,fabricante),
    CONSTRAINT fk_instalada_em_num_serie FOREIGN KEY(num_serie) REFERENCES ivm(num_serie),
    CONSTRAINT fk_instalada_em_fabricante FOREIGN KEY(fabricante) REFERENCES ivm(fabricante),
    CONSTRAINT fk_instalada_em_local FOREIGN KEY(local) REFERENCES ponto_de_retalho(nome)

);

CREATE TABLE prateleira (
    nro numeric(16,4)not null UNIQUE,
    num_serie numeric(16,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    altura numeric(16,4) not null,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT pk_prateleira PRIMARY KEY (nro,num_serie,fabricante),
    CONSTRAINT fk_prateleira_num_serie FOREIGN KEY(num_serie) REFERENCES ivm(num_serie),
    CONSTRAINT fk_prateleira_fabricante FOREIGN KEY(fabricante) REFERENCES ivm(fabricante)
);


CREATE TABLE planograma (
    ean numeric(16,4) not null UNIQUE,
    nro numeric(16,4) not null UNIQUE,
    num_serie numeric(16,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    faces numeric (4,0) NOT NULL,
    unidades numeric (7,0) NOT NULL,
    loc VARCHAR(80) NOT NULL,
    CONSTRAINT pk_planograma PRIMARY KEY (ean,nro,num_serie,fabricante),
    CONSTRAINT fk_planograma_ean FOREIGN KEY(ean) REFERENCES produto(ean),
    CONSTRAINT fk_planograma_num_serie FOREIGN KEY(num_serie) REFERENCES prateleira(num_serie),
    CONSTRAINT fk_planograma_fabricante FOREIGN KEY(fabricante) REFERENCES prateleira(fabricante),
    CONSTRAINT fk_planograma_nro FOREIGN KEY(nro) REFERENCES prateleira(nro)

);

CREATE TABLE retalhista(
    tin numeric(16,0) NOT NULL UNIQUE,
    nome VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT pk_retalhista PRIMARY KEY (tin)

);

CREATE TABLE responsavel_por(
    tin numeric(16,0) NOT NULL,
    num_serie numeric(16,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    nome_cat VARCHAR(80) NOT NULL,
    CONSTRAINT pk_responsavel_por PRIMARY KEY (num_serie,fabricante),
    CONSTRAINT fk_responsvale_por_num_serie FOREIGN KEY(num_serie) REFERENCES ivm(num_serie),
    CONSTRAINT fk_responsvale_por_fabricante FOREIGN KEY(fabricante) REFERENCES ivm(fabricante),
    CONSTRAINT fk_responsvale_por_tin FOREIGN KEY(tin) REFERENCES retalhista(tin),
    CONSTRAINT fk_responsvale_por__nome_categoria FOREIGN KEY(nome_cat) REFERENCES categoria(nome)

);


CREATE TABLE evento_reposicao(
    ean numeric(16,4) not null UNIQUE,
    nro numeric(16,4) not null UNIQUE,
    num_serie numeric(16,0) NOT NULL UNIQUE,
    fabricante VARCHAR(80) NOT NULL UNIQUE,
    tin numeric(16,0) NOT NULL,
    unidades numeric(16,0)NOT NULL,
    instante TIMESTAMP  NOT NULL UNIQUE,
    CONSTRAINT pk_evento_reposicao PRIMARY KEY (ean,nro,num_serie,fabricante,instante),
    CONSTRAINT fk_evento_reposicao_ean FOREIGN KEY(ean) REFERENCES planograma(ean),
    CONSTRAINT fk_evento_reposicao_nro FOREIGN KEY(nro) REFERENCES planograma(nro),
    CONSTRAINT fk_evento_reposicao_num_serie FOREIGN KEY(num_serie) REFERENCES planograma(num_serie),
    CONSTRAINT fk_evento_reposicao_fabricante FOREIGN KEY(fabricante) REFERENCES planograma(fabricante),
    CONSTRAINT fk_evento_reposicao_tin FOREIGN KEY(tin) REFERENCES retalhista(tin)
);


-------------------------------------- Integrity Constrains -------------------------

--------------------------------------- Procedures ----------------------------------

-- RI-1)

CREATE OR REPLACE FUNCTION chk_super_categoria_proc()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.super_categoria = New.categoria THEN
        RAISE EXCEPTION 'Categoria dentro dela mesma';
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- RI-4)

CREATE OR REPLACE FUNCTION chk_unidades_evento_de_reposicao_proc()
RETURNS TRIGGER AS
$$
BEGIN

    SELECT unidades from planograma WHERE ean = NEW.ean;
    IF NEW.unidades > unidades THEN
        RAISE EXCEPTION 'Numero de unidades do evento de reposicao excede as do planograma';
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- RI-5)

CREATE OR REPLACE FUNCTION chk_reposicao_produto_maquina_proc()
RETURNS TRIGGER AS
$$
BEGIN

    
    IF NOT EXISTS(SELECT ean,num_serie from prateleira natural join tem_categoria where num_serie=NEW.num_serie and ean=NEW.ean) THEN
        RAISE EXCEPTION 'Produto a ser reposto numa prateleira que nao contem pelo menos uma das suas categorias';
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--------------------------------------- Triggers ----------------


CREATE TRIGGER chk_super_categoria
BEFORE Update OR INSERT On tem_outra
FOR EACH ROW EXECUTE PROCEDURE chk_super_categoria_proc();

CREATE TRIGGER chk_unidades_evento_de_reposicao
BEFORE Update OR INSERT On tem_outra
FOR EACH ROW EXECUTE PROCEDURE chk_unidades_evento_de_reposicao_proc();

CREATE TRIGGER chk_reposicao_produto_maquina_planograma
BEFORE Update OR INSERT On planograma
FOR EACH ROW EXECUTE PROCEDURE chk_reposicao_produto_maquina_proc();

CREATE TRIGGER chk_reposicao_produto_maquina_evento_reposicao
BEFORE Update OR INSERT On evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE chk_reposicao_produto_maquina_proc();



------------------------------------- Queries ------------------------------------


-- 1)

select nome from evento_reposicao natural join retalhista group by tin,nome having count(*) >= all (
    select count(*) from evento_reposicao group by tin
);

-- 2)

select nome from retalhista as R where not exists (
    select nome from categoria_simples
    Except
    select nome from (categoria_simples join responsavel_por on categoria_simples.nome=responsavel) as X where
    X.tin = R.tin
);

-- 3)

select ean from products as P where not exists(
    select ean from evento_reposiscao where P.ean = evento_reposicao.ean
);

-- 4)
select ean from evento_reposicao group by ean having count(*)=1;