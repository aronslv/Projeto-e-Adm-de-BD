WITH DetalhesAtivProj AS (
    SELECT
        p.nome AS nome_projeto,
        p.data_inicio AS inicio_projeto,
        p.data_fim AS fim_projeto,
        a.nome AS nome_atividade,
        a.data_inicio AS inicio_atividade,
        a.data_fim AS fim_atividade
    FROM
        projeto p
    INNER JOIN atividade_projeto ap 
        ON p.codigo = ap.cod_projeto
    INNER JOIN atividade a 
        ON ap.cod_atividade = a.codigo
)

SELECT
    nome_projeto,
    inicio_projeto,
    fim_projeto,
    nome_atividade,
    inicio_atividade,
    fim_atividade
FROM
    DetalhesAtivProj
WHERE
    inicio_atividade < inicio_projeto 
    OR fim_atividade > fim_projeto
ORDER BY
    nome_projeto,
    nome_atividade;