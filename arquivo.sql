-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS academia_db;
USE academia_db;

-- PLANOS
CREATE TABLE IF NOT EXISTS PLANOS (
    ID_Plano INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Plano VARCHAR(50) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    DuracaoMeses INT NOT NULL DEFAULT 12
);

-- PERSONAL
CREATE TABLE IF NOT EXISTS PERSONAL (
    CREF VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20),
    Especialidade VARCHAR(50)
);

-- ALUNO
CREATE TABLE IF NOT EXISTS ALUNO (
    Matricula INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    DataNascimento DATE,
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    Endereco VARCHAR(150),
    ID_Plano INT NOT NULL,
    CREF_Personal VARCHAR(20),
    FOREIGN KEY (ID_Plano) REFERENCES PLANOS(ID_Plano),
    FOREIGN KEY (CREF_Personal) REFERENCES PERSONAL(CREF)
);

-- TREINO
CREATE TABLE IF NOT EXISTS TREINO (
    ID_Treino INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Objetivo VARCHAR(100),
    CREF VARCHAR(20),
    FOREIGN KEY (CREF) REFERENCES PERSONAL(CREF)
);

-- ALUNO_TREINO
CREATE TABLE IF NOT EXISTS ALUNO_TREINO (
    Matricula INT,
    ID_Treino INT,
    PRIMARY KEY (Matricula, ID_Treino),
    FOREIGN KEY (Matricula) REFERENCES ALUNO(Matricula),
    FOREIGN KEY (ID_Treino) REFERENCES TREINO(ID_Treino)
);

-- ACESSO
CREATE TABLE IF NOT EXISTS ACESSO (
    ID_Acesso INT AUTO_INCREMENT PRIMARY KEY,
    Data_Acesso DATE NOT NULL,
    Hora_Acesso TIME NOT NULL,
    Matricula INT NOT NULL,
    FOREIGN KEY (Matricula) REFERENCES ALUNO(Matricula)
);

-- POVOAMENTO DOS DADOS (INSERTs)

-- 1. PLANOS
INSERT INTO PLANOS (ID_Plano, Nome_Plano, Valor, DuracaoMeses) VALUES
(1, 'Médio', 129.90, 6),
(2, 'Básico', 100.00, 1),
(3, 'Premium', 140.00, 12);

-- 2. PERSONAL
INSERT INTO PERSONAL (CREF, Nome, Telefone, Especialidade) VALUES
('CREF-12345-G/SP', 'Carlos Eduardo Silva', '(11) 98888-1111', 'Musculação'),
('CREF-67890-G/SP', 'Mariana Costa Ramos', '(11) 98888-2222', 'Cardio/Cross'),
('CREF-54321-G/RJ', 'Roberto Souza Alves', '(21) 97777-3333', 'Reabilitação'),
('CREF-98765-G/MG', 'Ana Beatriz Oliveira', '(31) 99999-4444', 'Pilates'),
('CREF-24680-G/SP', 'Rodrigo Mendes Rocha', '(11) 98888-5555', 'Treinamento Funcional'),
('CREF-13579-G/RJ', 'Juliana Vieira Santos', '(21) 97777-6666', 'Nutrição Esportiva'),
('CREF-86420-G/PR', 'Lucas Fernando Almeida', '(41) 96666-7777', 'Hipertrofia'),
('CREF-75319-G/MG', 'Fernanda Lima Duarte', '(31) 99999-8888', 'Dança/Ritmos');

