# Análise de vendas com PostgreSQL

Projeto de análise de dados que modela um banco de vendas em PostgreSQL, gera dados simulados com Python e responde perguntas de negócio usando SQL.

> Os dados são **simulados** (gerados por script, com semente fixa), e não representam uma empresa real.

## Perguntas de negócio

- [x] Quais produtos geram mais faturamento?
- [ ] Qual o faturamento de cada vendedor?
- [ ] Como as vendas evoluem por mês? Existe sazonalidade?
- [ ] Qual o ticket médio por venda?
- [ ] Quem são os melhores clientes?

## Tecnologias

PostgreSQL 18, Python 3.13 (Faker, pandas, psycopg2), SQL, VS Code, Git.

## Modelo de dados

O banco tem 5 tabelas: `cliente`, `vendedor`, `produto`, `venda` e `item_venda`. Veja o diagrama em [docs/der.md](docs/der.md).

Decisão de modelagem: o `preco_venda` fica em `item_venda`, e não só em `produto`, para preservar o preço praticado em cada venda (descontos, promoções) mesmo que o preço de tabela mude depois.

## Como os dados foram gerados

O script `scripts/gerar_dados.py` cria 500 clientes, 10 vendedores, 15 produtos, 5.000 vendas e cerca de 12.500 itens. Para a análise ter o que mostrar, incluí de propósito:

- sazonalidade: mais vendas em novembro e dezembro;
- vendedores com desempenhos diferentes;
- descontos de 0% a 20% sobre o preço de tabela.

## Como rodar

```powershell
git clone [URL-DO-SEU-REPOSITORIO]
cd projeto-analise-vendas
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
copy .env.example .env
```

Edite o `.env` e coloque a senha do seu PostgreSQL. Depois:

```powershell
psql -U postgres -c "CREATE DATABASE projeto_analise_vendas;"
psql -U postgres -d projeto_analise_vendas -f sql/01_schema.sql
python scripts/gerar_dados.py
psql -U postgres -d projeto_analise_vendas -f sql/02_analises.sql
```

## Estrutura

```
sql/       schema e consultas de análise
scripts/   gerador de dados
docs/      diagrama entidade-relacionamento
```

## O que aprendi de PostgreSQL neste projeto

- **Um servidor, vários bancos.** Sem informar  `-d nome_do_banco`, o `psql` conecta no banco padrão `postgres`, e não no do projeto.
- **Paginador do `psql`.** O `-- Mais --` escondia as últimas linhas de um resultado. Resolvi com `\pset pager off`, que vale só para a sessão atual e precisa ser repetido ao abrir o `psql` de novo.


## Próximos passos

- Análises por vendedor, por mês e por cliente
- Notebooks em Python com gráficos
- Dashboard