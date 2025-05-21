DROP TABLE IF EXISTS atividade CASCADE;
DROP TABLE IF EXISTS projeto CASCADE;
DROP TABLE IF EXISTS departamento CASCADE;
DROP TABLE IF EXISTS funcionario CASCADE;

-- Criação das Tabelas

CREATE TABLE funcionario (
    codigo SERIAL,
    nome VARCHAR(150),
    sexo CHAR(1),
    dt_nasc DATE,
    salario MONEY, -- Atenção: MONEY é um tipo específico do PostgreSQL, pode ter particularidades. Decimal(10,2) é mais portável.
    supervisor INT,
    depto INT,
    PRIMARY KEY (codigo),
    FOREIGN KEY (supervisor) REFERENCES funcionario(codigo) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE departamento (
    codigo SERIAL,
    nome VARCHAR(100),
    sigla VARCHAR(10) UNIQUE,
    descricao VARCHAR(250),
    gerente INT,
    PRIMARY KEY (codigo),
    FOREIGN KEY (gerente) REFERENCES funcionario(codigo) ON DELETE SET NULL ON UPDATE CASCADE
);

-- add foreign key de funcionario
ALTER TABLE funcionario ADD CONSTRAINT funcDeptoFK FOREIGN KEY (depto) REFERENCES departamento(codigo) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE projeto (
    codigo SERIAL,
    nome VARCHAR(50) UNIQUE,
    descricao VARCHAR(250),
    responsavel INT,
    depto INT,
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (codigo),
    FOREIGN KEY (responsavel) REFERENCES funcionario(codigo) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (depto) REFERENCES departamento(codigo) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE atividade (
    codigo SERIAL,
    descricao VARCHAR(250),
    projeto INT,
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (codigo),
    FOREIGN KEY (projeto) REFERENCES projeto(codigo) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Povoamento Inicial
-- Adicionando Departamentos
INSERT INTO departamento
(sigla, nome, descricao, gerente) VALUES -- Adicionei a coluna 'nome' que estava faltando no seu insert original, baseado na sua tabela
('DHC', 'Dep. História', 'Departamento de História da Instituição', NULL),
('DCT', 'Dep. Computação', 'Departamento de Ciência da Computação', NULL),
('DGC', 'Dep. Geografia', 'Departamento de Geografia e Cartografia', NULL),
('DIR', 'Dep. Direito', 'Departamento de Ciências Jurídicas', NULL);


-- Adicionando Funcionários Gerentes
INSERT INTO funcionario
(nome, sexo, dt_nasc, salario, supervisor, depto)
VALUES ('Ana', 'F', '1988-05-07', 2500.00, NULL, 1); -- Ana, depto 1 (DHC)

INSERT INTO funcionario
(nome, sexo, dt_nasc, salario, supervisor, depto)
VALUES ('Taciano', 'M', '1980-01-25', 2500.00, NULL, 2); -- Taciano, depto 2 (DCT)

-- Adicionando Gerentes aos Departamentos (os códigos 1 e 2 são dos funcionários acima)
UPDATE departamento SET gerente = 1 WHERE sigla = 'DHC';
UPDATE departamento SET gerente = 2 WHERE sigla = 'DCT';

-- Adicionando Funcionários
INSERT INTO funcionario
(nome, sexo, dt_nasc, salario, supervisor, depto)
VALUES
('Maria', 'F', '1981-07-01', 2500.00, 1, 1),        -- Supervisora Ana (cod 1), depto DHC (cod 1)
('Josefa', 'F', '1986-09-17', 2500.00, 1, 1),       -- Supervisora Ana (cod 1), depto DHC (cod 1)
('Carlos', 'M', '1985-11-21', 2500.00, 1, 1),       -- Supervisor Ana (cod 1), depto DHC (cod 1)
('José', 'M', '1979-07-12', 3500.00, 2, 2),         -- Supervisor Taciano (cod 2), depto DCT (cod 2)
('Gabriel', 'M', '1981-08-11', 1850.00, NULL, 3),   -- Sem supervisor, depto DGC (cod 3)
('Margarete', 'F', '1992-03-22', 4500.00, NULL, 3), -- Sem supervisora, depto DGC (cod 3). Assumindo que ela seja gerente do DGC, o update do gerente para DGC não foi feito.
('José Funcionário Outro', 'M', '1979-07-12', 3500.00, (SELECT codigo FROM funcionario WHERE nome = 'Gabriel'), NULL), -- Supervisor Gabriel, sem depto
('Xuxa', 'F', '1970-03-28', 13500.00, NULL, NULL),     -- Sem supervisor, sem depto
('Sasha', 'F', '1970-03-28', 1500.00, (SELECT codigo FROM funcionario WHERE nome = 'Xuxa'), 3), -- Supervisora Xuxa, depto DGC (cod 3)
('Victor', 'M', '1970-03-28', 500.00, 2, 1),        -- Supervisor Taciano (cod 2), depto DHC (cod 1)
('Humberto', 'M', '1970-05-07', 1500.00, 2, 2),      -- Supervisor Taciano (cod 2), depto DCT (cod 2)
('Doisberto', 'M', '1980-07-14', 2500.00, (SELECT codigo FROM funcionario WHERE nome = 'Gabriel'), 3), -- Supervisor Gabriel, depto DGC (cod 3)
('Tresberta', 'F', '1992-09-01', 3000.00, (SELECT codigo FROM funcionario WHERE nome = 'Carlos'), 3); -- Supervisor Carlos, depto DGC (cod 3)

-- Adicionando Projetos
INSERT INTO projeto
(nome, descricao, depto, responsavel, data_inicio, data_fim)
VALUES
('APF', 'Analisador de Ponto de Função', 2, 2, '2018-02-26', '2019-06-30'), -- Depto DCT (cod 2), Responsável Taciano (cod 2)
('Monitoria', 'Projeto de Monitoria 2019.1', 1, (SELECT codigo FROM funcionario WHERE nome = 'José'), '2019-02-26', '2019-12-30'), -- Depto DHC (cod 1), Responsável José (cod 4)
('BD', 'Projeto de Banco de Dados', 3, (SELECT codigo FROM funcionario WHERE nome = 'Carlos'), '2018-02-26', '2018-06-30'), -- Depto DGC (cod 3), Responsável Carlos (cod 5)
('ES', 'Projeto de Engenharia de Software', 1, 1, '2018-02-26', '2018-06-30'); -- Depto DHC (cod 1), Responsável Ana (cod 1)

-- Adicionando Atividades
INSERT INTO atividade
(descricao, projeto, data_inicio, data_fim)
VALUES
('APF - Atividade 1', 1, '2018-02-26', '2018-06-30'),
('APF - Atividade 2', 1, '2018-06-26', '2018-07-30'),
('APF - Atividade 3', 1, '2018-08-26', '2018-09-30'),
('APF - Atividade 4', 1, '2018-08-26', '2018-09-30'),
('APF - Atividade 5', 1, '2018-09-30', '2018-10-30'),
('Monitoria - Atividade 1', 2, '2018-06-26', '2018-07-30'),
('BD - Atividade 1', 3, '2018-06-26', '2018-07-30'),
('BD - Atividade 2', 3, '2018-08-26', '2018-09-30'),
('BD - Atividade 3', 3, '2018-08-26', '2018-09-30'),
('ES - Atividade 1', 4, '2018-09-30', '2018-10-30'),
('ES - Atividade 2', 4, '2018-06-26', '2018-07-30');