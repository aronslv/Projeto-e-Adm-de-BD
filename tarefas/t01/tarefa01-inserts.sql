INSERT INTO funcionario (nome, sexo, dtNasc, salario, codDepto) VALUES
('Aron Silva', 'M', '2004-10-01', 5000.00, 1),
('Pedro Lucas', 'M', '2005-08-04', 7600.00, 2),
('Ana Alice', 'F', '2005-01-29', 6000.00, 3),
('Yasmin Dantas', 'F', '2006-12-01', 8100.00, 4),
('Enrique Falcão', 'M', '2005-07-22', 6500.00, 5);

INSERT INTO departamento (descricao) VALUES
('Logística'),
('Tecnologia de Informação'),
('Gente e Gestão'),
('Vendas'),
('Financeiro');

UPDATE departamento SET codGerente = 1 WHERE codigo = 1;
UPDATE departamento SET codGerente = 2 WHERE codigo = 2;
UPDATE departamento SET codGerente = 3 WHERE codigo = 3;
UPDATE departamento SET codGerente = 4 WHERE codigo = 4;
UPDATE departamento SET codGerente = 5 WHERE codigo = 5;

INSERT INTO projeto (nome, descricao, codDepto, codResponsavel, dataInicio, dataFim) VALUES
('Sistema de Entregas', 'Plataforma para controle de entregas', 1, 1, '2025-01-01', '2025-06-01'),
('Sistema de Banco de Dados', 'Sistema para gestão de dados', 2, 2, '2025-02-01', '2025-07-01'),
('Vivendo Melhor', 'Sistema de gestão de atividades para colaboradores', 3, 3, '2025-03-01', '2025-08-01'),
('Atendimento ao Cliente', 'Plataforma para comunicação de vendas', 4, 4, '2025-04-01', '2025-09-01'),
('Sistema de Pagamentos', 'Controle de transações financeiras', 5, 5, '2025-05-01', '2025-10-01');

INSERT INTO atividade (nome, descricao, codResponsavel, dataInicio, dataFim) VALUES
('Coleta de Infos de Frota', 'Entrevistas e coleta de dados', 1, '2025-01-05', '2025-01-20'),
('Direcionar para um BD', 'Alinhar os dados para um BD próprio', 2, '2025-02-05', '2025-02-15'),
('Conseguir Patrocínios', 'Pontos de benefícios para os colaboradores', 3, '2025-03-05', '2025-03-20'),
('CRUDs de Cadastro dos Clientes', 'Juntar informações para cadastro de clientes', 4, '2025-04-05', '2025-04-25'),
('Análise Financeira', 'Avaliação de custos e receitas', 5, '2025-05-05', '2025-05-20');

INSERT INTO atividade_projeto (cod_projeto, cod_atividade) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);