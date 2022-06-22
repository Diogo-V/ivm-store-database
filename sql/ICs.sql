-------------------------------------- Integrity Constrains -------------------------

--------------------------------------- Procedures ----------------------------------

-- RI-1)

CREATE OR REPLACE FUNCTION chk_super_categoria_proc()
RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (WITH RECURSIVE generation AS (
    SELECT categoria
    FROM tem_outra
    WHERE super_categoria like NEW.categoria

UNION ALL

    SELECT tem_outra.categoria
    FROM tem_outra
    JOIN generation g
      ON g.categoria = tem_outra.super_categoria
)
SELECT categoria
FROM generation
WHERE categoria like NEW.super_categoria) OR NEW.super_categoria LIKE NEW.categoria THEN
        RAISE EXCEPTION 'Categoria dentro dela mesma';
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- RI-2)


CREATE OR REPLACE FUNCTION chk_categoria_simples_proc()
RETURNS TRIGGER AS
$$
BEGIN

    
    IF EXISTS(SELECT nome from super_categoria WHERE nome LIKE NEW.nome) THEN
        RAISE EXCEPTION 'Nome de categoria simples existe na super categoria';
    END IF; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- RI-4)

CREATE OR REPLACE FUNCTION chk_unidades_evento_de_reposicao_proc()
RETURNS TRIGGER AS
$$

declare total decimal (16,0);
BEGIN

    SELECT unidades into total from planograma WHERE ean = NEW.ean;
    IF NEW.unidades > total THEN
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
BEFORE Update OR INSERT On evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE chk_unidades_evento_de_reposicao_proc();

CREATE OR REPLACE TRIGGER chk_reposicao_produto_maquina_evento_reposicao
BEFORE Update OR INSERT On evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE chk_reposicao_produto_maquina_proc();


CREATE OR REPLACE TRIGGER chk_categoria_simples
BEFORE Update OR INSERT On categoria_simples
FOR EACH ROW EXECUTE PROCEDURE chk_categoria_simples_proc();
