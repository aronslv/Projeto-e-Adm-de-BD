import os
import django
from django.conf import settings
from django.db import models
from dotenv import load_dotenv
import datetime

dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)
else:
    project_root_env_path = os.path.join(os.path.dirname(__file__), '../.env')
    if os.path.exists(project_root_env_path):
        load_dotenv(project_root_env_path)
    else:
        print("Aviso: arquivo .env não encontrado nos caminhos esperados.")

if not settings.configured:
    DB_ENGINE = 'django.db.backends.postgresql'
    DB_NAME = os.getenv("DB_DATABASE")
    DB_USER = os.getenv("DB_USERNAME")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_SERVER")
    DB_PORT = os.getenv("DB_PORT")

    if not all([DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT]):
        print("ERRO: Variáveis de ambiente do banco de dados não estão completamente definidas.")
        print("Verifique: DB_DATABASE, DB_USERNAME, DB_PASSWORD, DB_SERVER, DB_PORT")
        exit()

    settings.configure(
        DATABASES={
            'default': {
                'ENGINE': DB_ENGINE,
                'NAME': DB_NAME,
                'USER': DB_USER,
                'PASSWORD': DB_PASSWORD,
                'HOST': DB_HOST,
                'PORT': DB_PORT,
            }
        },
        INSTALLED_APPS=[
            '__main__',
        ],
        USE_TZ=False,
    )
    django.setup()

class Departamento(models.Model):
    codigo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100, null=True, blank=True)
    sigla = models.CharField(max_length=10, unique=True)
    descricao = models.CharField(max_length=250, null=True, blank=True)

    def __str__(self):
        return f"{self.sigla} - {self.nome if self.nome else 'Sem Nome'}"

    class Meta:
        db_table = 'departamento'
        managed = False

class Funcionario(models.Model):
    codigo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=150)
    sexo = models.CharField(max_length=1, null=True, blank=True)
    dt_nasc = models.DateField(null=True, blank=True)
    salario = models.DecimalField(max_digits=19, decimal_places=2, null=True, blank=True)
    supervisor = models.ForeignKey('self', on_delete=models.SET_NULL, null=True, blank=True, related_name='subordinados', db_column='supervisor')
    depto = models.ForeignKey(Departamento, on_delete=models.SET_NULL, null=True, blank=True, related_name='funcionarios_do_depto', db_column='depto')

    def __str__(self):
        return self.nome

    class Meta:
        db_table = 'funcionario'
        managed = False

Departamento.add_to_class('gerente', models.ForeignKey(Funcionario, on_delete=models.SET_NULL, null=True, blank=True, related_name='departamento_gerenciado_por_mim', db_column='gerente'))

class Projeto(models.Model):
    codigo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=50, unique=True)
    descricao = models.CharField(max_length=250, null=True, blank=True)
    responsavel = models.ForeignKey(Funcionario, on_delete=models.SET_NULL, null=True, blank=True, related_name='projetos_liderados', db_column='responsavel')
    depto = models.ForeignKey(Departamento, on_delete=models.SET_NULL, null=True, blank=True, related_name='projetos_do_depto', db_column='depto')
    data_inicio = models.DateField(null=True, blank=True)
    data_fim = models.DateField(null=True, blank=True)

    def __str__(self):
        return self.nome

    class Meta:
        db_table = 'projeto'
        managed = False

class Atividade(models.Model):
    codigo = models.AutoField(primary_key=True)
    descricao = models.CharField(max_length=250)
    projeto = models.ForeignKey(Projeto, on_delete=models.SET_NULL, null=True, blank=True, related_name='atividades_do_projeto', db_column='projeto')
    data_inicio = models.DateField(null=True, blank=True)
    data_fim = models.DateField(null=True, blank=True)

    def __str__(self):
        return self.descricao

    class Meta:
        db_table = 'atividade'
        managed = False


