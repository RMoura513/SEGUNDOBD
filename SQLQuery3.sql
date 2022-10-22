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
('Ana', 'Rh_ana', 'ana_empresa'),
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