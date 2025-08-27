-- AULA 30 ABRIL T3S1 - CONSULTAS: SELECT --
-- ESTRUTURA DO COMANDO SELECT --
-- SELECT MAIS BÁSICO QUE TEM --
SELECT * FROM paciente;
-- SELECT DISCRIMINANDO AS COLUNAS --
SELECT nome_pac, end_pac, dt_nascto_pac
FROM paciente
WHERE sexo_pac = 'F';
-- 3 - funções de formatção de caracteres 
-- UCASE ou UPPER -> maiusculo
-- LCASE ou LOWER -> minusculo
-- INITCAP -> primeira maisculo, restante minusculo
SELECT UPPER(nome_pac) AS "Nome_Paciente",
LOWER(end_pac) AS "Endereço_minusculo"
-- INITCAP(tipo_sanguineo) AS "Tipo Sangue" --
FROM paciente;

--  operador de concatenacao CONCAT -> "gruda" uma string na outra eliminando os espacos em branco --
SELECT CONCAT ("Hoje é vespera de", " feriado") AS "Minha Frase!";
SELECT CONCAT (CONCAT(UPPER(nome_pac), " reside em "), LOWER( end_pac)) AS "Endereço do paciente" FROM paciente WHERE sexo_pac != "M";
SELECT num_internacao AS "Número", dt_hora_internacao AS "Entrada Internação", motivo AS "Motivo da internação", situacao_internacao AS "Situação Internação"
FROM internacao
WHERE dt_hora_internacao >= current_timestamp - INTERVAL '30' DAY AND dt_hora_saida IS NOT NULL;

-- USO DO OR NO SELECT / MOSTRA OS PACIENTES QUE NÃO SÃO DO SEXO FEMININO OU TEM MAIS DE 10 ANOS --
SELECT nome_pac, dt_nascto_pac, TRUNCATE(DATEDIFF(current_date, dt_nascto_pac)/365.25,1),
sexo_pac AS "Sexo Paciente"
FROM paciente
WHERE DATEDIFF(current_date, dt_nascto_pac)/365.25 > 10 OR sexo_pac != 'F';

-- OPERADOR BEETWEEN -- 
SELECT * FROM Internacao
WHERE dt_hora_internacao BETWEEN current_timestamp - INTERVAL '1' MONTH 
AND current_timestamp - INTERVAL '20' DAY ;

-- OPERADOR  LIKE ( BUSCA NÃO EXATA, APROXIMADA ) --
SELECT nome_pac, end_pac, dt_nascto_pac FROM paciente WHERE UPPER(nome_pac) LIKE '%SOARES%';

-- TODOS OS PACIENTES QUE MORAM EM RUA ( % SERVE COMO CORINGA, DE TUDO QUE VEM ANTES E TUDO QUE VEM DEPOIS ) --
SELECT nome_pac, end_pac, dt_nascto_pac FROM paciente WHERE UPPER(end_pac) LIKE 'RUA%' OR 'R.%';

-- TODOS OS PACIENTES QUE MORAM NO IPIRANGA ( UNDERLINE SERVE COMO CORINGA DE 1 CARACTER )
SELECT nome_pac, end_pac, dt_nascto_pac FROM paciente WHERE UPPER(end_pac) LIKE '% _P_RANGA%'  ;

-- TODOS OS MÉDICOS QUE O ÚLTIMO NOME É SANTOS --
SELECT nome_med, sexo_med FROM medico WHERE LOWER(nome_med) LIKE '%santos';

-- INTERNAÇÃO DO MÊS PASSADO ( O = É PARA COMPARAÇÃO, QUE NESSE CASO É DE INTERVALOS DE DATAS) --
SELECT num_internacao, dt_hora_internacao, motivo FROM internacao WHERE EXTRACT(MONTH FROM dt_hora_internacao) >= EXTRACT(MONTH FROM current_date) -1;

-- INTERNAÇÃO DOS ÚLTIMOS 20 DIAS --
SELECT i.* FROM internacao i  WHERE dt_hora_internacao >= current_timestamp - INTERVAL '20' DAY ;

-- CONSULTAS COM MAIS DE UMA TABELA --

SELECT p.nome_pac AS Paciente , p.dt_nascto_pac ,p.sexo_pac AS Sexo,
i.num_internacao, i.motivo, i.dt_hora_internacao AS Entrada
FROM p. paciente INNER JOIN internacao i
ON ( id_paciente = id_paciente )   ;  -- colunas de junção PK = FK

-- CONSULTA COM O INNER JOIN (EXEMPLO) -- 
SELECT p.nome_pac AS Paciente , p.dt_nascto_pac ,p.sexo_pac AS Sexo,
i.num_internacao, i.motivo, i.dt_hora_internacao AS Entrada,
lt.num_leito AS Leito, lt.num_quarto AS Quarto, lt.tipo_leito AS "Tipo Leito"
FROM paciente p  JOIN internacao i
             ON ( id_paciente = id_paciente ) 
             JOIN leito lt
             ON ( lt.num_leito = i.num_leito AND lt.num_quarto = i.num_quarto )
WHERE EXTRACT( YEAR FROM dt_hora_internacao) =
			EXTRACT(YEAR FROM dt_hora_internacao) =
            EXTRACT(YEAR FROM current_date) AND p.sexo_pac IN ('M', 'F'); 
            

                              