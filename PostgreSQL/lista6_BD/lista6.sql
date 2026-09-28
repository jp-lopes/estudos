-- EXERCICIO 1

-- Q1
drop table if exists peca cascade;
drop table if exists fornecedor cascade;
drop table if exists projeto cascade;
drop table if exists fornece_para cascade;
drop table if exists categoria_peca cascade;
drop table if exists categoria_fornecedor cascade;


create table peca(
	PeNro text primary key,
	PeNome text not null,
	PePreco numeric(12,2) not null,
	PeCor text not null,
	constraint preco_nao_negativo check (PePreco >= 0)
);

create table fornecedor(
	FNro text primary key,
	FNome text not null,
	FCidade text not null,
	FCateg text not null
);

create table projeto(
	PNro text primary key,
	PNome text not null,
	PDuracao integer not null,
	PCusto numeric(12,2) not null,
	constraint duracao_nao_negativa check (PDuracao > 0),
	constraint custo_nao_negativo check (PCusto >= 0)
);

create table fornece_para(
	PeNro text,
	FNro text,
	PNro text,
	Quant integer not null,
	constraint quant_nao_negativa check (Quant > 0),
	constraint pk_fornecepara primary key (PeNro, FNro, PNro),
	constraint fk_penro foreign key (PeNro) references peca(PeNro) on update cascade,
	constraint fk_fnro foreign key (FNro) references fornecedor(FNro) on update cascade,
	constraint fk_pnro foreign key (PNro) references projeto(PNro) on update cascade on delete cascade
);

-- Q2
-- ============================================================================
-- 1. INSERT: PECAS
-- ============================================================================
INSERT INTO peca (PeNro, PeNome, PePreco, PeCor) VALUES
('E1', 'Parafuso', 15.00, 'Prata'),
('E2', 'Porca Hexagonal', 10.00, 'Vermelho'),
('E3', 'Arruela de Pressao', 12.00, 'Amarelo'),
('E4', 'Painel Solar Espacial', 600.00, 'Vermelho'),
('E5', 'Turbina Auxiliar', 1200.00, 'Vermelho'),
('E6', 'Sensor Termico', 50.00, 'Amarelo'),
('E7', 'Veda Vácuo', 80.00, 'Vermelho'),
('E8', 'Cabo de Cobre', 3.00, 'Azul'),
('E9', 'Placa de Titânio', 30.00, 'Cinza'),
('E10', 'Lente Óptica', 40.00, 'Vermelho'),
('E11', 'Microprocessador Espacial', 800.00, 'Verde'),
('E12', 'Valvula de Escape', 20.00, 'Preto'); 

-- ============================================================================
-- 2. INSERT: FORNECEDORES
-- ============================================================================
INSERT INTO fornecedor (FNro, FNome, FCidade, FCateg) VALUES
('F1', 'Metalúrgica Campinas', 'Campinas', 'A'),
('F2', 'Suprimentos Piracicaba', 'Piracicaba', 'B'),
('F3', 'Sistemas Espaciais F3', 'Piracicaba', 'A'),
('F4', 'Parafusos Campinas', 'Campinas', 'C'),
('F5', 'Santos Tech Indústria', 'Santos', 'B'),
('F6', 'Aço Santos Ltda', 'Santos', 'A'),
('F7', 'Componentes São Carlos', 'São Carlos', 'B'),
('F8', 'Orbital Componentes', 'São Paulo', 'C'); 

-- ============================================================================
-- 3. INSERT: PROJETOS
-- ============================================================================
INSERT INTO projeto (PNro, PNome, PDuracao, PCusto) VALUES
('P1', 'Apolo Star', 120, 15000.00),     
('P2', 'Sonda Voyager', 45, 2500.00),     
('P3', 'Estação Orbital', 180, 8000.00),  
('P4', 'Rover Marte', 60, 4500.00),       
('P5', 'Telescópio Hubble', 200, 20000.00),
('P6', 'Módulo de Escape', 30, 800.00);   

-- ============================================================================
-- 4. INSERT: FORNECE_PARA
-- ============================================================================
INSERT INTO fornece_para (PeNro, FNro, PNro, Quant) values
-- Fornecimentos para o Projeto P1 
('E1', 'F1', 'P1', 100),
('E2', 'F2', 'P1', 150),
('E3', 'F3', 'P1', 200), 
('E4', 'F4', 'P1', 50),  
('E5', 'F5', 'P1', 20),  
('E6', 'F6', 'P1', 30),  

-- Fornecimentos para o Projeto P2 
('E1', 'F3', 'P2', 80),  
('E6', 'F1', 'P2', 100),
('E7', 'F2', 'P2', 40),

-- Fornecimentos para o Projeto P3 
('E1', 'F4', 'P3', 300), 
('E8', 'F7', 'P3', 500),
('E9', 'F3', 'P3', 120),

-- Fornecimentos para o Projeto P4 
('E1', 'F1', 'P4', 200), 
('E2', 'F4', 'P4', 250),
('E10', 'F3', 'P4', 60),

