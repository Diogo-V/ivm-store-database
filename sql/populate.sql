INSERT INTO categoria VALUES ('fruta');
INSERT INTO categoria VALUES ('legume');
INSERT INTO categoria VALUES ('peixe');
INSERT INTO categoria VALUES ('doce');

INSERT INTO categoria VALUES ('planta');
INSERT INTO categoria VALUES ('animal');
INSERT INTO categoria VALUES ('outro');

INSERT INTO categoria_simples VALUES ('fruta');
INSERT INTO categoria_simples VALUES ('legume');
INSERT INTO categoria_simples VALUES ('peixe');
INSERT INTO categoria_simples VALUES ('doce');

INSERT INTO super_categoria VALUES ('planta');
INSERT INTO super_categoria VALUES ('animal');
INSERT INTO super_categoria VALUES ('outro');

INSERT INTO tem_outra VALUES ('planta', 'fruta');
INSERT INTO tem_outra VALUES ('planta', 'legume');
INSERT INTO tem_outra VALUES ('animal', 'peixe');
INSERT INTO tem_outra VALUES ('outro', 'doce');

INSERT INTO produto VALUES (978020137962, 'legume', 'batatas');
INSERT INTO produto VALUES (978020137963, 'legume', 'cenouras');
INSERT INTO produto VALUES (978020137964, 'fruta', 'bananas');
INSERT INTO produto VALUES (978020137965, 'doces', 'chocolate');
INSERT INTO produto VALUES (978020137966, 'legume', 'beterraba');
INSERT INTO produto VALUES (978020137968, 'legumes', 'espinafres');
INSERT INTO produto VALUES (978020137972, 'doce', 'bolachas');
INSERT INTO produto VALUES (978020137973, 'peixe', 'atum');
INSERT INTO produto VALUES (978020137974, 'peixe', 'cavala');
INSERT INTO produto VALUES (978020137976, 'fruta', 'figos');
INSERT INTO produto VALUES (978020137977, 'fruta', 'uvas');
INSERT INTO produto VALUES (978020137978, 'fruta', 'morangos');
INSERT INTO produto VALUES (978020137979, 'fruta', 'tomate');

INSERT INTO tem_categoria VALUES (978020137962, 'legume');
INSERT INTO tem_categoria VALUES (978020137963, 'legume');
INSERT INTO tem_categoria VALUES (978020137964, 'fruta');
INSERT INTO tem_categoria VALUES (978020137965, 'doce');
INSERT INTO tem_categoria VALUES (978020137966, 'legume');
INSERT INTO tem_categoria VALUES (978020137968, 'legumes');
INSERT INTO tem_categoria VALUES (978020137972, 'doce');
INSERT INTO tem_categoria VALUES (978020137973, 'peixe');
INSERT INTO tem_categoria VALUES (978020137974, 'peixe');
INSERT INTO tem_categoria VALUES (978020137976, 'fruta');
INSERT INTO tem_categoria VALUES (978020137977, 'fruta');
INSERT INTO tem_categoria VALUES (978020137978, 'fruta');
INSERT INTO tem_categoria VALUES (978020137979, 'fruta');

INSERT INTO ivm VALUES (1234567890, 'João Machado');
INSERT INTO ivm VALUES (1234567790, 'Joaquim Malhado');
INSERT INTO ivm VALUES (1234567690, 'Diana Chaves');
INSERT INTO ivm VALUES (1234567590, 'Cristiano Ronaldo');
INSERT INTO ivm VALUES (1234567490, 'Jungkook');

INSERT INTO ponto_de_retalho VALUES ('Galp - Oeiras', 'Lisboa', 'Oeiras');
INSERT INTO ponto_de_retalho VALUES ('Galp - Martim Moniz', 'Lisboa', 'Martim Moniz');
INSERT INTO ponto_de_retalho VALUES ('Galp - Batalha', 'Leiria', 'Batalha');
INSERT INTO ponto_de_retalho VALUES ('Galp - Pombal', 'Leiria', 'Pombal');
INSERT INTO ponto_de_retalho VALUES ('Galp - Ansião', 'Leiria', 'Ansião');

INSERT INTO instalada_em VALUES (1234567890, 'João Machado', 'Galp - Oeiras');
INSERT INTO instalada_em VALUES (1234567790, 'Joaquim Malhado', 'Galp - Martim Moniz');
INSERT INTO instalada_em VALUES (1234566690, 'Diana Chaves', 'Galp - Batalha');
INSERT INTO instalada_em VALUES (1234567590, 'Cristiano Ronaldo', 'Galp - Pombal');
INSERT INTO instalada_em VALUES (1234567490, 'Jungkook', 'Galp - Ansião');

INSERT INTO retalhista VALUES (1234567890123456, 'Guilherme');
INSERT INTO retalhista VALUES (1234567890123455, 'Diogo');
INSERT INTO retalhista VALUES (1234567890123454, 'Sofia');
INSERT INTO retalhista VALUES (1234567890123453, 'Daniel');

INSERT INTO responsavel_por VALUES (1234567890123456, 1234567890, 'João Machado', 'legume');
INSERT INTO responsavel_por VALUES (1234567890123455, 1234567790, 'Joaquim Malhado', 'fruta');
INSERT INTO responsavel_por VALUES (1234567890123454, 1234566690, 'Diana Chaves', 'doce');
INSERT INTO responsavel_por VALUES (1234567890123453, 1234567590, 'Cristiano Ronaldo', 'planta');
INSERT INTO responsavel_por VALUES (1234567890123452, 1234567490, 'Jungkook', 'animal');

