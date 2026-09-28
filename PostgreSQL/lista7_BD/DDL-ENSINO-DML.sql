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