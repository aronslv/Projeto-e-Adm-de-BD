create view funcionarios_por_dept as 
	select count(f.nome) as total_funcionarios ,d.codigo as codDepto   from funcionario f
    	left join departamento d on d.codigo=f.codDepto
    	group by d.codigo;
select 
    d.descricao,
    f.nome AS gerente,
     COALESCE(fd.total_funcionarios, 0)
from departamento d
left join funcionario f on f.codigo = d.codGerente
left join funcionarios_por_dept fd on fd.codDepto = d.codigo;