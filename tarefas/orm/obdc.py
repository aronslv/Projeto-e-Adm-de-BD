import pyodbc
import sys
import os
import logging
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(level=logging.INFO, format="%(message)s")

driver = os.getenv("DB_DRIVER")
server = os.getenv("DB_SERVER")
port = os.getenv("DB_PORT")
database = os.getenv("DB_DATABASE")
user = os.getenv("DB_USERNAME")
password = os.getenv("DB_PASSWORD")

if not all([driver, server, port, database, user, password]):
    logging.error("ERRO: Variáveis de ambiente ausentes.")
    sys.exit(1)

dsn = (
    f"DRIVER={driver};"
    f"SERVER={server};"
    f"PORT={port};"
    f"DATABASE={database};"
    f"UID={user};"
    f"PWD={password};"
)

conn = None
try:
    logging.info(f"Conectando ao banco '{database}' no servidor '{server}'...")
    conn = pyodbc.connect(dsn)
    logging.info("Conexão estabelecida com sucesso.")

    cur = conn.cursor()
    logging.info("Departamentos disponíveis:")
    cur.execute("SELECT codigo, nome, sigla FROM departamento ORDER BY nome;")
    registros = cur.fetchall()

    if not registros:
        logging.info("Nenhum registro encontrado.")
    else:
        for dep in registros:
            logging.info(f" - Código: {dep.codigo}, Nome: {dep.nome}, Sigla: {dep.sigla}")

    try:
        desc = "Reunião de Definição de Escopo Adicional"
        proj_id = 1
        ini = "2025-07-01"
        fim = "2025-07-05"

        cur.execute(
            "INSERT INTO atividade (descricao, projeto, data_inicio, data_fim) VALUES (?, ?, ?, ?);",
            desc, proj_id, ini, fim
        )
        conn.commit()
        logging.info(f"Atividade '{desc}' inserida no projeto {proj_id}.")

    except pyodbc.Error as err:
        logging.error(f"Erro inserindo atividade: {err}")
        if conn:
            conn.rollback()

    try:
        proj_id = 2
        novo_lider = 3

        cur.execute("SELECT responsavel FROM projeto WHERE codigo = ?", proj_id)
        anterior = cur.fetchone()
        if anterior:
            logging.info(f"Líder anterior: {anterior[0]}")
        else:
            logging.info(f"Projeto {proj_id} não encontrado.")

        cur.execute("UPDATE projeto SET responsavel = ? WHERE codigo = ?", novo_lider, proj_id)
        if cur.rowcount > 0:
            conn.commit()
            logging.info(f"Líder atualizado para ID {novo_lider}.")
            cur.execute("SELECT responsavel FROM projeto WHERE codigo = ?", proj_id)
            novo = cur.fetchone()
            if novo:
                logging.info(f"Novo líder: {novo[0]}")
        else:
            logging.info("Nenhuma atualização realizada.")

    except pyodbc.Error as err:
        logging.error(f"Erro ao atualizar líder: {err}")
        if conn:
            conn.rollback()

    try:
        cur.execute("""
            SELECT p.codigo, p.nome, a.codigo, a.descricao, a.data_inicio, a.data_fim
            FROM projeto p
            LEFT JOIN atividade a ON p.codigo = a.projeto
            ORDER BY p.nome, a.data_inicio;
        """)

        resultado = {}
        for row in cur.fetchall():
            proj = resultado.setdefault(row.codigo, {"nome": row.nome, "atividades": []})
            if row[2]:
                proj["atividades"].append(f"  - AtivID {row[2]}: {row[3]} (Início: {row[4]}, Fim: {row[5]})")

        if not resultado:
            logging.info("Nenhum projeto encontrado.")
        else:
            for pid, dados in resultado.items():
                logging.info(f"\nProjeto: {dados['nome']} (ID: {pid})")
                if dados["atividades"]:
                    for atv in dados["atividades"]:
                        logging.info(atv)
                else:
                    logging.info("  - Sem atividades.")

    except pyodbc.Error as err:
        logging.error(f"Erro ao listar projetos: {err}")

    cur.close()

except pyodbc.Error as err:
    logging.error(f"Falha na conexão ou execução: {err}")
    if conn:
        conn.close()
    sys.exit(1)

finally:
    if conn:
        logging.info("\nEncerrando conexão com o banco.")
        conn.close()
