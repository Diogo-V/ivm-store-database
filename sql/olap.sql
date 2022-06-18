SELECT SUM(v.unidades), v.dia_semana, v.concelho FROM Vendas AS v
WHERE (v.ano BETWEEN %s AND %s) AND
(v.dia_mes BETWEEN %s AND %s) AND
(v.dia_semana BETWEEN %s AND %s)
GROUP BY CUBE(v.dia_semana, v.concelho);

SELECT SUM(v.unidades), v.dia_semana, v.concelho, v.cat FROM Vendas AS v
WHERE v.distrito LIKE %s
GROUP BY GROUPING SETS(v.concelho, v.cat, v.dia_semana);