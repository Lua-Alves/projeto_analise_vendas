import os
import random
from datetime import date, timedelta

import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv
from faker import Faker

load_dotenv()
fake = Faker("pt_BR")
random.seed(42)

conn = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
)

produtos = [
    ("Notebook", 3000.00), ("Mouse", 50.00), ("Teclado", 150.00),
    ("Monitor 24 pol", 900.00), ("Headset", 220.00), ("Webcam", 180.00),
    ("Cadeira gamer", 1100.00), ("Mesa de escritório", 650.00),
    ("SSD 1TB", 420.00), ("Pen drive 64GB", 45.00), ("Impressora", 780.00),
    ("Roteador Wi-Fi", 250.00), ("Smartphone", 2200.00),
    ("Tablet", 1500.00), ("Carregador portátil", 120.00),
]

QTD_CLIENTES = 500
QTD_VENDEDORES = 10
QTD_VENDAS = 5000
INICIO = date(2024, 1, 1)
FIM = date(2026, 9, 29)


def data_aleatoria():
    dias = (FIM - INICIO).days
    while True:
        d = INICIO + timedelta(days=random.randint(0, dias))
        if d.month in (11, 12) or random.random() < 0.5:
            return d


with conn:
    with conn.cursor() as cur:
        cur.execute(
            "truncate item_venda, venda, vendedor, produto, cliente "
            "restart identity cascade;"
        )

        clientes = [(f"{fake.first_name()} {fake.last_name()}",) for _ in range(QTD_CLIENTES)]
        execute_values(cur, "insert into cliente (nome_cliente) values %s", clientes)

        vendedores = [(f"{fake.first_name()} {fake.last_name()}",) for _ in range(QTD_VENDEDORES)]
        execute_values(cur, "insert into vendedor (nome_vendedor) values %s", vendedores)

        linhas = [(nome, preco, random.randint(5, 200)) for nome, preco in produtos]
        execute_values(
            cur,
            "insert into produto (nome_produto, preco_atual, quantidade_estoque) values %s",
            linhas,
        )

        pesos_vendedores = [5, 4, 3, 3, 2, 2, 2, 1, 1, 1]
        vendas = [
            (
                random.randint(1, QTD_CLIENTES),
                random.choices(range(1, QTD_VENDEDORES + 1), weights=pesos_vendedores)[0],
                data_aleatoria(),
            )
            for _ in range(QTD_VENDAS)
        ]
        ids_vendas = execute_values(
            cur,
            "insert into venda (id_cliente, id_vendedor, data_venda) values %s returning id_venda",
            vendas,
            fetch=True,
        )

        itens = []
        for (id_venda,) in ids_vendas:
            qtd_itens = random.randint(1, 4)
            for idx in random.sample(range(len(produtos)), qtd_itens):
                preco_tabela = produtos[idx][1]
                desconto = random.choice([0, 0, 0, 0.05, 0.10, 0.15, 0.20])
                preco_venda = round(preco_tabela * (1 - desconto), 2)
                quantidade = random.randint(1, 5) if preco_tabela <= 200 else random.randint(1, 2)
                itens.append((id_venda, idx + 1, preco_venda, quantidade))

        execute_values(
            cur,
            "insert into item_venda (id_venda, id_produto, preco_venda, quantidade) values %s",
            itens,
        )

conn.close()
print("Dados carregados: clientes, vendedores, produtos, vendas e itens.")