CREATE DATABASE locadora
GO
USE locadora
GO

CREATE TABLE filme(
id			INT											NOT NULL,
titulo		VARCHAR(40)									NOT NULL,
ano			INT				CHECK(ano < 2022)		NULL
PRIMARY KEY(id))
GO
CREATE TABLE dvd(
num					INT													NOT NULL,
data_fabricacao		DATETIME	CHECK(data_fabricacao < GETDATE())		NOT NULL,
filmeId				INT													NOT NULL
PRIMARY KEY(num),
FOREIGN KEY(filmeId) REFERENCES filme (id))
GO
CREATE TABLE locacao(
dvdNum					INT									NOT NULL,
clienteNum_cadastro		INT									NOT NULL,
data_locacao			DATETIME							NOT NULL,
data_devolucao			DATETIME							NOT NULL,
valor					DECIMAL(7,2)	CHECK(valor > 0)	NOT NULL
PRIMARY KEY(data_locacao),
FOREIGN KEY(dvdNum) REFERENCES dvd (num),
FOREIGN KEY(clienteNum_cadastro) REFERENCES cliente (num_cadastro),
CONSTRAINT chk_dt1 CHECK(data_locacao = GETDATE()),
CONSTRAINT chk_dt2 CHECK(data_devolucao > data_locacao))
GO
CREATE TABLE cliente(
num_cadastro		INT										NOT NULL,
nome				VARCHAR(70)								NOT NULL,
logradouro			VARCHAR(150)							NOT NULL,
num					INT				CHECK(num > 0)			NOT NULL,
cep					CHAR(8)			CHECK(LEN(cep) = 8)		NULL
PRIMARY KEY(num_cadastro))
GO
CREATE TABLE filme_estrela(
filmeId				INT				NOT NULL,
estrelaId			INT				NOT NULL
FOREIGN KEY(filmeId) REFERENCES filme (id),
FOREIGN KEY(estrelaId) REFERENCES estrela (id))
GO
CREATE TABLE estrela(
id					INT				NOT NULL,
nome				VARCHAR(50)		NOT NULL
PRIMARY KEY(id))

ALTER TABLE estrela
ADD nome_real		VARCHAR(50)		NULL

ALTER TABLE filme
ALTER COLUMN titulo	VARCHAR(80)		NOT NULL

INSERT INTO filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interstelar', 2014),
(1004, 'A culpa é das estrelas', 2014),
(1005, 'Alexandre e o dia terrível, horrível, espantoso e horroroso', 2016),
(1006, 'Sing', 2016)

INSERT INTO estrela VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'), 
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Milles Teller', ''),
(9904, ' Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO dvd VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

INSERT INTO cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO locacao VALUES
(10001, 5502, GETDATE(), '2022-10-23', 3.50)

INSERT INTO locacao VALUES
(10009, 5502, GETDATE(), '2022-10-23', 3.50)

INSERT INTO locacao VALUES
(10002, 5503, GETDATE(), '2022-10-24', 3.50)

INSERT INTO locacao VALUES
(10002, 5505, GETDATE(), '2022-10-23', 3.00)

INSERT INTO locacao VALUES
(10004, 5505, GETDATE(), '2022-10-23', 3.00)

INSERT INTO locacao VALUES
(10005, 5505, GETDATE(), '2022-10-23', 3.00)

INSERT INTO locacao VALUES
(10001, 5501, GETDATE(), '2022-10-26', 3.50)

INSERT INTO locacao VALUES
(10008, 5501, GETDATE(), '2022-10-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE clienteNum_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE clienteNum_cadastro = 5501

UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela 
SET nome_real = 'Miles Alexander Teller'
WHERE nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'

SELECT titulo FROM filme
WHERE ano = 2014

SELECT id, ano FROM filme
WHERE titulo = 'Birdman'

SELECT id, ano FROM filme
WHERE titulo LIKE '%plash'

SELECT id, nome, nome_real FROM estrela
WHERE nome LIKE '%Steve%'

SELECT DISTINCT CONVERT(CHAR(10), data_fabricacao,103) AS fab, filmeId FROM dvd
WHERE data_fabricacao >= '2020-01-01'

SELECT dvdNum, CONVERT(CHAR(10), data_locacao, 103) AS data_locacao, CONVERT(CHAR(10), data_devolucao, 103) AS data_devolucao, valor, CAST(valor + 2.00 AS DECIMAL(7,2)) AS novo_valor FROM locacao
WHERE clienteNum_cadastro = 5505

SELECT logradouro, num, cep FROM cliente
WHERE nome = 'Matilde Luz'

SELECT nome_real FROM estrela
WHERE nome = 'Michael Keaton'

SELECT num_cadastro, nome, logradouro + ' ' + CAST(num AS VARCHAR(5)) + ' ' + cep AS end_completo FROM cliente
WHERE num_cadastro >= 5503


--Tarefa 25/10

SELECT DISTINCT id, ano, SUBSTRING(titulo, 1, 10)+'...' AS titulo FROM filme
WHERE id IN(
SELECT filmeId FROM dvd
WHERE data_fabricacao > '2020-01-01'
)

SELECT DISTINCT num, data_fabricacao, DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM dvd
WHERE filmeID IN(
SELECT id FROM filme
WHERE titulo = 'Interstelar'
)

SELECT DISTINCT dvdNum, data_locacao, data_devolucao, DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugados,
valor FROM locacao
WHERE clienteNum_cadastro IN(
SELECT num_cadastro FROM cliente
WHERE nome LIKE '%Rosa%'
)

SELECT DISTINCT nome, logradouro +' '+ CAST(numero AS VARCHAR(05)) AS end_completo, SUBSTRING(cep, 1, 5) +'-'+ SUBSTRING(cep, 5, 3) AS cep
FROM cliente
WHERE num_cadastro IN(
SELECT clienteNum_cadastro FROM locacao
WHERE dvdNum = 10002
)

--Tarefa 01/11

SELECT DISTINCT cl.num_cadastro, cl.nome, CONVERT(CHAR(10), lo.data_locacao, 103) AS data_locacao, DATEDIFF(DAY, lo.data_locacao, lo.data_devolucao) AS qtd_dias_alugado, f.titulo, f.ano
FROM filme f, locacao lo, cliente cl, dvd d
WHERE cl.nome LIKE '%Matilde%'
		AND cl.num_cadastro = lo.clienteNum_cadastro
			AND f.id = d.filmeId
				AND d.num = lo.dvdNum


SELECT es.nome, es.nome_real, f.titulo FROM estrela es, filme f, filme_estrela fe
WHERE es.id = fe.estrelaId
		AND f.id = fe.filmeId
			AND f.ano = 2015


SELECT DISTINCT f.titulo, CONVERT(CHAR(10), d.data_fabricacao, 103) AS data_fabricacao,
	CASE WHEN (2022 - f.ano) >= 6
	THEN
		CAST((2022 - f.ano) AS CHAR(4)) + ' anos'
	ELSE
		CAST((2022 - f.ano) AS CHAR(4))
	END AS anos
FROM filme f, dvd d
WHERE f.id = d.filmeId
