-- Análise 1: faturamento por produto
-- Pergunta: quais produtos geram mais faturamento?
select p.nome_produto,
       sum(i.preco_venda * i.quantidade) as faturamento
from item_venda i
join produto p on i.id_produto = p.id_produto
group by p.nome_produto
order by faturamento desc;