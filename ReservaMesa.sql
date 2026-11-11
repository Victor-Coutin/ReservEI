/* =====================================================
   SISTEMA DE GERENCIAMENTO DE RESERVAS - RESTAURANTE
   ===================================================== */

CREATE DATABASE IF NOT EXISTS reservamesa;
USE reservamesa;


/* =====================================================
   1. CRIAÇÃO DAS TABELAS
   ===================================================== */

/* ---------- CLIENTE ---------- */

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fone VARCHAR(20),
    data_cadastro DATE,
    email VARCHAR(100)
);


/* ---------- FUNCIONÁRIO ---------- */

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cargo VARCHAR(50)
);


/* ---------- MESA ---------- */

CREATE TABLE mesa (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    capacidade INT NOT NULL,
    local VARCHAR(50),
    status_mesa VARCHAR(50)
);


/* ---------- RESERVA ---------- */

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_reserva TIMESTAMP NOT NULL,
    quantidade_pessoas INT NOT NULL,
    status_reserva VARCHAR(50),
    data_hora_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,

    fk_cliente_id_cliente INT NOT NULL,
    fk_funcionario_id_funcionario INT NOT NULL,

    FOREIGN KEY (fk_cliente_id_cliente)
        REFERENCES cliente(id_cliente),

    FOREIGN KEY (fk_funcionario_id_funcionario)
        REFERENCES funcionario(id_funcionario)
);


/* ---------- LISTA DE ESPERA ---------- */

CREATE TABLE lista_espera (
    id_espera INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_chamada TIMESTAMP NULL,
    quantidade_pessoas INT NOT NULL,
    status_espera VARCHAR(50),
    observacao TEXT,

    fk_cliente_id_cliente INT NOT NULL,
    fk_funcionario_id_funcionario INT,

    FOREIGN KEY (fk_cliente_id_cliente)
        REFERENCES cliente(id_cliente),

    FOREIGN KEY (fk_funcionario_id_funcionario)
        REFERENCES funcionario(id_funcionario)
);


/* ---------- ATRIBUIÇÃO DE MESA ---------- */

CREATE TABLE atribuicao_mesa (
    id_atribuicao INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_atribuicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,

    fk_funcionario_id_funcionario INT NOT NULL,
    fk_mesa_id_mesa INT NOT NULL,

    FOREIGN KEY (fk_funcionario_id_funcionario)
        REFERENCES funcionario(id_funcionario),

    FOREIGN KEY (fk_mesa_id_mesa)
        REFERENCES mesa(id_mesa)
);

	
/* ---------- OCUPAÇÃO ---------- */

CREATE TABLE ocupacao (
    id_ocupacao INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP NULL,
    quantidade_pessoas INT NOT NULL,
    status_ocupacao VARCHAR(50),
    observacao TEXT,

    fk_funcionario_id_funcionario INT NOT NULL,

    FOREIGN KEY (fk_funcionario_id_funcionario)
        REFERENCES funcionario(id_funcionario)
);


/* =====================================================
   2. INSERÇÃO DE DADOS PARA TESTES
   ===================================================== */


/* Clientes */

INSERT INTO cliente
(nome, fone, data_cadastro, email)
VALUES
('João Silva', '61999990001', '2026-11-01', 'joao@email.com'),
('Maria Souza', '61999990002', '2026-11-02', 'maria@email.com'),
('Carlos Lima', '61999990003', '2026-11-03', 'carlos@email.com'),
('Ana Costa', '61999990004', '2026-11-04', 'ana@email.com');


/* Funcionários */

INSERT INTO funcionario
(nome, telefone, email, cargo)
VALUES
('Lucas Alves', '61988880001', 'lucas@restaurante.com', 'Gerente'),
('Fernanda Silva', '61988880002', 'fernanda@restaurante.com', 'Atendente'),
('Rafael Souza', '61988880003', 'rafael@restaurante.com', 'Garçom');


