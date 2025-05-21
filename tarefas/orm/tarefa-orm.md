# 📌 Recursos & Tarefas: ODBC e ORM em Python  

## 🔗 Links Úteis  
- [🐘 Script de Criação do Esquema (PostgreSQL)](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/database/scripts_db.sql)
- [📚 Programas Criado 1](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/scripts_prog/inserir_atividades.py)
- [📚 Programas Criado 2](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/scripts_prog/inserir_lider.py)
- [📚 Programas Criado 3](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/scripts_prog/selecionar_projetos.py)
- [🐍 Programa Python com pyodbc](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/obdc.py)
- [🦄 Programa Python com Django ORM](https://github.com/aronslv/Projeto-e-Adm.-de-BD/blob/main/tarefas/orm/django_orm.py)

---  

## 🎯 Tarefa – ODBC vs ORM em Python  

### 🔌 ODBC em Python  
**ODBC** (Open Database Connectivity) é uma API padrão da Microsoft para conectar aplicações a diversos bancos de dados. Com ela, você pode acessar diferentes SGBDs usando uma interface única!  

#### 🛠️ Componentes Necessários  
- **Driver ODBC**: Software específico para o banco de dados (ex: PostgreSQL, MySQL, SQL Server).  
- **String de Conexão ou DSN**:  
  - **🔤 String de Conexão**: Contém todos os detalhes da conexão em uma única string.  
  - **🏷️ DSN (Data Source Name)**: Nome configurado no sistema que guarda os parâmetros de conexão.  

#### ⚙️ Funcionamento com `pyodbc`  
python
import pyodbc

# Conectar ao banco (exemplo PostgreSQL)
conn = pyodbc.connect(
    "DRIVER={PostgreSQL Unicode};SERVER=localhost;"
    "DATABASE=atividade_db;UID=usuario;PWD=senha;"
)

# Criar cursor e executar SQL
cursor = conn.cursor()
cursor.execute("SELECT * FROM tabela")

# Inserir dados (com parâmetros seguros)
cursor.execute("INSERT INTO tabela (col1, col2) VALUES (?, ?)", "valor1", "valor2")
conn.commit()  # Persistir alterações!

# Fechar conexão
cursor.close()
conn.close()

### ✅ Vantagens do ODBC
- **🌐 Suporte amplo**  
    Compatível com múltiplos bancos de dados (PostgreSQL, MySQL, SQL Server, etc.).

- **🎮 Controle total**  
    Permite escrita direta de SQL, ideal para queries complexas ou otimizadas.

### ❌ Desvantagens do ODBC
- **⚙️ Configuração manual**  
    Requer instalação e configuração de drivers específicos para cada SGBD.

- **📜 Verbosidade**  
    Código mais extenso para operações CRUD básicas comparado a ORMs.

---

## 🏛️ ORM em Python (Django)

**ORM** (*Object-Relational Mapping*) é uma técnica que mapeia objetos Python para tabelas de banco de dados, substituindo SQL puro por classes e métodos! ✨

### 🎩 Principais Conceitos no Django ORM

#### 1️⃣ **Models (models.py)**
Define a estrutura do banco de dados usando classes Python:
python
from django.db import models

class Departamento(models.Model):
    nome = models.CharField(max_length=100)
    sigla = models.CharField(max_length=10, unique=True)

class Funcionario(models.Model):
    nome = models.CharField(max_length=150)
    salario = models.DecimalField(max_digits=10, decimal_places=2)  # 💰 Campo monetário
    depto = models.ForeignKey(Departamento, on_delete=models.SET_NULL, null=True)  # 🔗 Relação

### ✅ Vantagens do Django ORM
- **🐍 Código Pythonico**
    Sintaxe intuitiva e alinhada com a filosofia Python.

- **🛡️ Segurança integrada**
    Prevenção automática contra SQL injection.

- **🔄 Migrações automáticas**
    Controle versionado do esquema do banco.

### ❌ Desvantagens do Django ORM
- **🐢 Performance**
    Pode gerar queries não otimizadas para operações complexas.

- **📚 Curva de aprendizado**
    Exige domínio de conceitos como QuerySets, managers e signals.

- **🔮 "Mágica" implícita**
    Comportamentos automáticos podem dificultar o debug.