-- Fornecimentos para o Projeto P5 
('E4', 'F3', 'P5', 10),  
('E5', 'F5', 'P5', 15),
('E11', 'F6', 'P5', 5);

-- Q3
--a
--select penome from peca;
--
--b
--select f.fnome, f.fnro from fornecedor f where f.fcidade = 'Campinas';
--
--c
--select p.pnome, p.pduracao from projeto p ;
--
--d
--select p.pnome, p.pcusto from projeto p where p.pcusto < 3000;
--
--e
--select pe.penome from peca pe 
--where pe.pecor = 'Vermelho' and pe.pepreco > 500;
--
--f
--select pe.penome, pe.pepreco from peca pe 
--where pe.pecor = 'Vermelho' and pe.pepreco > 25.00
--order by pe.pepreco desc;
--
--g
--select pe.penome, pe.pepreco, pe.pecor from peca pe
--where (pe.pecor = 'Vermelho' or pe.pecor = 'Amarelo')
--and pe.pepreco in (10,12,15,50,80)
--order by pe.pepreco asc;
--
--h
--select f.fnome, f.fcidade from fornecedor f where f.fcidade like 'S%';
--
--i
--select p.pnome from projeto p 
--where p.pcusto between 1000 and 5000;
--
--j
--select distinct fp.fnro from fornece_para fp
--where fp.pnro = 'P5';
--
--k
--select distinct pe.penome from peca pe
--join fornece_para fp 
--on fp.fnro in ('F3','F4') and pe.penro = fp.penro;
--
--select distinct pe.penome from peca pe, fornece_para fp 
--where fp.fnro in ('F3','F4') and pe.penro = fp.penro;
--
--l
--select distinct pe.penome from peca pe
--join fornece_para fp 
--on pe.penro = fp.penro
--join projeto p
--on fp.pnro = p.pnro 
--where p.pduracao > 90;
--
--m
--select distinct pe.penome from peca pe
--join fornece_para fp
--on fp.penro = pe.penro
--join fornecedor f
--on fp.fnro = f.fnro 
--where f.fcidade = 'Piracicaba';
--
--n
--select pe.penome
--from peca pe
--where not exists (
--    select 1
--    from fornece_para fp
--    join fornecedor f on fp.fnro = f.fnro
--    where fp.penro = pe.penro 
--      and f.fcateg = 'A'
--);
--
--o
--select distinct f.fnome from fornecedor f 
--join fornece_para fp 
--on fp.fnro = f.fnro 
--join peca pe
--on fp.penro = pe.penro 
--where pe.penome = 'Parafuso';
--
--p
--select 
--	pe.penro, 
--	pe.penome, 
--	coalesce(sum(fp.quant), 0) as qtd_total
--from peca pe 
--left join fornece_para fp 
--on pe.penro = fp.penro 
--group by pe.penro, pe.penome
--order by pe.penro;
--
--q
--select
--	p.pnro,
--	p.pnome,
--	coalesce(sum(fp.quant),0) as qtd_total
--from projeto p
--left join fornece_para fp
--on fp.pnro = p.pnro 
--group by p.pnro, p.pnome
--order by p.pnro;
--
--r. Código, nome e quantidade total de peças recebidas por cada projeto cujo PCusto seja superior a R$
--5.000,00. Inclua projetos sem fornecimento.
--select 
--	p.pnro, 
--	p.pnome, 
--	sum(fp.quant) as qtd_total 
--from projeto p
--left join fornece_para fp 
--on p.pnro = fp.pnro 
--where p.pcusto > 5000
--group by p.pnro, p.pnome
--order by p.pnro;
--
--s. Código, nome e quantidade total de peças recebidas por cada projeto que tenha mais de cinco
--fornecedores distintos. 
--with t as
--(
--	select
--		p.pnro as pnro,
--		p.pnome as pnome,
--		sum(fp.quant) as qtd_total_pecas,
--		count(distinct fp.fnro) as contagem_fornecedores
--	from projeto as p
--	join fornece_para as fp
--	on fp.pnro = p.pnro 
--	group by p.pnro, p.pnome
--)
--select
--	t.pnro,
--	t.pnome,
--	t.qtd_total_pecas
--from t
--where t.contagem_fornecedores > 5;
--
--
--t. Dados dos projetos cuja quantidade total de peças recebidas seja máxima e dos projetos cuja quantidade
--seja mínima. Inclua todos os empates e trate projetos sem fornecimento como total zero.
--with t as
--(
--	select 
--		p.pnro as pnro,
--		coalesce(sum(fp.quant),0) as qtd_total_pecas
--	from projeto p 
--	left join fornece_para fp 
--	on fp.pnro = p.pnro
--	group by p.pnro
--)
--select  
--	p.*
--from t,projeto p
--where (t.pnro = p.pnro) 
--and (
--t.qtd_total_pecas = (
--	select max(t.qtd_total_pecas)
--	from t
--)
--or t.qtd_total_pecas = (
--	select min(t.qtd_total_pecas)
--	from t
--)
--)
--order by t.pnro;


