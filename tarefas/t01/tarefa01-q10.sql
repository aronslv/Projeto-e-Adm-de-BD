select p.nome AS nome_projeto,d.descricao,f.nome from projeto p
left join funcionario f on f.codigo=p.cod_responsavel 
left join departamento d on p.codDepto=d.codigo;
ORDER BY nome_projeto;

