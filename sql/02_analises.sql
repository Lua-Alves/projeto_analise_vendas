-- Análise 1: faturamento por produto
-- Pergunta: quais produtos geram mais faturamento?
select p.nome_produto,
       sum(i.preco_venda * i.quantidade) as faturamento
from item_venda i
join produto p on i.id_produto = p.id_produto
group by p.nome_produto
order by faturamento desc;

-- Análise 2: faturamento e número de vendas por vendedor
-- Pergunta: quem vende mais?
select vd.id_vendedor,
       vd.nome_vendedor,
       count(distinct v.id_venda)        as vendas,
       sum(i.preco_venda * i.quantidade) as faturamento
from item_venda i
join venda v     on v.id_venda    = i.id_venda
join vendedor vd on v.id_vendedor = vd.id_vendedor
group by vd.id_vendedor, vd.nome_vendedor
order by faturamento desc;

-- Análise 3: vendas por mês
-- Pergunta: como as vendas evoluem ao longo do tempo? Existe sazonalidade?
select to_char(data_venda, 'YYYY-MM') as mes, count(*) as vendas
from venda
group by 1
order by 1;

-- Análise 4: faturamento por mês
-- Pergunta: em quais meses a empresa fatura mais?
select to_char(v.data_venda, 'YYYY-MM') as mes,
       sum(i.preco_venda * i.quantidade) as faturamento
from item_venda i
join venda v on v.id_venda = i.id_venda
group by 1
order by 1;

-- Análise 5: os 10 clientes que mais gastaram
-- Pergunta: quem são os melhores clientes?
select cli.id_cliente,
       cli.nome_cliente,
       sum(i.preco_venda * i.quantidade) as faturamento
from item_venda i
join venda v      on v.id_venda   = i.id_venda
join cliente cli  on v.id_cliente = cli.id_cliente
group by cli.id_cliente, cli.nome_cliente
order by faturamento desc
limit 10;

-- Análise 6: ticket médio
-- Pergunta: quanto cada venda rende, em média?
select round(sum(i.preco_venda * i.quantidade) / count(distinct i.id_venda), 2) as ticket_medio
from item_venda i;

-- Análise 7: desconto médio por produto
-- Pergunta: quanto de desconto, em média, cada produto recebeu?
select p.nome_produto,
       round(avg((p.preco_atual - i.preco_venda) / p.preco_atual * 100), 1) as desconto_medio_pct
from item_venda i
join produto p on i.id_produto = p.id_produto
group by p.id_produto, p.nome_produto
order by desconto_medio_pct desc;

