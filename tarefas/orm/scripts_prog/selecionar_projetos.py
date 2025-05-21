from orm.django_orm import Projeto, Atividade

def listar_projetos_atividades_orm():
    print("\n--- 3. Listando todos os projetos e suas atividades via ORM ---")
    try:
        todos_projetos = Projeto.objects.prefetch_related('atividades_do_projeto', 'responsavel', 'depto__gerente').all().order_by('nome')

        if not todos_projetos:
            print("Nenhum projeto encontrado.")
        else:
            for p in todos_projetos:
                lider_nome = p.responsavel.nome if p.responsavel else "N/A"
                depto_sigla = p.depto.sigla if p.depto else "N/A"
                gerente_depto_nome = "N/A"
                if p.depto and p.depto.gerente:
                    gerente_depto_nome = p.depto.gerente.nome

                print(f"\nProjeto: {p.nome} (ID: {p.codigo}) - Depto: {depto_sigla} (Gerente: {gerente_depto_nome}) - Líder Proj: {lider_nome}")

                atividades = p.atividades_do_projeto.all().order_by('data_inicio', 'codigo')
                if atividades:
                    for a in atividades:
                        print(f"  - AtivID {a.codigo}: {a.descricao} (Início: {a.data_inicio}, Fim: {a.data_fim})")
                else:
                    print("  - (Nenhuma atividade cadastrada para este projeto)")
    except Exception as e:
        print(f"ERRO ao listar projetos e atividades via ORM: {e}")
