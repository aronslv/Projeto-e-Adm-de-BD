from orm.django_orm import Projeto, Atividade
import datetime

def inserir_atividade_orm():
    print("\n--- 1. Inserindo nova atividade via ORM ---")
    try:
        projeto_es = Projeto.objects.get(codigo=4)

        nova_atividade = Atividade.objects.create(
            descricao="Elaboração Diagrama de Classes - ORM",
            projeto=projeto_es,
            data_inicio=datetime.date(2025, 11, 1),
            data_fim=datetime.date(2025, 11, 15)
        )
        print(f"Nova atividade '{nova_atividade.descricao}' (ID: {nova_atividade.codigo}) inserida com sucesso no projeto '{projeto_es.nome}'.")
    except Projeto.DoesNotExist:
        print(f"ERRO: Projeto com código 4 (ES) não encontrado para inserir atividade.")
    except Exception as e:
        print(f"ERRO ao inserir atividade via ORM: {e}")