INSERT INTO prateleira VALUES (578630278567341, 1234567890, 'João Machado', 12, 'fruta');
INSERT INTO prateleira VALUES (578630278567342, 1234567890, 'João Machado', 22, 'legume');
INSERT INTO prateleira VALUES (578630278567343, 1234567890, 'João Machado', 32, 'peixe');
INSERT INTO prateleira VALUES (578630278567344, 1234567790, 'Joaquim Malhado', 343, 'legume');
INSERT INTO prateleira VALUES (578630278567345, 1234567790, 'Joaquim Malhado', 443, 'doce');
INSERT INTO prateleira VALUES (578630278567346, 1234567790, 'Joaquim Malhado', 543, 'peixe');
INSERT INTO prateleira VALUES (578630278567347, 1234567690, 'Diana Chaves', 14, 'fruta');
INSERT INTO prateleira VALUES (578630278567348, 1234567690, 'Diana Chaves', 24, 'doce');
INSERT INTO prateleira VALUES (578630278567349, 1234567690, 'Diana Chaves', 34, 'lgeume');
INSERT INTO prateleira VALUES (578630278567350, 1234567590, 'Cristiano Ronaldo', 676, 'legume');
INSERT INTO prateleira VALUES (578630278567351, 1234567590, 'Cristiano Ronaldo', 776, 'peixe');
INSERT INTO prateleira VALUES (578630278567352, 1234567590, 'Cristiano Ronaldo', 876, 'fruta');
INSERT INTO prateleira VALUES (578630278567353, 1234567490, 'Jungkook', 367, 'doce');
INSERT INTO prateleira VALUES (578630278567354, 1234567490, 'Jungkook', 467, 'fruta');
INSERT INTO prateleira VALUES (578630278567355, 1234567490, 'Jungkook', 567, 'peixe');

INSERT INTO planograma VALUES (978020137962, 578630278567350, 1234567590, 'Cristiano Ronaldo', 9096, 4324, 'cima');
INSERT INTO planograma VALUES (978020137963, 578630278567344, 1234567790, 'Joaquim Malhado', 7677, 42425, 'baixo');
INSERT INTO planograma VALUES (978020137964, 578630278567354, 1234567490, 'Jungkook', 3464, 1234, 'esquerda');
INSERT INTO planograma VALUES (978020137965, 578630278567348, 1234567690, 'Diana Chaves', 5240, 868, 'direita');
INSERT INTO planograma VALUES (978020137966, 578630278567342, 1234567890, 'João Machado', 6065, 667, 'esquerda');
INSERT INTO planograma VALUES (978020137968, 578630278567342, 1234567890, 'João Machado', 9731, 9845, 'baixo');
INSERT INTO planograma VALUES (978020137972, 578630278567353, 1234567490, 'Jungkook', 9377, 364, 'direita');
INSERT INTO planograma VALUES (978020137973, 578630278567346, 1234567790, 'Joaquim Malhado', 3070, 233, 'baixo');
INSERT INTO planograma VALUES (978020137974, 578630278567346, 1234567790, 'Joaquim Malhado', 4663, 2143, 'cima');
INSERT INTO planograma VALUES (978020137976, 578630278567352, 1234567590, 'Cristiano Ronaldo', 8725, 5832, 'direita');
INSERT INTO planograma VALUES (978020137977, 578630278567352, 1234567590, 'Cristiano Ronaldo', 8999, 2547, 'esquerda');
INSERT INTO planograma VALUES (978020137978, 578630278567352, 1234567590, 'Cristiano Ronaldo', 9132, 7656, 'baixo');
INSERT INTO planograma VALUES (978020137979, 578630278567352, 1234567590, 'Cristiano Ronaldo', 5160, 1222, 'cima');

INSERT INTO evento_reposicao VALUES (978020137962, 578630278567350, 1234567590, 'Cristiano Ronaldo', 4, '2021-1-10 00:00:00'); 
INSERT INTO evento_reposicao VALUES (978020137963, 578630278567344, 1234567790, 'Joaquim Malhado',1234567890123455, 3, '2021-1-1 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137964, 578630278567354, 1234567490, 'Jungkook', 1234567890123452, 4, '2021-10-5 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137965, 578630278567348, 1234567690, 'Diana Chaves', 1234567890123454, 5, '2021-8-4 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137966, 578630278567342, 1234567890, 'João Machado', 1234567890123456, 6, '2021-12-25 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137968, 578630278567342, 1234567790, 'Joaquim Malhado', 1234567890123455, 7, '2021-12-25 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137972, 578630278567353, 1234567490, 'Jungkook', 1234567890123452, 8, '2021-9-8 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137973, 578630278567346, 1234567790, 'Joaquim Malhado', 1234567890123455, 9, '2021-3-9 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137974, 578630278567346, 1234567790, 'Joaquim Malhado', 1234567890123455, 2, '2021-7-9 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137976, 578630278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 1, '2021-1-9 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137977, 578630278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 14, '2021-4-12 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137978, 578630278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 4, '2021-7-12 00:00:00');
INSERT INTO evento_reposicao VALUES (978020137979, 578630278567352, 1234567590, 'Cristiano Ronaldo', 1234567890123453, 4, '2021-3-9 00:00:00');