/* Mesas */

INSERT INTO mesa
(numero, capacidade, local, status_mesa)
VALUES
(1, 2, 'Salão', 'Disponível'),
(2, 4, 'Salão', 'Ocupada'),
(3, 4, 'Salão', 'Disponível'),
(4, 6, 'Área externa', 'Disponível');


/* Reservas */

INSERT INTO reserva
(data_hora_reserva, quantidade_pessoas, status_reserva,
 fk_cliente_id_cliente, fk_funcionario_id_funcionario)
VALUES
('2026-11-10 19:00:00', 2, 'Confirmada', 1, 2),
('2026-11-10 20:00:00', 4, 'Confirmada', 2, 2),
('2026-11-11 19:00:00', 4, 'Pendente', 3, 1),
('2026-11-12 20:00:00', 6, 'Cancelada', 4, 2);


/* Lista de espera */

INSERT INTO lista_espera
(quantidade_pessoas, status_espera,
 fk_cliente_id_cliente, fk_funcionario_id_funcionario)
VALUES
(2, 'Aguardando', 1, 2),
(4, 'Atendido', 2, 2),
(3, 'Aguardando', 3, 3);


/* Atribuições de mesa */

INSERT INTO atribuicao_mesa
(fk_funcionario_id_funcionario, fk_mesa_id_mesa, observacao)
VALUES
(2, 1, 'Reserva do cliente'),
(2, 2, 'Reserva do cliente'),
(3, 3, 'Cliente da lista de espera');


/* Ocupações */

INSERT INTO ocupacao
(quantidade_pessoas, status_ocupacao,
 fk_funcionario_id_funcionario)
VALUES
(2, 'Finalizada', 3),
(4, 'Em andamento', 3),
(4, 'Finalizada', 3);


/* =====================================================
   3. CONSULTAS BÁSICAS
   ===================================================== */


/* 1 - Listar clientes */

SELECT *
FROM cliente;


/* 2 - Listar mesas */

SELECT *
FROM mesa;


/* 3 - Listar reservas */

SELECT *
FROM reserva;


/* 4 - Listar funcionários */

SELECT *
FROM funcionario;


/* =====================================================
   4. CONSULTAS INTERMEDIÁRIAS
   ===================================================== */


/* 1 - Reservas com nome do cliente */

SELECT
    r.id_reserva,
    c.nome AS cliente,
    r.data_hora_reserva,
    r.quantidade_pessoas,
    r.status_reserva
FROM reserva r
JOIN cliente c
    ON r.fk_cliente_id_cliente = c.id_cliente;

	
/* 2 - Atribuições com funcionário e mesa */

SELECT
    a.id_atribuicao,
    f.nome AS funcionario,
    m.numero AS mesa,
    a.data_hora_atribuicao
FROM atribuicao_mesa a
JOIN funcionario f
    ON a.fk_funcionario_id_funcionario = f.id_funcionario
JOIN mesa m
    ON a.fk_mesa_id_mesa = m.id_mesa;


/* 3 - Lista de espera com nome do cliente */

SELECT
    l.id_espera,
    c.nome AS cliente,
    l.quantidade_pessoas,
    l.status_espera
FROM lista_espera l
JOIN cliente c
    ON l.fk_cliente_id_cliente = c.id_cliente;


/* 4 - Quantidade de reservas por status */

SELECT
    status_reserva,
    COUNT(*) AS quantidade
FROM reserva
GROUP BY status_reserva;


/* =====================================================
   5. CONSULTAS AVANÇADAS
   ===================================================== */


/* 1 - Cliente com maior quantidade de reservas */

SELECT
    c.nome,
    COUNT(r.id_reserva) AS total_reservas
FROM cliente c
JOIN reserva r
    ON c.id_cliente = r.fk_cliente_id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_reservas DESC
LIMIT 1;


