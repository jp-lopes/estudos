drop table if exists aluno cascade;
drop table if exists disciplina cascade;
drop table if exists matricula cascade;
drop table if exists professor cascade;
drop table if exists turma cascade;

-- Esquema e dados de apoio: Lista 7 (PostgreSQL)
-- Execute em um esquema vazio. Idade e NAlunos são valores armazenados;
-- exercícios posteriores exploram sua manutenção.

CREATE TABLE Aluno (
    NUSP NUMERIC(10) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Idade SMALLINT,
    DataNasc DATE,
    CidadeOrigem VARCHAR(100) DEFAULT 'Sao Carlos',
    CONSTRAINT aluno_pk PRIMARY KEY (NUSP),
    CONSTRAINT aluno_un UNIQUE (Nome),
    CONSTRAINT aluno_ck CHECK (Idade > 15)
);

CREATE TABLE Professor (
    NFunc NUMERIC(10) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Idade SMALLINT,
    Titulacao VARCHAR(100),
    CONSTRAINT prof_pk PRIMARY KEY (NFunc),
    CONSTRAINT prof_un UNIQUE (Nome),
    CONSTRAINT prof_idade_ck CHECK (Idade > 18),
    CONSTRAINT prof_tit_ck CHECK (
        Titulacao IN ('Mestrado', 'Doutorado', 'Livre-docencia', 'Titular')
    )
);

CREATE TABLE Disciplina (
    Sigla CHAR(5) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    NCred SMALLINT DEFAULT 4 NOT NULL,
    Professor NUMERIC(10),
    Livro VARCHAR(100),
    CONSTRAINT disc_pk PRIMARY KEY (Sigla),
    CONSTRAINT disc_ncred_ck CHECK (NCred > 0),
    CONSTRAINT disc_fk FOREIGN KEY (Professor)
        REFERENCES Professor (NFunc) ON DELETE CASCADE
);

CREATE TABLE Turma (
    Sigla CHAR(5) NOT NULL,
    Numero SMALLINT NOT NULL,
    NAlunos SMALLINT DEFAULT 0 NOT NULL,
    CONSTRAINT turma_pk PRIMARY KEY (Sigla, Numero),
    CONSTRAINT turma_fk FOREIGN KEY (Sigla)
        REFERENCES Disciplina (Sigla) ON DELETE CASCADE,
    CONSTRAINT turma_ck CHECK (NAlunos >= 0)
);

CREATE TABLE Matricula (
    Sigla CHAR(5) NOT NULL,
    Numero SMALLINT NOT NULL,
    Aluno NUMERIC(10) NOT NULL,
    Ano SMALLINT NOT NULL,
    Nota NUMERIC(4,2) DEFAULT 0,
    FrequenciaPorc NUMERIC(5,2) DEFAULT 0,
    CONSTRAINT matricula_pk PRIMARY KEY (Sigla, Numero, Aluno, Ano),
    CONSTRAINT matricula_fk1 FOREIGN KEY (Sigla, Numero)
        REFERENCES Turma (Sigla, Numero) ON DELETE CASCADE,
    CONSTRAINT matricula_fk2 FOREIGN KEY (Aluno)
        REFERENCES Aluno (NUSP) ON DELETE CASCADE,
    CONSTRAINT matricula_nota_ck CHECK (Nota BETWEEN 0 AND 10),
    CONSTRAINT matricula_freq_ck CHECK (FrequenciaPorc BETWEEN 0 AND 100)
);

