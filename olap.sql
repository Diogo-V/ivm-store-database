/*número total de artigos vendidos:
1. num dado período (i.e. entre duas datas), por dia da semana, por concelho e no total
2. num dado distrito (i.e. “Lisboa”), por concelho, categoria, dia da semana e no total
  */

SELECT v.ean, v.unidades v.dia_semana, v.concelho FROM Vendas AS v
WHERE v.ano BETWEEN A AND B AND v.dia_mes BETWEEN C AND D AND v.dia_semana BETWEEN E AND F
GROUP BY CUBE(v.dia_semana, v.concelho);

SELECT v.ean, v.unidades, v.dia_semana, v.concelho, v.cast FROM Vendas AS v
WHERE v.distrito = "Lisboa"
GROUP BY CUBE(v.concelho, v.cast, v.dia_semana);