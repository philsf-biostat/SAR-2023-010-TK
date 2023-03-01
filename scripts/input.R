# setup -------------------------------------------------------------------
library(philsfmisc)
# library(data.table)
library(tidyverse)
library(readxl)
# library(haven)
# library(foreign)
# library(lubridate)
# library(naniar)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), exposure = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/NIPSA_EEP_data_TK.xlsx") %>%
  janitor::clean_names()

Nvar_orig <- data.raw %>% ncol
Nobs_orig <- data.raw %>% nrow

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  rename(
    id = patient,
    outcome = cag2,
    exposure = biomaterial_0_gel_40_1_gen_os,
    gender = gender_0_f_1_m,
    # cal = cal2,
    # tp = tp2,
    # rec = rec2,
    # pd = pd2,
  ) %>%
  select(
    everything(),
  ) %>%
  mutate(
  ) %>%
  filter(
  )

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    id = as.character(id), # or as.factor
    gender = factor(gender, labels = c("Female", "Male")),
    exposure = factor(exposure, labels = c("Gel 40", "Gen-Os")),
    # set gold standard as the reference level
    exposure = relevel(exposure, "Gen-Os"),
  )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    exposure = "Biomaterial",
    outcome = "CAL change",
    cal0 = "CAL (baseline)",
    cal2 = "CAL (end-of-study)",
    rec0 = "REC (baseline)",
    rec2 = "REC (end-of-study)",
    pd0 = "PD (baseline)",
    pd2 = "PD (end-of-study)",
    tp0 = "TP (baseline)",
    tp2 = "TP (end-of-study)",
    age = "Age (years)",
    gender = "Gender",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  select(
    id,
    exposure,
    outcome,
    # everything(),
    gender,
    age,
    pd0,
    pd2,
    tp0,
    tp2,
    rec0,
    rec2,
    cal0,
    cal2,
  )

Nvar_final <- analytical %>% ncol
Nobs_final <- analytical %>% nrow

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", "N") ) %>%
# analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(Nobs_final) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