/* 2 - Funcionário com maior quantidade de atribuições */

SELECT
    f.nome,
    COUNT(a.id_atribuicao) AS total_atribuicoes
FROM funcionario f
JOIN atribuicao_mesa a
    ON f.id_funcionario = a.fk_funcionario_id_funcionario
GROUP BY f.id_funcionario, f.nome
ORDER BY total_atribuicoes DESC
LIMIT 1;

-- alteração da tabela Ocupacao 
-- inserindo a fk da mesa 

ALTER TABLE ocupacao
ADD COLUMN fk_mesa_id_mesa INT NULL,
ADD CONSTRAINT fk_ocupacao_mesa
FOREIGN KEY (fk_mesa_id_mesa)
REFERENCES mesa(id_mesa);

-- 3. Trigger para ocupar automaticamente a mesa TRIGGER 01 — AFTER INSERT

DROP TRIGGER IF EXISTS trg_ocupar_mesa;

DELIMITER $$

CREATE TRIGGER trg_ocupar_mesa
AFTER INSERT ON ocupacao
FOR EACH ROW
BEGIN

    -- Toda nova ocupacao precisa de uma mesa
    IF NEW.fk_mesa_id_mesa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Informe a mesa da ocupacao';
    END IF;

    -- Valida a quantidade de pessoas
    IF NEW.quantidade_pessoas <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade de pessoas invalida';
    END IF;

    -- Atualiza a mesa quando a ocupacao comeca
    IF NEW.status_ocupacao = 'Em andamento'
       AND NEW.data_hora_fim IS NULL THEN

        UPDATE mesa
        SET status_mesa = 'Ocupada'
        WHERE id_mesa = NEW.fk_mesa_id_mesa
          AND status_mesa = 'Disponível'
          AND capacidade >= NEW.quantidade_pessoas;

        -- Impede ocupar mesa indisponivel
        -- ou com capacidade insuficiente
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
              'Mesa indisponivel ou capacidade insuficiente';
        END IF;

    END IF;

END$$

DELIMITER ;

-- 4. Trigger para liberar automaticamente a mesa TRIGGER 02 — AFTER UPDATE

DROP TRIGGER IF EXISTS trg_liberar_mesa;

DELIMITER $$

CREATE TRIGGER trg_liberar_mesa
AFTER UPDATE ON ocupacao
FOR EACH ROW
BEGIN

    -- Verifica se uma ocupacao ativa terminou
    IF OLD.status_ocupacao = 'Em andamento'
       AND OLD.data_hora_fim IS NULL
       AND (
           NEW.status_ocupacao = 'Finalizada'
           OR NEW.data_hora_fim IS NOT NULL
       ) THEN

        UPDATE mesa
        SET status_mesa = 'Disponível'
        WHERE id_mesa = OLD.fk_mesa_id_mesa;

    END IF;

END$$

DELIMITER ;

-- Teste 1 — Verificar a mesa antes da ocupação

SELECT numero, capacidade, status_mesa
FROM mesa
WHERE id_mesa = 1;

-- Teste 2 — Registrar uma ocupação

INSERT INTO ocupacao (
    quantidade_pessoas,
    status_ocupacao,
    fk_funcionario_id_funcionario,
    fk_mesa_id_mesa
)
VALUES (
    2,
    'Em andamento',
    2,
    1
);

SET @ocupacao_teste = LAST_INSERT_ID();

-- verificando se teve atribuiçao a mesa 

SELECT numero, status_mesa
FROM mesa
WHERE id_mesa = 1;

 -- Teste 3 — Finalizar a ocupação
 
UPDATE ocupacao
SET
    status_ocupacao = 'Finalizada',
    data_hora_fim = NOW()
WHERE id_ocupacao = @ocupacao_teste;

-- verificando se finalixou a ocupaçao a mesa 

SELECT numero, status_mesa
FROM mesa
WHERE id_mesa = 1;
