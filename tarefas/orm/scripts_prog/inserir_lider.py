from orm.django_orm import Projeto, Funcionario

def atualizar_lider_projeto_orm():
    print("\n--- 2. Atualizando líder de projeto via ORM ---")
    try:
        projeto_apf = Projeto.objects.get(codigo=1)
        novo_lider_carlos = Funcionario.objects.get(codigo=5)

        responsavel_antigo_nome = projeto_apf.responsavel.nome if projeto_apf.responsavel else "Nenhum"
        print(f"Líder antigo do projeto '{projeto_apf.nome}': {responsavel_antigo_nome}")

        projeto_apf.responsavel = novo_lider_carlos
        projeto_apf.save()

        print(f"Líder do projeto '{projeto_apf.nome}' atualizado para '{novo_lider_carlos.nome}' com sucesso.")
    except Projeto.DoesNotExist:
        print(f"ERRO: Projeto com código 1 (APF) não encontrado.")
    except Funcionario.DoesNotExist:
        print(f"ERRO: Funcionário com código 5 (Carlos) não encontrado.")
    except Exception as e:
        print(f"ERRO ao atualizar líder do projeto via ORM: {e}")