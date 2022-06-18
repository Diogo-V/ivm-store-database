
CREATE VIEW Vendas(ean, cat, ano, trimestre, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT ean,cat,EXTRACT(YEAR FROM instante) as trimestre,EXTRACT(QUARTER FROM instante) as ano,EXTRACT(DAY FROM instante) as dia_mes,
EXTRACT(DOW FROM instante) as dia_semana,distrito,concelho,unidades from produto natural join evento_reposicao as E
natural join instalada_em as I inner join ponto_de_retalho as P on I.local=P.nome;