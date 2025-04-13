SET FOREIGN_KEY_CHECKS=0;

drop table if exists atividade cascade;
drop table if exists projeto cascade;
drop table if exists departamento cascade;
drop table if exists funcionario cascade;

SET FOREIGN_KEY_CHECKS=1; 

# Criação das Tabelas

CREATE TABLE funcionario (
	codigo int AUTO_INCREMENT,
	nome varchar(50),
	sexo char(1),
	dtNasc date,
	salario decimal(10,2),
	codDepto int,
	PRIMARY KEY (codigo),
	FOREIGN KEY (codDepto) REFERENCES departamento(codigo) on delete set null on update cascade
);

CREATE TABLE departamento (
	codigo int AUTO_INCREMENT,
	descricao varchar(50),
	codGerente int,
	PRIMARY KEY (codigo),
	FOREIGN KEY (codGerente) REFERENCES funcionario(codigo) on delete set null on update cascade
);

CREATE TABLE projeto (
	codigo int AUTO_INCREMENT,
	nome varchar(50),
	descricao varchar(250),
    codDepto int,
	codResponsavel int,
	dataInicio date, 
	dataFim date,
	PRIMARY KEY (codigo),
	UNIQUE KEY projNome (nome),
	FOREIGN KEY (codDepto) REFERENCES departamento(codigo) on delete set null on update cascade,
    FOREIGN KEY (codResponsavel) REFERENCES funcionario(codigo) on delete set null on update cascade
);
 
CREATE TABLE atividade (
	codigo int AUTO_INCREMENT,
    nome varchar(50),
	descricao varchar(250),
    codResponsavel int,
	dataInicio date, 
	dataFim date,
	PRIMARY KEY (codigo),
	FOREIGN KEY (codResponsavel) REFERENCES funcionario(codigo) on delete set null on update cascade
);

CREATE TABLE atividade_projeto (
    codProjeto int,
    codAtividade int,
    PRIMARY KEY (codProjeto, codAtividade)
    FOREIGN KEY (codProjeto) REFERENCES projeto(codigo) on delete set null on update cascade,
    FOREIGN KEY (codAtividade) REFERENCES atividade(codigo) on delete set null on update cascade
);