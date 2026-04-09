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


drop table if exists slq_j;
create table slq_j (
    seqn int primary key,
    told_doctor_trouble_sleeping int,
    feels_sleepy_during_daytime int
);

load data local
infile '~/data/SLQ_J.csv'
into table slq_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(
    seqn,
    @dummy1, /*usual_sleep_time_weekday*/
    @dummy2, /*usual_num_hours_slept_weekday*/
    @dummy3, /*usual_sleep_time_weekend,*/
    @dummy4, /*usual_num_hours_slept_weekend*/
    @dummy5, /*snoring_frequency*/
    told_doctor_trouble_sleeping,
    feels_sleepy_during_daytime
);

drop table if exists mcq_j;
create table mcq_j (
    seqn int primary key,
    congestive_heart_failure int,
    coronary_heart_disease int,
    heart_attack int,
    thyroid_problem int,
    chronic_bronchitis int,
    fatty_liver int
);

load data local infile '~/data/MCQ_J.csv'
into table mcq_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(
	seqn,
	congestive_heart_failure,
    coronary_heart_disease,
	heart_attack,
	thyroid_problem,
	chronic_bronchitis,
	@dummy1, /*liver_condition*/
	fatty_liver
);

drop table if exists biopro_j;
create table biopro_j (
    seqn int primary key,
    alt_u_l float,
	albumin_g_dl float,
	alp_IU_L float,
	ast_u_l float,
	bicarbonate_mmol_L float,
	blood_urea_nitrogen_mg_dl float,
	chloride_mmol_L float,
	cpk_IU_L float,
	creatinine_mg_dl float,
	globulin_g_dL float,
	glucose_mg_dl float,
	ggt_iu_l float,
	iron_ug_dl float,
	ldh_IU_L float,
	osmolality_mmol_kg float,
	phosphorus_mg_dL float,
	potassium_mmol_L float,
	sodium_mmol_L float,
	total_bilirubin_mg_dl float,
	calcium_mg_dL float,
	cholesterol_mg_dl float,
	total_protein_g_dl float,
	triglycerides_mg_dl float,
	uric_acid_mg_dl float
);

load data local
infile '~/data/BIOPRO_J.csv'
into table biopro_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows
(
    seqn,
    alt_u_l,
    albumin_g_dl,
    alp_IU_L,
    ast_u_l,
    bicarbonate_mmol_L,
    blood_urea_nitrogen_mg_dl,
    chloride_mmol_L,
    cpk_IU_L,
    creatinine_mg_dl,
    globulin_g_dL,
    glucose_mg_dl,
    ggt_iu_l,
    iron_ug_dl,
    ldh_IU_L,
    osmolality_mmol_kg,
    phosphorus_mg_dL,
    potassium_mmol_L,
    sodium_mmol_L,
    total_bilirubin_mg_dl,
    calcium_mg_dL,
    cholesterol_mg_dl,
    total_protein_g_dl,
    triglycerides_mg_dl,
    uric_acid_mg_dl
);

create or replace view healthy as
select d.seqn
from demo_j d
left join mcq_j m on d.seqn = m.seqn
where
	congestive_heart_failure != 1
    and coronary_heart_disease != 1
	and heart_attack != 1
	and thyroid_problem != 1
	and chronic_bronchitis != 1
	and fatty_liver != 1;

