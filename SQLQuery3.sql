CREATE DATABASE projeto
GO
USE projeto
GO

CREATE TABLE projects(
id				INT				IDENTITY(10001, 1)						NOT NULL,
nome			VARCHAR(45)												NOT NULL,
descricao		VARCHAR(45)												NOT NULL,
data_projeto	DATE			CHECK(data_projeto > '2014-09-01')		NOT NULL
PRIMARY KEY(id))
GO
CREATE TABLE users(
id				INT				IDENTITY(1, 1)			NOT NULL,
nome			VARCHAR(45)								NOT NULL,
username		VARCHAR(45)		UNIQUE					NOT NULL,
senha			VARCHAR(45)		DEFAULT('123mudar')		NOT NULL,
email			VARCHAR(45)								NOT NULL
PRIMARY KEY(id))
GO
CREATE TABLE users_has_projects(
usersId			INT				NOT NULL,
projectsId		INT				NOT NULL
FOREIGN KEY(usersId) REFERENCES users (id),
FOREIGN KEY(projectsId) REFERENCES projects(id))

DBCC CHECKIDENT ('projects', RESEED, 10001)

DBCC CHECKIDENT ('users', RESEED, 1)

ALTER TABLE users
ALTER COLUMN username	VARCHAR(10)		NOT NULL

ALTER TABLE users
ALTER COLUMN senha		VARCHAR(8)		NOT NULL

INSERT INTO users (nome, username, email) VALUES
('Maria', 'Rh_maria', 'maria@empresa.com')

INSERT INTO users (nome, username, senha, email) VALUES
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO users (nome, username, email) VALUES
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users (nome, username, senha, email) VALUES
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

ALTER TABLE projects
ALTER COLUMN descricao		VARCHAR(45)			NULL

INSERT INTO projects (nome, descricao, data_projeto) VALUES
('Re-folha', 'Refatoração das folhas', '2014-09-04'),
('Manutenção PCs', 'Manutenção PCs', '2014-09-06'),
('Auditoria', NULL, '2014-09-07')

INSERT INTO users_has_projects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

UPDATE projects
SET data_projeto = '2014-09-12'
WHERE nome = 'Manutenção PCs'

UPDATE users
SET username = 'Rh_cido'
WHERE nome = 'Aparecido'

UPDATE users
SET senha = '888@*'
WHERE username = 'Rh_maria'

DELETE users_has_projects
WHERE usersId = 2


--Tarefa 25/10


SELECT id, nome, email, username,
		CASE WHEN senha = '123mudar'
		THEN
		senha
		ELSE
		'********'
		END AS senha
FROM users

SELECT nome, descricao, data_projeto, '2014-09-19' AS data_final FROM projects
WHERE id IN(
SELECT projectsId FROM users_has_projects
WHERE usersId IN(
SELECT id FROM users
WHERE email = 'aparecido@empresa.com'
)
)

SELECT email FROM users
WHERE id IN(
SELECT usersId FROM users_has_projects
WHERE projectsId IN(
SELECT id FROM projects
WHERE nome = 'Auditoria'
)
)


SELECT nome, descricao, data_projeto, '2014-09-16' AS data_final, 79.85 AS custo_total FROM projects
WHERE nome LIKE '%Manutenção%'


--Tarefa 01/11

INSERT INTO users VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO projects VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')

SELECT us.id AS user_id, us.nome AS user_name, us.email, pr.id AS project_id, pr.nome AS project_name, pr.descricao, CONVERT(CHAR(10), pr.data_projeto, 103) AS data_projeto FROM users us, projects pr, users_has_projects up
WHERE us.id = up.usersId
		AND pr.id = up.projectsId
			AND pr.nome = 'Re-folha'

SELECT pr.nome FROM projects pr, users us, users_has_projects up
WHERE pr.id = up.projectsId
		AND us.id = up.usersId
			AND up.usersId IS NULL

SELECT us.nome FROM users us, users_has_projects up, projects pr
WHERE pr.id = up.projectsId
		AND us.id = up.usersId
			AND up.projectsId IS NULL


