-- 1)

select nome from evento_reposicao natural join retalhista group by tin,nome having count(*) >= all (
    select count(*) from evento_reposicao group by tin
);

-- 2)

select nome from retalhista as R where (
    select nome from (categoria_simples join responsavel_por on categoria_simples.nome = responsavel_por.nome_cat) as X where
    X.tin = R.tin
);

-- 3)

select ean from produto as P where not exists(
    select ean from evento_reposicao where P.ean = evento_reposicao.ean
);

-- 4)
select ean from evento_reposicao group by ean having count(*)=1;

--- 5.c)

SELECT e.ean, e.num_serie, t.ean, t.nome FROM evento_reposicao AS e, tem_categoria AS t
WHERE t.ean = e.ean AND e.num_serie = %s
GROUP BY e.num_serie, t.nome