--u. Ranking de todos os fornecedores, em ordem decrescente do valor estimado de seus fornecimentos aos
--preços atuais. Calcule esse valor como a soma de Quant × PePreco e atribua zero a fornecedores sem
--fornecimentos. Fornecedores empatados recebem a mesma posição.
--with t as 
--(
--	select 
--		f.fnro,
--		f.fnome,
--		coalesce(sum(fp.quant * pe.pepreco),0) as valor_fornecimento
--	from fornecedor f
--	left join fornece_para fp
--	on f.fnro = fp.fnro
--	left join peca pe
--	on pe.penro = fp.penro 
--	group by f.fnro
--	order by f.fnro
--)
--select
--	t.*,
--	rank() over(order by t.valor_fornecimento desc)
--from t;
--
--
--v. Para cada projeto, apresente o código e o nome do projeto, o código do fornecedor e a quantidade total
--de peças que esse fornecedor destinou ao projeto. Classifique os fornecedores dentro de cada projeto, da
--maior para a menor quantidade. Fornecedores empatados devem receber a mesma posição.
--with t as 
--(
--	select 
--		p.pnro,
--		fp.fnro,
--		sum(fp.quant) as qtd_fornecida
--	from projeto p
--	join fornece_para fp
--	on p.pnro = fp.pnro
--	group by p.pnro, fp.fnro
--	order by p.pnro, fp.fnro
--)
--select 
--	t.*,
--	rank() over(partition by p.pnro order by t.qtd_fornecida desc) as rank
--from t,projeto p
--where t.pnro = p.pnro
--order by p.pnro, rank;
--
--
--w. Para cada projeto, apresente seu código, custo e o custo acumulado dos projetos, ordenados por
--PCusto crescente e, em caso de empate, por PNro. O acumulado deve incluir a linha corrente.
--
--select 
--	p.pnro,
--	p.pcusto,
--	sum(p.pcusto) over(
--		order by p.pcusto, p.pnro asc 
--		rows between unbounded preceding and current row
--	) as custo_acumulado
--from projeto as p
--order by p.pcusto;


-- Q4.
--delete from projeto p where p.pnro = 'P5';
--
--select * from projeto p
--join fornece_para fp
--on p.pnro = fp.pnro ;
--
-- Q5
--update peca set pecor = 'Verde' where pepreco not in (3,10,30);
--
--select * from peca;
--
-- Q6
--delete from fornece_para fp where fp.pnro = 'P4' ;

-- Q7
create table categoria_peca (
	PeCat text primary key,
	PeDescCat text not null
);

INSERT INTO categoria_peca (pecat, pedesccat) VALUES
('C1', 'Fixacao'),
('C2', 'Componentes Mecanicos'),
('C3', 'Componentes Eletronicos'),
('C4', 'Componentes Estruturais'),
('C5', 'Componentes Opticos');

-- Q8
alter table peca
add column PeCat text;

UPDATE peca SET pecat = 'C1'
WHERE penro IN ('E1', 'E2', 'E3');

UPDATE peca SET pecat = 'C2'
WHERE penro IN ('E5', 'E7', 'E12');

UPDATE peca SET pecat = 'C3'
WHERE penro IN ('E6', 'E8', 'E11');

UPDATE peca SET pecat = 'C4'
WHERE penro IN ('E4', 'E9');

UPDATE peca SET pecat = 'C5'
WHERE penro IN ('E10');
	

alter table peca
alter column Pecat set not null;

alter table peca
add constraint fk_categoria_peca foreign key (pecat) references categoria_peca(pecat);

-- Q9
create table categoria_fornecedor(
	pecat text,
	fnro text,
	pnro text,
	quant integer not null, 
	constraint quant_nao_negativo check (quant > 0),
	constraint pk_cat_fornec primary key (pecat, fnro, pnro),
	constraint fk_pecat foreign key (pecat) references categoria_peca(pecat) on update cascade,
	constraint fk_fnro foreign key (fnro) references fornecedor(fnro) on update cascade,
	constraint fk_pnro foreign key (pnro) references projeto(pnro) on update cascade on delete cascade
);

insert into categoria_fornecedor (pecat,fnro,pnro,quant)
(
	select 
		pe.pecat,
		fp.fnro,
		fp.pnro,
		sum(fp.quant)
	from peca pe 
	join fornece_para fp
 	on fp.penro = pe.penro
 	group by pe.pecat, fp.fnro, fp.pnro
);


-- Q10

-- Q11

insert into categoria_fornecedor (pecat, fnro, pnro, quant)


select
	cp.pecat,
	cp.pedesccat,
	cf.fnro
from categoria_peca cp 
left join categoria_fornecedor cf 
on cf.pecat = cp.pecat 
group by cp.pecat, cf.fnro
order by cp.pecat, cf.fnro