create or replace view biomarker_baseline as
select
    avg(b.alt_u_l) as alt_mean,
    stddev_pop(b.alt_u_l) as alt_std,

    avg(b.albumin_g_dl) as albumin_mean,
    stddev_pop(b.albumin_g_dl) as albumin_std,

    avg(b.alp_iu_l) as alp_mean,
    stddev_pop(b.alp_iu_l) as alp_std,

    avg(b.ast_u_l) as ast_mean,
    stddev_pop(b.ast_u_l) as ast_std,

    avg(b.bicarbonate_mmol_l) as bicarbonate_mean,
    stddev_pop(b.bicarbonate_mmol_l) as bicarbonate_std,

    avg(b.blood_urea_nitrogen_mg_dl) as bun_mean,
    stddev_pop(b.blood_urea_nitrogen_mg_dl) as bun_std,

    avg(b.chloride_mmol_l) as chloride_mean,
    stddev_pop(b.chloride_mmol_l) as chloride_std,

    avg(b.cpk_iu_l) as cpk_mean,
    stddev_pop(b.cpk_iu_l) as cpk_std,

    avg(b.creatinine_mg_dl) as creatinine_mean,
    stddev_pop(b.creatinine_mg_dl) as creatinine_std,

    avg(b.globulin_g_dl) as globulin_mean,
    stddev_pop(b.globulin_g_dl) as globulin_std,

    avg(b.glucose_mg_dl) as glucose_mean,
    stddev_pop(b.glucose_mg_dl) as glucose_std,

    avg(b.ggt_iu_l) as ggt_mean,
    stddev_pop(b.ggt_iu_l) as ggt_std,

    avg(b.iron_ug_dl) as iron_mean,
    stddev_pop(b.iron_ug_dl) as iron_std,

    avg(b.ldh_iu_l) as ldh_mean,
    stddev_pop(b.ldh_iu_l) as ldh_std,

    avg(b.osmolality_mmol_kg) as osmolality_mean,
    stddev_pop(b.osmolality_mmol_kg) as osmolality_std,

    avg(b.phosphorus_mg_dl) as phosphorus_mean,
    stddev_pop(b.phosphorus_mg_dl) as phosphorus_std,

    avg(b.potassium_mmol_l) as potassium_mean,
    stddev_pop(b.potassium_mmol_l) as potassium_std,

    avg(b.sodium_mmol_l) as sodium_mean,
    stddev_pop(b.sodium_mmol_l) as sodium_std,

    avg(b.total_bilirubin_mg_dl) as bilirubin_mean,
    stddev_pop(b.total_bilirubin_mg_dl) as bilirubin_std,

    avg(b.calcium_mg_dl) as calcium_mean,
    stddev_pop(b.calcium_mg_dl) as calcium_std,

    avg(b.cholesterol_mg_dl) as cholesterol_mean,
    stddev_pop(b.cholesterol_mg_dl) as cholesterol_std,

    avg(b.total_protein_g_dl) as protein_mean,
    stddev_pop(b.total_protein_g_dl) as protein_std,

    avg(b.triglycerides_mg_dl) as triglycerides_mean,
    stddev_pop(b.triglycerides_mg_dl) as triglycerides_std,

    avg(b.uric_acid_mg_dl) as uric_acid_mean,
    stddev_pop(b.uric_acid_mg_dl) as uric_acid_std
from biopro_j b
join healthy h on b.seqn = h.seqn;

select * from biomarker_baseline b;
select * from biopro_j b join healthy h on b.seqn = h.seqn limit 9999;

drop table if exists target_cohort;
create temporary table target_cohort as
select seqn
from mcq_j
where
    #coronary_heart_disease = 1
    #congestive_heart_failure = 1
    #heart_attack = 1
    #thyroid_problem != 1
	#chronic_bronchitis != 1
    fatty_liver = 1
;

drop table if exists cohort_means;
create temporary table cohort_means as
select
    avg(b.alt_u_l) as alt_mean,
    avg(b.albumin_g_dl) as albumin_mean,
    avg(b.alp_iu_l) as alp_mean,
    avg(b.ast_u_l) as ast_mean,
    avg(b.bicarbonate_mmol_l) as bicarbonate_mean,
    avg(b.blood_urea_nitrogen_mg_dl) as bun_mean,
    avg(b.chloride_mmol_l) as chloride_mean,
    avg(b.cpk_iu_l) as cpk_mean,
    avg(b.creatinine_mg_dl) as creatinine_mean,
    avg(b.globulin_g_dl) as globulin_mean,
    avg(b.glucose_mg_dl) as glucose_mean,
    avg(b.ggt_iu_l) as ggt_mean,
    avg(b.iron_ug_dl) as iron_mean,
    avg(b.ldh_iu_l) as ldh_mean,
    avg(b.osmolality_mmol_kg) as osmolality_mean,
    avg(b.phosphorus_mg_dl) as phosphorus_mean,
    avg(b.potassium_mmol_l) as potassium_mean,
    avg(b.sodium_mmol_l) as sodium_mean,
    avg(b.total_bilirubin_mg_dl) as bilirubin_mean,
    avg(b.calcium_mg_dl) as calcium_mean,
    avg(b.cholesterol_mg_dl) as cholesterol_mean,
    avg(b.total_protein_g_dl) as protein_mean,
    avg(b.triglycerides_mg_dl) as triglycerides_mean,
    avg(b.uric_acid_mg_dl) as uric_acid_mean
