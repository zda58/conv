set global local_infile=ON;

drop database if exists biorisk;
create database if not exists biorisk;
use biorisk;

drop table if exists gender_lookup;
create table gender_lookup (
    code int primary key,
    meaning varchar(50)
);
insert into gender_lookup (code, meaning) values 
(1, 'Male'), (2, 'Female');

drop table if exists response_lookup;
create table response_lookup (
    code int primary key,
    meaning varchar(50)
);
insert into response_lookup (code, meaning) values 
(1, 'Yes'), (2, 'No'), (7, 'Refused'), (9, 'Don''t Know');

drop table if exists frequency_lookup;
create table frequency_lookup (
    code int primary key,
    meaning varchar(50)
);

insert into frequency_lookup (code, meaning) values 
(0, 'Not at all'), (1, 'Several days'), (2, 'More than half the days'),
(3, 'Nearly every day'), (7, 'Refused'), (9, 'Don''t Know');

drop table if exists demo_j;
create table demo_j (
	seqn int primary key,
    gender int,
    age_at_screening float,
    foreign key (gender) references gender_lookup (code)
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
    foreign key (seqn) references demo_j (seqn),
    foreign key (told_doctor_trouble_sleeping) references response_lookup (code)
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
    @dummy6 /*feels_sleepy_during_daytime*/
);

drop table if exists dpq_j;
create table dpq_j (
    seqn int primary key,
    little_interest_in_doing_things int,
    feeling_depressed int,
    sleep_issues int,
    low_energy int,
    appetite_issues int,
    foreign key (seqn) references demo_j (seqn),
    foreign key (little_interest_in_doing_things) references frequency_lookup (code),
    foreign key (feeling_depressed) references frequency_lookup (code),
    foreign key (sleep_issues) references frequency_lookup (code),
    foreign key (low_energy) references frequency_lookup (code),
    foreign key (appetite_issues) references frequency_lookup (code)
);

load data local infile '~/data/DPQ_J.csv'
into table dpq_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

drop table if exists vid_j;
create table vid_j (
    seqn int primary key,
    vitamin_d_level_nmol_L float,
    foreign key (seqn) references demo_j (seqn)
);

load data local infile '~/data/VID_J.csv'
into table vid_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

drop table if exists diet_j;
create table diet_j (
    seqn int primary key,
    energy_kcal float,
    protein_g float,
    carbs_g float,
    sugars_g float,
    fiber_g float,
    total_fat_g float,
    saturated_fat_g float,
    monounsaturated_fat_g float,
    polyunsaturated_fat_g float,
    cholesterol_mg float,
    vitamin_e_alpha_tocopherol_mg float,
    vitamin_e_added_alpha_tocopherol_mg float,
    retinol_mcg float,
    vitamin_a_mcg float,
    alpha_carotene_mcg float,
    beta_carotene_mcg float,
    beta_cryptoxanthin_mcg float,
    lycopene_mcg float,
    lutein_zeaxanthin_mcg float,
    vitamin_b1_mg float,
    vitamin_b2_mg float,
    niacin_mg float,
    vitamin_b6_mg float,
    folate_total_mcg float,
    folic_acid_mcg float,
    food_folate_mcg float,
    folate_dfe_mcg float,
    choline_mg float,
    vitamin_b12_mcg float,
    vitamin_b12_added_mcg float,
    vitamin_c_mg float,
    vitamin_d_mcg float,
    vitamin_k_mcg float,
    calcium_mg float,
    phosphorus_mg float,
    magnesium_mg float,
    iron_mg float,
    zinc_mg float,
    copper_mg float,
    sodium_mg float,
    potassium_mg float,
    selenium_mcg float,
    caffeine_mg float,
    theobromine_mg float,
    alcohol_g float,
    water_intake_g float,
	foreign key (seqn) references demo_j(seqn)
);

load data local infile '~/data/DR1TOT_J.csv'
into table diet_j
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

