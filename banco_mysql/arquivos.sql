CREATE DATABASE dados;
USE dados;

CREATE TABLE cadastro_operacao (
    registroANS VARCHAR(10) PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL,
    razaoSocial VARCHAR(200) NOT NULL,
    nomeFantasia VARCHAR(100),
    modalidade VARCHAR(50) NOT NULL,
    logradouro VARCHAR(50),
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(60),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(30) NOT NULL,
    uf VARCHAR(5) NOT NULL,
    cep VARCHAR(10),
    ddd VARCHAR(5),
    tel VARCHAR(15),
    fax VARCHAR(15),
    email VARCHAR(50),
    representante VARCHAR(100) NOT NULL,
    cargoRepresentante VARCHAR(50) NOT NULL,
    data_registro_ANS DATE NOT NULL
) DEFAULT CHARSET=utf8mb4;


-- Importação dos dados das operadoras
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\Relatorio_cadop.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');

-- Tabelas para os trimestres de 2023 e 2024
CREATE TABLE primeirotri_2023 (
    dataPri DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\1T2023.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');




CREATE TABLE segundotri_2023 (
    dataSeg DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\2t2023.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');


CREATE TABLE terceirotri_2023 (
    dataTri DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\3T2023.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');


CREATE TABLE quartotri_2023 (
    dataQuar DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\4T2023.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');


CREATE TABLE primeirotri_2024 (
    dataPri DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\1T2024.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');

CREATE TABLE segundotri_2024 (
    dataSeg DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\2T2024.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');

CREATE TABLE  terceirotri_2024 (
    dataTri DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\3T2024.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');

CREATE TABLE quartotri_2024 (
    dataQuar DATE NOT NULL,
    reg_ANS VARCHAR(10) NOT NULL,
    cd_conta_contabil VARCHAR(15) NOT NULL,
    descricao MEDIUMTEXT NOT NULL,
    vl_saldo_final BIGINT
) DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\banco_mysql\mysql\4T2024.csv' 
INTO TABLE cadastro_operacao
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET data_registro_ANS = STR_TO_DATE(data_registro_ANS, '%d/%m/%Y');


-- Repita o comando LOAD DATA INFILE para os outros trimestres de 2023 e 2024, ajustando os nomes das tabelas e arquivos.

-- Queries Analíticas
-- 10 operadoras com maiores despesas no último trimestre (assumindo 3T2024 como o último)
SELECT c.nomeFantasia, c.razaoSocial, t.reg_ANS, t.vl_saldo_final
FROM terceirotri_2024 AS t
JOIN cadastrosop AS c ON c.registroANS = t.reg_ANS
WHERE t.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
ORDER BY t.vl_saldo_final DESC
LIMIT 10;

-- 10 operadoras com maiores despesas no último ano (2024)
SELECT c.nomeFantasia, c.razaoSocial, t.reg_ANS, SUM(t.vl_saldo_final) AS total_despesas
FROM (
    SELECT * FROM primeirotri_2024
    UNION ALL
    SELECT * FROM segundotri_2024
    UNION ALL
    SELECT * FROM terceirotri_2024
    UNION ALL
    SELECT * FROM quartotri_2024
) AS t
JOIN cadastro_operacao AS c ON c.registroANS = t.reg_ANS
WHERE t.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR'
GROUP BY c.registroANS
ORDER BY total_despesas DESC
LIMIT 10;




show variables like "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads"