from biopro_j b
join target_cohort t on b.seqn = t.seqn;

select
    (c.alt_mean - b.alt_mean) / b.alt_std as alt_z,
    (c.albumin_mean - b.albumin_mean) / b.albumin_std as albumin_z,
    (c.alp_mean - b.alp_mean) / b.alp_std as alp_z,
    (c.ast_mean - b.ast_mean) / b.ast_std as ast_z,
    (c.bicarbonate_mean - b.bicarbonate_mean) / b.bicarbonate_std as bicarbonate_z,
    (c.bun_mean - b.bun_mean) / b.bun_std as bun_z,
    (c.chloride_mean - b.chloride_mean) / b.chloride_std as chloride_z,
    (c.cpk_mean - b.cpk_mean) / b.cpk_std as cpk_z,
    (c.creatinine_mean - b.creatinine_mean) / b.creatinine_std as creatinine_z,
    (c.globulin_mean - b.globulin_mean) / b.globulin_std as globulin_z,
    (c.glucose_mean - b.glucose_mean) / b.glucose_std as glucose_z,
    (c.ggt_mean - b.ggt_mean) / b.ggt_std as ggt_z,
    (c.iron_mean - b.iron_mean) / b.iron_std as iron_z,
    (c.ldh_mean - b.ldh_mean) / b.ldh_std as ldh_z,
    (c.osmolality_mean - b.osmolality_mean) / b.osmolality_std as osmolality_z,
    (c.phosphorus_mean - b.phosphorus_mean) / b.phosphorus_std as phosphorus_z,
    (c.potassium_mean - b.potassium_mean) / b.potassium_std as potassium_z,
    (c.sodium_mean - b.sodium_mean) / b.sodium_std as sodium_z,
    (c.bilirubin_mean - b.bilirubin_mean) / b.bilirubin_std as bilirubin_z,
    (c.calcium_mean - b.calcium_mean) / b.calcium_std as calcium_z,
    (c.cholesterol_mean - b.cholesterol_mean) / b.cholesterol_std as cholesterol_z,
    (c.protein_mean - b.protein_mean) / b.protein_std as protein_z,
    (c.triglycerides_mean - b.triglycerides_mean) / b.triglycerides_std as triglycerides_z,
    (c.uric_acid_mean - b.uric_acid_mean) / b.uric_acid_std as uric_acid_z
from cohort_means c
cross join biomarker_baseline b;


create or replace view disease_baseline as
select
    avg(m.congestive_heart_failure = 1) as chf_prev,
    avg(m.coronary_heart_disease = 1) as chd_prev,
	avg(m.heart_attack = 1) as heart_attack_prev,
	avg(m.thyroid_problem = 1) as thyroid_problem_prev,
	avg(m.chronic_bronchitis = 1) as chronic_bronchitis_prev,
	avg(m.fatty_liver = 1) as fatty_liver_prev
from mcq_j m
join biopro_j b on m.seqn = b.seqn;

drop temporary table if exists biomarker_cohort;
create temporary table biomarker_cohort as
select seqn
from biopro_j
where
    alt_u_l > 40
    or ast_u_l > 40
    or ggt_iu_l > 60;

select count(*) as biomarker_cohort_count from biomarker_cohort;

drop table if exists cohort_disease_prev;
create temporary table cohort_disease_prev as
select
    avg(m.congestive_heart_failure = 1) as chf_prev,
    avg(m.coronary_heart_disease = 1) as chd_prev,
	avg(m.heart_attack = 1) as heart_attack_prev,
	avg(m.thyroid_problem = 1) as thyroid_problem_prev,
	avg(m.chronic_bronchitis = 1) as chronic_bronchitis_prev,
	avg(m.fatty_liver = 1) as fatty_liver_prev
from mcq_j m
join biomarker_cohort b on m.seqn = b.seqn;

select
    c.fatty_liver_prev / nullif(b.fatty_liver_prev, 0) as fatty_liver_risk,
    c.chd_prev / nullif(b.chd_prev, 0) as chd_risk,
    c.heart_attack_prev / nullif(b.heart_attack_prev, 0) as heart_attack_risk,
    c.chf_prev / nullif(b.chf_prev, 0) as chf_risk
from cohort_disease_prev c
cross join disease_baseline b;