-- 3. ALUNO
INSERT INTO ALUNO (Nome, CPF, Telefone, ID_Plano, CREF_Personal) VALUES
('Larissa Martins Rocha', '567.890.123-44', '(11) 96666-0005', 2, NULL),
('Lucas Oliveira Santos', '123.456.789-00', '(11) 99999-0001', 1, 'CREF-12345-G/SP'),
('Amanda Ribeiro Dias', '789.012.345-66', '(41) 94444-0007', 1, NULL),
('Gabriel Ferreira Costa', '456.789.012-33', '(31) 97777-0004', 1, 'CREF-98765-G/MG'),
('Camila Nunes Vieira', '901.234.567-88', '(11) 92222-0009', 3, NULL),
('Thiago Augusto Silva', '678.890.123-55', '(21) 95555-0006', 3, 'CREF-13579-G/RJ'),
('Sofia Resende Lopes', '135.246.579-00', '(31) 90000-0011', 2, NULL),
('Beatriz Souza Lima', '234.567.890-11', '(11) 99999-0002', 3, 'CREF-67890-G/SP'),
('Bruno Cardoso Melo', '012.345.678-99', '(21) 91111-0010', 1, NULL),
('Matheus Cunha Peixoto', '890.123.456-77', '(31) 93333-0008', 2, 'CREF-75319-G/MG'),
('Letícia Castro Neves', '246.813.579-22', '(31) 92222-0014', 3, NULL),
('Mariana Rocha Ribeiro', '543.210.987-66', '(11) 94444-0012', 1, 'CREF-24680-G/SP'),
('Rodrigo Almeida Melo', '345.678.901-22', '(21) 98888-0003', 2, 'CREF-54321-G/RJ'),
('Felipe Augusto Souza', '987.654.321-11', '(11) 91111-0015', 1, NULL),
('Pedro Henrique Gomes', '765.432.109-88', '(41) 93333-0013', 2, 'CREF-86420-G/PR');

-- 4. TREINO
INSERT INTO TREINO (Nome, Objetivo, CREF) VALUES
('Hipertrofia e Força Total', 'Ganho de Massa Muscular', 'CREF-12345-G/SP'),
('Circuito HIIT Queima Calórica', 'Condicionamento e Perda de Peso', 'CREF-67890-G/SP'),
('Fortalecimento e Mobilidade', 'Reabilitação Postural e Lesões', 'CREF-54321-G/RJ'),
('Pilates Clínico e Core', 'Estabilização e Flexibilidade', 'CREF-98765-G/MG'),
('Treinamento Funcional Dinâmico', 'Agilidade e Fortalecimento Geral', 'CREF-24680-G/SP'),
('Construção Muscular Avançada', 'Hipertrofia Máxima', 'CREF-86420-G/PR');

-- 5. ALUNO_TREINO
INSERT INTO ALUNO_TREINO (Matricula, ID_Treino) VALUES
(2, 1),
(8, 2),
(13, 3),
(4, 4),
(12, 5),
(15, 6),
(6, 2),
(6, 5);

-- 6. ACESSO
INSERT INTO ACESSO (Data_Acesso, Hora_Acesso, Matricula) VALUES
('2026-06-28', '06:30:00', 2),
('2026-06-28', '07:15:00', 1),
('2026-06-28', '18:30:00', 8),
('2026-06-29', '06:12:00', 2),
('2026-06-29', '12:00:00', 13),
('2026-06-29', '16:45:00', 4),
('2026-06-29', '19:15:00', 5),
('2026-06-30', '07:00:00', 6),
('2026-06-30', '08:30:00', 8),
('2026-06-30', '13:00:00', 7);


-- CONSULTAS

SELECT A.Matricula, A.Nome AS Aluno, P.Nome AS Personal, P.Especialidade
FROM ALUNO A
INNER JOIN PERSONAL P ON A.CREF_Personal = P.CREF;

SELECT P.Nome AS Personal, COUNT(A.Matricula) AS Total_Alunos
FROM PERSONAL P
LEFT JOIN ALUNO A ON P.CREF = A.CREF_Personal
GROUP BY P.CREF, P.Nome
ORDER BY Total_Alunos DESC;

SELECT A.Nome AS Aluno, T.Nome AS Nome_Treino, T.Objetivo
FROM ALUNO_TREINO AT
JOIN ALUNO A ON AT.Matricula = A.Matricula
JOIN TREINO T ON AT.ID_Treino = T.ID_Treino;

SELECT 
    A.Matricula,
    A.Nome AS Nome_Aluno,
    PER.Nome AS Nome_Personal,
    T.Nome AS Nome_Treino,
    T.Objetivo AS Objetivo_Treino
FROM ALUNO A
LEFT JOIN PERSONAL PER ON A.CREF_Personal = PER.CREF
LEFT JOIN ALUNO_TREINO AT ON A.Matricula = AT.Matricula
LEFT JOIN TREINO T ON AT.ID_Treino = T.ID_Treino
ORDER BY A.Nome;