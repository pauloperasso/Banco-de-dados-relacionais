create schema aulamar12_t3;
use aulamar12_t3;
create table tabela_teste
(
    dt_nascto DATE NOT NULL,
    dt_obito DATE NULL,
    hora_obito TIME NULL
);

describe tabela_teste;
insert into tabela_teste values (
date('1990-12-25'),  null, '') ;
select * from tabela_teste;
insert into tabela_teste values (
date('1960-02-25'), current_date, TIME('11:00:00.679'));
select * from tabela_teste;
select dt_nascto, dt_obito, datediff(dt_obito,dt_nascto)/365.25 from tabela_teste;
