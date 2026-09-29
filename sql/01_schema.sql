drop table if exists item_venda;
drop table if exists venda;
drop table if exists vendedor;
drop table if exists produto;
drop table if exists cliente;

create table cliente (
    id_cliente   integer generated always as identity primary key,
    nome_cliente varchar(50) not null
);

create table produto (
    id_produto         integer generated always as identity primary key,
    nome_produto       varchar(100) not null,
    preco_atual        numeric(10,2) not null check (preco_atual > 0),
    quantidade_estoque integer not null check (quantidade_estoque >= 0)
);

create table vendedor (
    id_vendedor   integer generated always as identity primary key,
    nome_vendedor varchar(50) not null
);

create table venda (
    id_venda    integer generated always as identity primary key,
    id_cliente  integer not null references cliente(id_cliente),
    id_vendedor integer not null references vendedor(id_vendedor),
    data_venda  date not null
);

create table item_venda (
    id_item_venda integer generated always as identity primary key,
    id_venda      integer not null references venda(id_venda),
    id_produto    integer not null references produto(id_produto),
    preco_venda   numeric(10,2) not null check (preco_venda > 0),
    quantidade    integer not null check (quantidade > 0)
);

create index idx_venda_cliente     on venda(id_cliente);
create index idx_venda_vendedor    on venda(id_vendedor);
create index idx_item_venda_venda   on item_venda(id_venda);
create index idx_item_venda_produto on item_venda(id_produto);