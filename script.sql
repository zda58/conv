set global local_infile=ON;

drop database if exists proj;
create database if not exists proj;
use proj;

drop table if exists demo_j;
create table demo_j (
	seqn int primary key,
    gender int,
    age_at_screening float
);

load data local
infile '~/data/DEMO_J.csv'
into table demo_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

create or replace view healthy as
select seqn
from demo_j;

select * from demo_j;