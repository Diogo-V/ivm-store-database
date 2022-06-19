SELECT SUM(v.unidades), v.dia_semana, v.concelho FROM Vendas AS v
WHERE (v.ano BETWEEN %d AND %d) AND
(v.dia_mes BETWEEN %d AND %d) AND
(v.dia_semana BETWEEN %d AND %d)
GROUP BY CUBE(v.dia_semana, v.concelho);

SELECT SUM(v.unidades), v.dia_semana, v.concelho, v.cat FROM Vendas AS v
WHERE v.distrito LIKE %s
GROUP BY GROUPING SETS(v.concelho, v.cat, v.dia_semana);