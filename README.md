# Stroke care network in Cali: Stata analysis

This repository contains the Stata code used for the statistical analysis and figures in the study **“Performance of a regional stroke care network in Cali, Colombia: an observational cohort study of acute ischemic stroke (2019–2024).”**

## Repository contents

- `main_analysis.do`: descriptive analyses, ordinal logistic regression, generalized ordered logistic regression, mortality models, and hospital-effect sensitivity analyses.
- `figure2.do`: stacked distribution of modified Rankin Scale scores at discharge by reperfusion-therapy status.
- `figure3.do`: distribution of onset-to-arrival categories by NIHSS severity group.

## Data availability

The study dataset contains confidential patient-level health information and is not included in this public repository. Access is subject to the study protocol, ethics approval, applicable data-protection requirements, and authorization from the data custodians.

Authorized users should place the analysis dataset in the repository root using the file name:

```text
stroke_analysis_data.csv
```

The `.gitignore` file excludes this dataset and other common patient-data formats from version control.

## Software requirements

- Stata
- Community-contributed Stata commands `gologit2`, `oparallel`, and `brant`

The main script checks whether these commands are installed and installs any missing commands from SSC.

## Running the analysis

1. Obtain authorized access to the confidential analysis dataset.
2. Save it as `stroke_analysis_data.csv` in the repository root.
3. Set Stata's working directory to the repository root.
4. Run `main_analysis.do`.
5. Run `figure2.do` and `figure3.do` to generate the figures.

All scripts use relative paths and can therefore be run from any location after setting the working directory.

## Reproducibility and privacy

The code is publicly available to document the analytical methods. The absence of patient-level data is intentional and does not affect the availability of the analysis code. Users must not commit confidential or potentially identifiable data to this repository.
