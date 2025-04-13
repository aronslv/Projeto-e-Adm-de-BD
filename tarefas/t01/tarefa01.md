[Create](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-create.sql)

[Inserts](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-inserts.sql)

[Questão 01](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-q01.sql)

[Questão 04](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-q04.sql)

[Questão 07](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-q07.sql)

[Questão 10](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-q10.sql)

[Questão 13](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/t01/tarefa01-q13.sql)

# CROSS JOIN, NATURAL JOIN e Window Functions no PostgreSQL

## 🔀 CROSS JOIN

### 📚 O que é?

O `CROSS JOIN` é um tipo de junção que combina cada linha de uma tabela com todas as linhas de outra, gerando o produto cartesiano. Ele não exige condição de junção, o que pode resultar em um grande volume de dados.

### 🧠 Quando usar?

Use quando for necessário criar todas as combinações possíveis entre elementos de dois conjuntos. Por exemplo, variações de produtos com diferentes cores, tamanhos, estilos etc.

> ⚠️ Atenção: o `CROSS JOIN` pode ocorrer acidentalmente se você esquecer de colocar condições de junção em joins implícitos.

### 💻 Sintaxe:

```sql
SELECT *
FROM tabelaA
CROSS JOIN tabelaB;
```

### 🧪 Exemplo:

Considere:

**Tabela Sabores**

| sabor     |
|-----------|
| chocolate |
| baunilha  |

**Tabela Coberturas**

| cobertura        |
|------------------|
| granulado        |
| calda de morango |
| chantilly        |

Consulta:

```sql
SELECT * 
FROM Sabores 
CROSS JOIN Coberturas;
```

**Resultado:**

| sabor     | cobertura        |
|-----------|------------------|
| chocolate | granulado        |
| chocolate | calda de morango |
| chocolate | chantilly        |
| baunilha  | granulado        |
| baunilha  | calda de morango |
| baunilha  | chantilly        |

---

## 🌱 NATURAL JOIN

### 📚 O que é?

O `NATURAL JOIN` faz a junção entre duas tabelas automaticamente, com base em todas as colunas que tenham exatamente o mesmo nome e tipo em ambas. Ele retorna apenas as linhas onde os valores dessas colunas coincidem.

### ⚠️ Cuidados

Apesar de parecer prático, esse tipo de junção pode ser arriscado, pois depende da estrutura das tabelas. Se novas colunas com o mesmo nome forem adicionadas, o comportamento da junção muda — sem aviso de erro.

### 💻 Sintaxe:

```sql
SELECT *
FROM tabela1
NATURAL JOIN tabela2;
```

### 🧪 Exemplo:

Considere:

**Tabela Reservas**

| id_cliente | destino |
|------------|---------|
| 1          | Paris   |
| 2          | Londres |

**Tabela Clientes**

| id_cliente | nome        |
|------------|-------------|
| 1          | Ana Santos  |
| 2          | João Silva  |

Consulta:

```sql
SELECT * 
FROM Reservas 
NATURAL JOIN Clientes;
```

**Resultado:**

| id_cliente | destino | nome        |
|------------|---------|-------------|
| 1          | Paris   | Ana Santos  |
| 2          | Londres | João Silva  |

> ⚠️ Se ambas as tabelas também tivessem uma coluna chamada `data`, o `NATURAL JOIN` tentaria unir pelas duas, o que poderia causar erros lógicos.

---

## 🪟 Window Functions no PostgreSQL

### 📚 O que são?

Window Functions são funções analíticas que permitem realizar cálculos sobre uma "janela" de dados, ou seja, um subconjunto de linhas relacionadas à linha atual. Diferente do `GROUP BY`, elas não agrupam ou removem linhas, apenas adicionam novas colunas ao resultado.

### 🧠 Para que servem?

- Calcular médias, somas, contagens mantendo os dados originais
- Criar rankings e classificações
- Comparar valores com linhas anteriores ou seguintes

### 🧩 Cláusula `OVER()`

- `PARTITION BY`: Divide os dados em grupos, como por departamento ou categoria
- `ORDER BY`: Define a ordem das linhas dentro de cada grupo (importante para funções como `RANK`, `LAG`, `LEAD`)

---

### 💻 Exemplos

#### 1️⃣ Média por grupo (sem perder linhas)

```sql
SELECT 
  nome,
  departamento,
  salario,
  AVG(salario) OVER (PARTITION BY departamento) AS media_setor
FROM Funcionarios;
```

**Resultado:**

| nome        | departamento | salario | media_setor |
|-------------|--------------|---------|-------------|
| Aline Souza | RH           | 4000    | 4250        |
| Marcos Lima | RH           | 4500    | 4250        |
| João Meira  | TI           | 5000    | 5250        |
| Lara Costa  | TI           | 5500    | 5250        |

---

#### 2️⃣ Ranking de desempenho

```sql
SELECT 
  atleta,
  equipe,
  pontuacao,
  RANK() OVER (PARTITION BY equipe ORDER BY pontuacao DESC) AS posicao
FROM Resultados;
```

**Resultado:**

| atleta       | equipe | pontuacao | posicao |
|--------------|--------|-----------|---------|
| Júlia Prado  | Azul   | 96        | 1       |
| Caio Rocha   | Azul   | 92        | 2       |
| Tiago Nunes  | Verde  | 91        | 1       |
| Paula Morais | Verde  | 85        | 2       |

---

#### 3️⃣ Comparação com linha anterior

```sql
SELECT 
  mes,
  receita,
  receita - LAG(receita) OVER (ORDER BY mes) AS diferenca_mensal
FROM Faturamento;
```

**Resultado:**

| mes  | receita | diferenca_mensal |
|------|---------|------------------|
| jan  | 10000   | null             |
| fev  | 12000   | 2000             |
| mar  | 11000   | -1000            |
| abr  | 14000   | 3000             |

---

Essas funções são ideais para criar relatórios ricos e análises sem perder os detalhes linha a linha. Elas aumentam a capacidade analítica do SQL de forma poderosa e versátil.