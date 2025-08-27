SELECT @@default_storage_engine;
create schema internacao_t3s1;
use internacao_t3s1;
DROP TABLE IF EXISTS paciente CASCADE;
-- CRIANDO TABELA PACIENTE --
CREATE TABLE paciente ( id_paciente SMALLINT PRIMARY KEY,
nome_pac VARCHAR(50) NOT NULL,
dt_nascto_pac DATE NOT NULL, 
sexo_pac CHAR(1) NOT NULL CHECK (sexo_pac IN('M', 'F')),
nome_responsavel VARCHAR(50) NULL );
DESCRIBE paciente;
ALTER TABLE paciente ADD COLUMN endereco_pac VARCHAR(60) NOT NULL, ADD COLUMN fone_pac NUMERIC (11) NOT NULL;
-- MODIFICANDO O TAMANHO DA COLUNA DO ENDEREÇO --
ALTER TABLE paciente MODIFY COLUMN endereco_pac VARCHAR(75);
-- RENOMEANDO A COLUNA --
ALTER TABLE paciente RENAME COLUMN endereco_pac TO end_pac;
-- POPULANDO A TABELA PACIENTE --
INSERT INTO paciente VALUES (2000, "Ruth Maria Soares", DATE('2018-12-05'), 'F', 'Theodoro Rubinato Soares', 'Rua Da Alegria, 100', 11987654321);
SELECT * FROM paciente;
-- ATUALIZANDO O TELEFONE --
UPDATE paciente SET fone_pac = 11998877665 WHERE id_paciente = 2000;
-- CRIANDO A TABELA QUARTO --
DROP TABLE IF EXISTS quarto CASCADE;
CREATE TABLE quarto ( num_quarto TINYINT PRIMARY KEY, 
tipo_quarto CHAR(15) NOT NULL,
capacidade_leitos TINYINT NOT NULL DEFAULT 1);
DESCRIBE quarto;
-- POPULANDO QUARTO --
INSERT INTO quarto VALUES ( 1, 'Semi-UTI', default);
SELECT * FROM quarto;
-- TABELA LEITO --
DROP TABLE IF EXISTS leito CASCADE;
CREATE TABLE leito ( num_leito TINYINT NOT NULL,
num_quarto TINYINT NOT NULL,
tipo_leito CHAR(15) NOT NULL, 
situacao_leito CHAR(15) NOT NULL CHECK (situacao_leito IN ("Ocupado", "Disponível", "Manutenção", "Desativado")),
PRIMARY KEY (num_leito, num_quarto),
FOREIGN KEY (num_quarto) REFERENCES quarto(num_quarto) ON DELETE RESTRICT ON UPDATE CASCADE);
-- POPULANDO LEITO (tentamos situação "Quebrado" e deu erro, check funcionou) --
INSERT INTO leito VALUES (5, 1, "Eletrônico", "Disponível");
SELECT * FROM leito;
-- TABELA MÉDICO --
DROP TABLE IF EXISTS medico CASCADE;
CREATE TABLE medico ( cod_func SMALLINT PRIMARY KEY,
nome_med VARCHAR(50) NOT NULL, 
dt_nascto_med DATE NULL,
sexo_med CHAR(1) NOT NULL CHECK (sexo_med IN("M", "F")),
situacao_med CHAR(15) NOT NULL CHECK (situacao_med IN("Em atividade", "Inativo", "Licensa", "Férias")),
crm_med CHAR(10) NOT NULL UNIQUE,
tipo_medico CHAR(10) NOT NULL CHECK (tipo_medico IN("Residente", "Efetivo")));
SELECT * FROM medico;
-- POPULANDO A TABELA MÉDICO -- 
INSERT INTO medico VALUES (300, "Ruth Ester Jacovich", DATE('1990-05-15'), 'F', 'Em atividade', '12345678SP', 'Efetivo');
-- TABELA MÉDICO EFETIVO --
DROP TABLE IF EXISTS medico_efetivo CASCADE;
CREATE TABLE medico_efetivo ( cod_med_efetivo SMALLINT PRIMARY KEY REFERENCES medico(cod_func) ON DELETE CASCADE ON UPDATE CASCADE);
-- POPULANDO MÉDICO EFETIVO --
INSERT INTO medico_efetivo VALUES (300);
SELECT * FROM medico_efetivo;
-- CRIANDO A TABELA INTERNAÇÃO (MAIN) --
DROP TABLE IF EXISTS internacao CASCADE;
CREATE TABLE internacao ( num_internacao INTEGER auto_increment PRIMARY KEY,
dt_hora_internacao TIMESTAMP NOT NULL DEFAULT current_timestamp, 
dt_hora_alta TIMESTAMP NULL,
motivo VARCHAR(30) NOT NULL,
id_paciente SMALLINT NOT NULL,
num_leito TINYINT NOT NULL,
num_quarto TINYINT NOT NULL, 
cod_med_responsavel SMALLINT NOT NULL,
situacao_internacao CHAR(20) NOT NULL,
FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (num_leito, num_quarto) REFERENCES leito(num_leito, num_quarto) ON DELETE RESTRICT ON UPDATE CASCADE, 
FOREIGN KEY (cod_med_responsavel) REFERENCES medico_efetivo(cod_med_efetivo) ON DELETE RESTRICT ON UPDATE CASCADE);
DESCRIBE internacao;
-- POPULANDO INTERNAÇÃO --
INSERT INTO internacao VALUES ( null, default, null, 'Febre alta, tosse, coriza', 2000, 5, 1, 300, "Em andamento");
SELECT * FROM internacao;
-- CRIANDO TABELA MÉDICO RESIDENTE --
DROP TABLE IF EXISTS medico_residente CASCADE;
CREATE TABLE medico_residente;


