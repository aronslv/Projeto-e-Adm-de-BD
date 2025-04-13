SELECT f.nome
FROM funcionario f
WHERE f.salario > ALL (
    SELECT salario
    FROM funcionario
    WHERE codDepto = 2
);