drop table if exists mcq_j;
create table mcq_j (
    seqn int primary key,
    congestive_heart_failure int,
    coronary_heart_disease int,
    heart_attack int,
    thyroid_problem int,
    chronic_bronchitis int,
    fatty_liver int,
    foreign key (seqn) references demo_j (seqn),
    foreign key (congestive_heart_failure) references response_lookup (code),
    foreign key (coronary_heart_disease) references response_lookup (code),
    foreign key (heart_attack) references response_lookup (code),
    foreign key (thyroid_problem) references response_lookup (code),
    foreign key (chronic_bronchitis) references response_lookup (code),
    foreign key (fatty_liver) references response_lookup (code)
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
	uric_acid_mg_dl float,
    foreign key (seqn) references demo_j (seqn)
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

/*
See how different health condition populations have biomarkers deviating from
healthy population means
*/

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

drop table if exists target_cohort;
create temporary table target_cohort as
select seqn
from mcq_j
where
    /*
    coronary_heart_disease = 1
    congestive_heart_failure = 1
    heart_attack = 1
    thyroid_problem != 1
	chronic_bronchitis != 1
    */
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

/*
Examine how high alanine aminotransferse and triglycerides
increase your risk of heart, liver, and thyroid health conditions
*/

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
where alt_u_l > 25
and triglycerides_mg_dl > 130;

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
    c.chf_prev / nullif(b.chf_prev, 0) as chf_risk,
    c.chd_prev / nullif(b.chd_prev, 0) as chd_risk,
    c.heart_attack_prev / nullif(b.heart_attack_prev, 0) as heart_attack_risk,
    c.thyroid_problem_prev / nullif(b.thyroid_problem_prev, 0) as thyroid_problem_risk,
    c.chronic_bronchitis_prev / nullif(b.chronic_bronchitis_prev, 0) as chronic_bronchitis_risk,
    c.fatty_liver_prev / nullif(b.fatty_liver_prev, 0) as fatty_liver_risk
from cohort_disease_prev c
cross join disease_baseline b;

/*
Examine if there are statistically significant difference in depressed versus
non depressed diets
*/

drop table if exists diet_baseline;
create temporary table diet_baseline as
select
    avg(d.sugars_g) as sugars_mean, stddev_pop(d.sugars_g) as sugars_std,
    avg(d.fiber_g) as fiber_mean, stddev_pop(d.fiber_g) as fiber_std,
    avg(d.saturated_fat_g) as sat_fat_mean, stddev_pop(d.saturated_fat_g) as sat_fat_std,
    avg(d.folate_total_mcg) as folate_mean, stddev_pop(d.folate_total_mcg) as folate_std,
    avg(d.magnesium_mg) as mag_mean, stddev_pop(d.magnesium_mg) as mag_std,
    avg(d.alcohol_g) as alcohol_mean, stddev_pop(d.alcohol_g) as alcohol_std
from diet_j d
join healthy h on d.seqn = h.seqn;

drop table if exists depressed_cohort;
create temporary table depressed_cohort as
select seqn
from dpq_j
where feeling_depressed >= 2;

drop table if exists depressed_diet_means;
create temporary table depressed_diet_means as
select
    avg(d.sugars_g) as sugars_mean,
    avg(d.fiber_g) as fiber_mean,
    avg(d.saturated_fat_g) as sat_fat_mean,
    avg(d.folate_total_mcg) as folate_mean,
    avg(d.magnesium_mg) as mag_mean,
    avg(d.alcohol_g) as alcohol_mean
from diet_j d
join depressed_cohort c on d.seqn = c.seqn;

select
    (c.sugars_mean - b.sugars_mean) / b.sugars_std as sugars_z,
    (c.fiber_mean - b.fiber_mean) / b.fiber_std as fiber_z,
    (c.sat_fat_mean - b.sat_fat_mean) / b.sat_fat_std as sat_fat_z,
    (c.folate_mean - b.folate_mean) / b.folate_std as folate_z,
    (c.mag_mean - b.mag_mean) / b.mag_std as magnesium_z,
    (c.alcohol_mean - b.alcohol_mean) / b.alcohol_std as alcohol_z
from depressed_diet_means c
cross join diet_baseline b;

/*
Examine how low vitamin d and poor sleep
increases your risk of chd, fatty liver,
and depression. 2 means more than half days
*/

drop table if exists expanded_disease_baseline;
create temporary table expanded_disease_baseline as
select
    avg(m.coronary_heart_disease = 1) as chd_prev,
    avg(m.fatty_liver = 1) as fatty_liver_prev,
    avg(dpq.feeling_depressed >= 2) as severe_depression_prev
from mcq_j m
join dpq_j dpq on m.seqn = dpq.seqn;

drop table if exists poor_sleep_low_vitd_cohort;
create temporary table poor_sleep_low_vitd_cohort as
select v.seqn
from vid_j v
join slq_j s on v.seqn = s.seqn
where v.vitamin_d_level_nmol_L < 30
  and s.told_doctor_trouble_sleeping = 1;

drop table if exists poor_sleep_low_vitd_prev;
create temporary table poor_sleep_low_vitd_prev as
select
    avg(m.coronary_heart_disease = 1) as chd_prev,
    avg(m.fatty_liver = 1) as fatty_liver_prev,
    avg(dpq.feeling_depressed >= 2) as severe_depression_prev
from poor_sleep_low_vitd_cohort c
join mcq_j m on c.seqn = m.seqn
join dpq_j dpq on c.seqn = dpq.seqn;

select
    c.chd_prev / nullif(b.chd_prev, 0) as chd_relative_risk,
    c.fatty_liver_prev / nullif(b.fatty_liver_prev, 0) as fatty_liver_relative_risk,
    c.severe_depression_prev / nullif(b.severe_depression_prev, 0) as depression_relative_risk
from poor_sleep_low_vitd_prev c
cross join expanded_disease_baseline b;

/*
Examine how really poor diets impact biomarkers
by comparing z scores of the cohorts
*/

drop table if exists toxic_diet_cohort;
create temporary table toxic_diet_cohort as
select seqn
from diet_j
where sugars_g > 100
  and saturated_fat_g > 35
  and fiber_g < 10;

drop table if exists toxic_diet_means;
create temporary table toxic_diet_means as
select
    avg(bio.glucose_mg_dl) as glucose_mean,
    avg(bio.triglycerides_mg_dl) as triglycerides_mean,
    avg(bio.cholesterol_mg_dl) as cholesterol_mean,
    avg(bio.alt_u_l) as alt_mean,
    avg(bio.uric_acid_mg_dl) as uric_acid_mean,
    avg(bio.globulin_g_dL) as globulin_mean
from biopro_j bio
join toxic_diet_cohort c on bio.seqn = c.seqn;
select
    (c.glucose_mean - b.glucose_mean) / b.glucose_std as glucose_z,
    (c.triglycerides_mean - b.triglycerides_mean) / b.triglycerides_std as triglycerides_z,
    (c.cholesterol_mean - b.cholesterol_mean) / b.cholesterol_std as cholesterol_z,
    (c.alt_mean - b.alt_mean) / b.alt_std as alt_liver_z,
    (c.uric_acid_mean - b.uric_acid_mean) / b.uric_acid_std as uric_acid_z,
    (c.globulin_mean - b.globulin_mean) / b.globulin_std as inflammation_globulin_z
from toxic_diet_means c
cross join biomarker_baseline b;