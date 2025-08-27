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
CREATE TABLE leito (
num_leito TINYINT NOT NULL,
num_quarto TINYINT NOT NULL,
tipo_leito CHAR(15) NOT NULL, 
situacao_leito CHAR(15) NOT NULL CHECK (situacao_leito IN ('Ocupado', 'Disponível', 'Manutenção', 'Desativado')),
PRIMARY KEY (num_leito, num_quarto));
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
INSERT INTO medico VALUES (400, "Jonas Cleiton Silva", DATE('1984-12-24'), 'M', 'Em atividade', '87654321SP', 'Efetivo');
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

-- EXERCÍCIO 01 --
-- CRIANDO TABELA MÉDICO RESIDENTE --
DROP TABLE IF EXISTS medico_residente CASCADE;
CREATE TABLE medico_residente (cod_funcional_residente INTEGER PRIMARY KEY, dt_inicio DATE, dt_termino DATE,
FOREIGN KEY (medico_efetivo_Cod_funcional_efetivo) REFERENCES medico_efetivo(especialidade) ON DELETE RESTRICT ON UPDATE CASCADE, 
FOREIGN KEY (Cod_funcional_residente) REFERENCES medico(Cod_funcional) ON DELETE RESTRICT ON UPDATE CASCADE);
-- CRIANDO A TABELA ASSOCIADO --
DROP TABLE IF EXISTS associado CASCADE;
CREATE TABLE associado ( id_paciente INTEGER PRIMARY KEY, convenio_medico INTEGER NOT NULL, tipo_de_plano VARCHAR(45) NOT NULL, num_associado INT(10) NOT NULL,
FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE, 
FOREIGN KEY (id_convenio_medico) REFERENCES convenio_medico(id_convenio_medico) ON DELETE RESTRICT ON UPDATE CASCADE);
-- CRINANDO A TABELA CONVÊNIO MÉDICO --
DROP TABLE IF EXISTS convenio_medico CASCADE;
CREATE TABLE convenio_medico ( id_convenio_medico INTEGER PRIMARY KEY, nome_convenio VARCHAR(45) NOT NULL, fone INTEGER(11) NOT NULL);
-- CRIANDO TABELA ESPECIALIZAÇÃO --
DROP TABLE IF EXISTS especialização CASCADE;
CREATE TABLE especialização ( FOREIGN KEY (medico_cod_funcional) REFERENCES medico(cod_funcional) ON DELETE RESTRICT ON UPDATE CASCADE, 
FOREIGN KEY (especialidade_idEspecialidade) REFERENCES especialidade(id_especialidade) ON DELETE RESTRICT ON UPDATE CASCADE);
-- CRIANDO TABELA ESPECIALIDADE --
DROP TABLE IF EXISTS especialidade CASCADE;
CREATE TABLE especialidade ( id_especialidade INTEGER PRIMARY KEY, nome_especialidade VARCHAR(45) NOT NULL);

-- EXERCÍCIO 02 --
-- NOVA COLUNA TIPO SANGUÍNEO EM PACIENTE --
ALTER TABLE paciente ADD COLUMN tipo_sanguineo VARCHAR(3);
-- RENOMEANDO COLUNA TIPO SANGUÍNEO --
ALTER TABLE paciente RENAME COLUMN tipo_sanguineo TO tp_sanguineo;
-- RENOMEANDO TABELA ASSOCIADO PARA CONVENIADO --
RENAME TABLE associado TO conveniado;
-- ALTERANDO O CHAR PARA VARCHAR --
ALTER TABLE internacao MODIFY COLUMN situacao_internacao VARCHAR(30);

-- EXERCÍCIO 03 -- 

-- POPULANDO A TABELA ESPECIALIZAÇÃO --
-- CRIEI UM SEGUNDO MÉDICO NA TABELA MÉDICO --
INSERT INTO especializaçao VALUES (300, 40);
INSERT INTO especializacao VALUES (400, 50);

-- POPULANDO TABELA ESPECIALIDADE --
INSERT INTO especialidade VALUES (40, "Urologista");
INSERT INTO especialidade VALUES (50, "Ortopedista");

-- POPULANDO TABELA MEDICO RESIDENTE --
INSERT INTO medico_residente VALUES (2000, DATE('04-28-2025'), NULL);
INSERT INTO medico_residente VALUES (4000, DATE('02-25-2025'), NULL); 
DESCRIBE medico_residente;

-- POPULANDO TABELA CONVENIADO --
INSERT INTO conveniado VALUES (2, 70, "Black Diamond", 30820);
INSERT INTO conveniado VALUES (3, 71, "Gold", 30822);
DESCRIBE conveniado;

-- POPULANDO TABELA CONVENIO MÉDICO --
INSERT INTO convenio_medico VALUES (90, "Prevent Senior", 11987654321);
INSERT INTO convenio_medico VALUES (91, "Sul-America", 11223456789);

-- NOME INTEGRANTES: --
-- PAULO PERASSO - RA: 25.00218-9
-- ENZO CHAGAS - RA: 25.00598-4

