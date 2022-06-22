--1)

-- Hashing para tornar o nome_cat='Frutos' mais rapido
CREATE INDEX nome_cat_idx ON responsavel_por USING HASH(nome_cat);

-- Por causa do sorting pelo nome (ver no explain analyze)
CREATE INDEX nome_retalhista ON retalhista(nome);


-- 2)

-- P.descr like 'A%'
CREATE INDEX prod_descr_idx ON produto(descr);
