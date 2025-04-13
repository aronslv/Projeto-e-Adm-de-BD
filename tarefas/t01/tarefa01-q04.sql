create view todos_gerentes as
SELECT d.codGerente
    FROM departamento d
    WHERE d.codGerente IS NOT NULL;

SELECT f.nome, f.salario,f.codigo
FROM funcionario f
JOIN departamento d ON f.codDepto = d.codigo
WHERE f.codigo NOT IN (
    SELECT * from todos_gerentes
)
ORDER BY d.codigo;