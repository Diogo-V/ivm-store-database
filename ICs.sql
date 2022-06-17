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


CREATE OR REPLACE TRIGGER chk_super_categoria
BEFORE Update OR INSERT On tem_outra
FOR EACH ROW EXECUTE PROCEDURE chk_super_categoria_proc();

CREATE OR REPLACE TRIGGER chk_unidades_evento_de_reposicao
BEFORE Update OR INSERT On tem_outra
FOR EACH ROW EXECUTE PROCEDURE chk_unidades_evento_de_reposicao_proc();

CREATE OR REPLACE TRIGGER chk_reposicao_produto_maquina_planograma
BEFORE Update OR INSERT On planograma
FOR EACH ROW EXECUTE PROCEDURE chk_reposicao_produto_maquina_proc();

CREATE OR REPLACE TRIGGER chk_reposicao_produto_maquina_evento_reposicao
BEFORE Update OR INSERT On evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE chk_reposicao_produto_maquina_proc();
