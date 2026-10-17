* Script to reproduce analyses in "Performance of a regional stroke care network in Cali, Colombia: an observational cohort study of acute ischemic stroke (2019-2024)."

* Install community-contributed commands only when they are unavailable.
capture which gologit2
if _rc ssc install gologit2
capture which oparallel
if _rc ssc install oparallel
capture which brant
if _rc ssc install brant

* Dataset
* Run this script from the repository root.
import delimited "stroke_analysis_data.csv", clear

* Define obesity as BMI >=30 kg/m^2; non-positive BMI values are invalid.
gen obesity = .
replace obesity = 1 if bmi >= 30 & bmi < .
replace obesity = 0 if bmi > 0 & bmi < 30
egen comorbidities = rowtotal(heart_failure coronary_disease covid19 diabetes hiv dyslipidaemia hypertension other_risk venous_thromboembolism atrial_fibrillation obesity chronic_kidney_disease)
egen total_comorb = cut(comorbidities), at(0 1 4 9)
gen risk_other_total = 0
replace risk_other_total = 1 if hiv == 1 | venous_thromboembolism == 1 | other_risk == 1
replace risk_other_total = . if hiv == . & venous_thromboembolism == . & other_risk == .
*egen nihss_group = cut(nihss), at(0 5 16 21 43)

***********
* Table 1 *
***********
tab intervention

tabstat age, by(intervention) stats(n p50 p25 p75)
kwallis age, by(intervention)

tab male intervention, col exact

tab insurance intervention, col exact
tab insurance intervention, col missing

tab residence_cali intervention, col exact
tab residence_cali intervention, col missing

tab department intervention, col exact
tab department intervention, col missing exact
***********
* Table 2 *
***********
tab atrial_fibrillation intervention, col exact
tab hypertension intervention, col exact
tab diabetes intervention, col exact
tab coronary_disease intervention, col exact
tab heart_failure intervention, col exact
tab recent_smoking intervention, col exact
tab dyslipidaemia intervention, col exact
tab chronic_kidney_disease intervention, col exact
tab covid19 intervention, col exact
tab risk_other_total intervention, col exact
tab overweight_obesity intervention, col exact
tab total_comorb intervention, col exact
tab antihypertensives intervention, col exact
tab statins intervention, col exact
tab antidiabetics intervention, col exact
tab antiplatelet intervention, col exact
tab anticoagulant intervention, col exact
tab other_medication intervention, col exact

***********
* Table 3 *
***********
tabstat onset_to_door, by(intervention) stats(n p50 p25 p75)
kwallis onset_to_door, by(intervention)

tabstat nihss, by(intervention) stats(n p50 p25 p75)
kwallis nihss, by(intervention)
tab nihss_group intervention, col exact

tab ems_prenotification intervention, col exact

tab first_hospital intervention, col exact

tab arrival_ems intervention, col exact

tab imaging_within_hour intervention, col exact

tab death_in_hospital intervention, col exact
tab death_30d intervention, col exact
tab death_90d intervention, col exact

***********
* Table 4 *
***********
/*---------------------------------------------------*/
/* Adjusted analysis with small sample size exluding the people with missing data in arrival_ems */
* Unadjusted models
ologit discharge_mrs age if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel

ologit discharge_mrs i.male if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel

ologit discharge_mrs i.onset_within_5h if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel

ologit discharge_mrs i.regimen if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel

ologit discharge_mrs nihss_per_4 if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel
gologit2 discharge_mrs nihss_per_4 if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or autofit

ologit discharge_mrs i.intervention if age != . & male != . & onset_within_5h != . & regimen != . & nihss_per_4 != . & intervention != . & arrival_ems != ., or
oparallel

* Full-adjusted model
ologit discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention if arrival_ems != ., or
oparallel


* Assess hospital random effect in full model *
meologit discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention || hospital:, or
gologit2 discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention i.hospital, or autofit /* Hospital is having a significant effect */
/*----------------------------------------------------*/
/*----------------------------------------------------*/
/* Adjusted analysis with complete cases in each variable */
* Unadjusted models
ologit discharge_mrs age, or
oparallel

ologit discharge_mrs i.male, or
oparallel

ologit discharge_mrs i.onset_within_5h, or
oparallel

ologit discharge_mrs i.regimen, or
oparallel
gologit2 discharge_mrs i.regimen, or autofit

ologit discharge_mrs nihss_per_4, or
oparallel
gologit2 discharge_mrs nihss_per_4, or autofit

ologit discharge_mrs i.intervention, or
oparallel

* Full-adjusted model
ologit discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention i.imaging_within_hour i.arrival_ems, or /*model with problems: imaging and arrival are removed*/
oparallel
brant
ologit discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention, or /*Model with problems in nihss*/
oparallel
brant
gologit2 discharge_mrs  age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention, or autofit /*This model relax the assumption for nihss. It is a more flexible model.*/

* Assess hospital random effect in full model *
meologit discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention || hospital:, or
gologit2 discharge_mrs age i.male i.onset_within_5h i.regimen nihss_per_4 i.intervention i.hospital, or autofit



***********
* Table 5 *
***********
* Primary adjusted model and analytical-sample definition
logistic death_30d i.ems_prenotification i.arrival_ems i.regimen i.onset_within_5h age i.male nihss_per_4 i.first_hospital i.imaging_within_hour i.intervention, or

capture drop sample_table5
gen sample_table5 = e(sample)

* Unadjusted models using the same sample as the adjusted model
logistic death_30d i.ems_prenotification if sample_table5==1, or
logistic death_30d i.arrival_ems if sample_table5==1, or
logistic death_30d i.regimen if sample_table5==1, or
logistic death_30d i.onset_within_5h if sample_table5==1, or
logistic death_30d age if sample_table5==1, or
logistic death_30d i.male if sample_table5==1, or
logistic death_30d nihss_per_4 if sample_table5==1, or
logistic death_30d i.first_hospital if sample_table5==1, or
logistic death_30d i.imaging_within_hour if sample_table5==1, or
logistic death_30d i.intervention if sample_table5==1, or

* Primary adjusted model reported in the table
logistic death_30d i.ems_prenotification i.arrival_ems i.regimen i.onset_within_5h age i.male nihss_per_4 i.first_hospital i.imaging_within_hour i.intervention, or

* Hospital random-effect assessment
melogit death_30d i.ems_prenotification i.arrival_ems i.regimen i.onset_within_5h age i.male nihss_per_4 i.first_hospital i.imaging_within_hour i.intervention || hospital:, or

* Sensitivity analysis including hospital as a fixed effect
logistic death_30d i.ems_prenotification i.arrival_ems i.regimen i.onset_within_5h age i.male nihss_per_4 i.first_hospital i.imaging_within_hour i.intervention i.hospital, or

* Sensitivity analysis excluding arrival_ems because of missing values
logistic death_30d age i.male nihss_per_4 i.onset_within_5h i.ems_prenotification i.first_hospital i.imaging_within_hour i.intervention i.regimen, or
capture drop sample_table5_1
gen sample_table5_1 = e(sample)
logistic death_30d age if sample_table5_1==1, or
logistic death_30d i.male if sample_table5_1==1, or
logistic death_30d nihss_per_4 if sample_table5_1==1, or
logistic death_30d i.onset_within_5h if sample_table5_1==1, or
logistic death_30d i.ems_prenotification if sample_table5_1==1, or
logistic death_30d i.first_hospital if sample_table5_1==1, or
logistic death_30d i.imaging_within_hour if sample_table5_1==1, or
logistic death_30d i.intervention if sample_table5_1==1, or
logistic death_30d i.regimen if sample_table5_1==1, or