-- A idade inicial é calculada no dia em que este script é executado.
INSERT INTO Aluno (NUSP, Nome, Idade, DataNasc, CidadeOrigem) VALUES
    (1, 'Ana', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1990-07-06'))::smallint, DATE '1990-07-06', 'Jau'),
    (2, 'Andre', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1991-09-06'))::smallint, DATE '1991-09-06', 'Lins'),
    (3, 'Adriana', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1992-08-03'))::smallint, DATE '1992-08-03', 'Limeira'),
    (4, 'Albertina', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1992-09-02'))::smallint, DATE '1992-09-02', 'Descalvado'),
    (30, 'Petrus', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1980-02-05'))::smallint, DATE '1980-02-05', 'Marilia'),
    (40, 'Marcos', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1985-07-03'))::smallint, DATE '1985-07-03', 'Vitoria');

-- Exemplo do uso de DEFAULT para CidadeOrigem.
INSERT INTO Aluno (NUSP, Nome, Idade, DataNasc)
VALUES (5, 'Adilson', EXTRACT(YEAR FROM age(CURRENT_DATE, DATE '1990-07-06'))::smallint, DATE '1990-07-06');

INSERT INTO Professor (NFunc, Nome, Idade, Titulacao) VALUES
    (10, 'Paulo', 32, 'Doutorado'),
    (20, 'Pedro', 26, 'Mestrado'),
    (30, 'Petrus', 40, 'Doutorado'),
    (40, 'Marcos', 35, 'Mestrado');

INSERT INTO Disciplina (Sigla, Nome, NCred, Professor, Livro) VALUES
    ('SC540', 'BDInfo', 4, 10, 'Fundamentos de Bases de Dados'),
    ('SC241', 'LabBD', 4, 20, 'Oracle guide'),
    ('SM300', 'Calculo', 6, 30, 'Introdução ao Cálculo'),
    ('SM400', 'Algebra', 4, 30, 'Introdução à Algebra');

-- NAlunos começa em zero e é inicializado após a carga de Matricula.
INSERT INTO Turma (Sigla, Numero) VALUES
    ('SC540', 1), ('SC241', 1), ('SC540', 2), ('SC241', 2),
    ('SM300', 1), ('SM400', 1), ('SM300', 2), ('SM400', 2);

INSERT INTO Matricula (Sigla, Numero, Aluno, Ano, Nota, FrequenciaPorc) VALUES
    ('SC540', 1, 1, 2009, 4.5, 59),
    ('SC540', 1, 2, 2009, 4.6, 50),
    ('SC540', 1, 3, 2009, 4.0, 60),
    ('SC540', 1, 1, 2010, 5.5, 65),
    ('SC540', 1, 2, 2010, 7.6, 80),
    ('SC540', 1, 3, 2010, 4.2, 65),
    ('SC241', 1, 1, 2009, 4.5, 59),
    ('SC241', 1, 2, 2009, 6.5, 40),
    ('SC241', 1, 3, 2009, 4.5, 59),
    ('SC241', 1, 1, 2010, 9.0, 30),
    ('SC241', 1, 3, 2010, 4.5, 59),
    ('SM300', 1, 2, 2009, 3.0, 59),
    ('SM300', 1, 3, 2010, 5.1, 50),
    ('SM300', 2, 4, 2010, 5.8, 100),
    ('SM300', 2, 5, 2010, 9.1, 50);

-- Como Turma não possui Ano, NAlunos conta matrículas de todos os anos.
UPDATE Turma AS t
SET NAlunos = (
    SELECT COUNT(*)
    FROM Matricula AS m
    WHERE m.Sigla = t.Sigla AND m.Numero = t.Numero
);

--1. Limite anual de créditos. Escreva um gatilho que impeça um aluno de ultrapassar 20 créditos em um mesmo ano. Para
--cada matrícula, considere o valor de Disciplina.NCred da disciplina indicada por Matricula.Sigla. Conte todas
--as matrículas do aluno naquele Matricula.Ano, inclusive matrículas repetidas em uma disciplina. Verifique a regra em
--INSERT e em UPDATE que altere Aluno, Ano ou Sigla. Para este exercício, suponha que NCred não seja alterado após
--a existência de matrículas na disciplina.

create or replace function verifica_total_creditos()
returns trigger as $$
declare
	total_creditos_atual_ano integer := 0;
	creditos_nova_disciplina integer := 0;
begin
	-- calcula creditos da nova disciplina e salva em outra variavel
	select d.ncred 
	into creditos_nova_disciplina
	from disciplina d
	where d.sigla = new.sigla;

	if (tg_op = 'INSERT') then
		-- calcula total de creditos que o aluno ja esta matriculado nesse ano e salva em uma variável
		select coalesce(sum(d.ncred),0)
		into total_creditos_atual_ano
		from matricula m
		join disciplina d
		on d.sigla = m.sigla
		where m.aluno = new.aluno and m.ano = new.ano;
	elsif (tg_op = 'UPDATE' and (
		new.aluno is distinct from old.aluno 
		or new.ano is distinct from old.ano 
		or new.sigla is distinct from old.sigla)) 
	then
		-- calcula total de creditos que o aluno ja esta matriculado nesse ano e salva em uma variável
		select coalesce(sum(d.ncred),0)
		into total_creditos_atual_ano
		from matricula m
		join disciplina d
		on d.sigla = m.sigla
		where m.aluno = new.aluno 
		and m.ano = new.ano
		and not (m.sigla = old.sigla and m.numero = old.numero and m.aluno = old.aluno and m.ano = old.ano); -- elimina a linha que ainda será atualizada da contagem	
	end if;
	-- calcula total
	if total_creditos_atual_ano + creditos_nova_disciplina > 20 then
		raise exception 'Essa matricula excedará o limite de 20 créditos anuais';	
	end if;

	return new;
end;
$$ language plpgsql;

create trigger trg_verifica_total_creditos
before insert or update on matricula
for each row
execute function verifica_total_creditos();


--2. Progressão da titulação. Escreva um gatilho que impeça reduzir Professor.Titulacao, segundo a ordem Mestrado
--< Doutorado < Livre-docencia < Titular. Se uma atualização atribuir titulação inferior à anterior, levante uma exceção e
--impeça a operação.

create or replace function verifica_progressao_titulo()
returns trigger as $$
begin
	if (new.titulacao is distinct from old.titulacao) then
		if (old.titulacao = 'Titular') 
		and (new.titulacao in ('Mestrado','Doutorado','Livre-docencia') or new.titulacao is null)
		then raise exception 'Não é possível atribuir uma titulação inferior à atual';

		elsif (old.titulacao = 'Livre-docencia' ) 
		and (new.titulacao in ('Mestrado','Doutorado') or new.titulacao is null)
		then raise exception 'Não é possível atribuir uma titulação inferior à atual';

		elsif (old.titulacao = 'Doutorado') 
		and (new.titulacao in ('Mestrado') or new.titulacao is null)
		then raise exception 'Não é possível atribuir uma titulação inferior à atual';
		
		elsif (old.titulacao = 'Mestrado') 
		and (new.titulacao is null)
		then raise exception 'Não é possível atribuir uma titulação inferior à atual';

		end if;
	end if; 
	return new;
end;
$$ language plpgsql;

create trigger tg_verifica_progressao_titulo
before update on professor
for each row
execute function verifica_progressao_titulo();


--3. Média das notas da disciplina. Acrescente o atributo nota_media à tabela Disciplina. Escreva um gatilho que o
--mantenha igual à média das Matricula.Nota não nulas da disciplina, considerando todas as suas turmas e todos os
--anos. Quando não houver notas não nulas, armazene NULL. Trate INSERT, DELETE e UPDATE em Matricula. Se uma
--atualização mudar Sigla, recalcule a média das disciplinas antiga e nova.

alter table disciplina
add column nota_media numeric(12,2);

alter table disciplina
alter column nota_media set default null;

update disciplina d set nota_media = (select
	round(avg(m.nota),2)
	from matricula as m
	where m.sigla = d.sigla
);

create or replace function calcula_nota_media()
returns trigger as $$
declare
	media numeric(12,2) := null;
begin
	if tg_op = 'INSERT' or tg_op = 'UPDATE' then
		select round(avg(m.nota),2)
		into media
		from matricula as m
		where m.sigla = new.sigla;

		update disciplina d set nota_media = media where d.sigla = new.sigla;

		if tg_op = 'UPDATE' and old.sigla is distinct from new.sigla then
			select round(avg(m.nota),2)
			into media
			from matricula as m
			where m.sigla = old.sigla;

			update disciplina d set nota_media = media where d.sigla = old.sigla;
		end if;	


	elsif tg_op = 'DELETE' then
		select round(avg(m.nota),2)
		into media
		from matricula as m
		where m.sigla = old.sigla;

		update disciplina d set nota_media = media where d.sigla = old.sigla;
	end if;
	return null;
end;
$$ language plpgsql;

create trigger tg_calcula_nota_media
after insert or update or delete on matricula
for each row
execute function calcula_nota_media();

insert into matricula values ('SM400', 2, 1, 2009, 6.5, 40);
select * from disciplina;
delete from matricula where sigla='SM400';
select * from disciplina;


--4. Idade derivada. Escreva um gatilho BEFORE INSERT OR UPDATE OF DataNasc em Aluno que atribua a
--NEW.Idade a idade calculada a partir de NEW.DataNasc e da data corrente. Se DataNasc for nula, atribua NULL a
--Idade. Explique por que o valor armazenado pode ficar desatualizado sem que ocorra qualquer atualização da linha.

create or replace function calcula_idade()
returns trigger as $$
BEGIN
	if new.datanasc is null then
		update aluno 
		set idade = null 
		where aluno.nusp = new.nusp;
	else
		update aluno 
		set idade = EXTRACT(year from AGE(CURRENT_DATE, new.datanasc))
		where aluno.nusp = new.nusp;
	end if;	
	return null;
END;
$$ language plpgsql;

create trigger tg_calcula_idade
after insert or update of datanasc on aluno
for each row
execute function calcula_idade();


--7. Escreva um gatilho em nível de comando que, após cada comando INSERT, UPDATE ou DELETE em matricula,
--informe com RAISE NOTICE o número de linhas existentes nessa tabela.
create or replace function avisa_n_linhas()
returns trigger as $$
declare
	total_linhas integer;
begin
	select count(*)
	into total_linhas
	from matricula;

	raise notice 'Total de linhas da tabela Matrícula após a alteração: %', total_linhas;

	return null;
end;
$$ language plpgsql;


create trigger tg_avisa_n_linhas
after insert or update or delete on matricula
for each statement
execute function avisa_n_linhas();


--8. Acrescente à tabela matricula o atributo booleano aprovacao, com valor padrão false. Escreva um procedimento,
--sem gatilho, que atualize todas as linhas: aprovacao deve ser true quando nota >= 5 e false nos demais casos,
--inclusive quando nota IS NULL. Execute o procedimento. 

alter table matricula
add column aprovacao boolean;

alter table matricula
alter column aprovacao set default false;

create or replace procedure atualiza_aprovacao() 
language plpgsql as $$
BEGIN
	update matricula set aprovacao = (nota >=5);
END;	
$$;

call atualiza_aprovacao();

--9. Escreva um gatilho BEFORE INSERT OR UPDATE OF nota em matricula que atribua diretamente a
--NEW.aprovacao o valor definido no exercício 8. Verifique o resultado com inserções e atualizações, 
--incluindo uma nota nula.
create or replace function atualiza_aprovacao_2()
returns trigger as $$
begin
	update matricula set aprovacao = (nota >=5);
	return new;
end;
$$ language plpgsql;

create trigger tg_atualiza_aprovacao
before insert or update of nota on matricula
for each row
execute function atualiza_aprovacao_2();
















