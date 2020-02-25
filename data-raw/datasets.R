library(dplyr)
library(tibble)
library(readr)


# Create agglomeration parameters table -----------------------------------

parameters <- tibble(sector = c("Manufacturing",
                                "Construction",
                                "Wholesale_Retail",
                                "Transport",
                                "Inf_Comm_Tech",
                                "Fin_Bus_Services"),
                     gva_person = c(79000, 52342.01, 0, 27617.96, 0, 56985.39),
                     decay_parameter = c(1.25, 1, 1, 1.25, 1.5, 1.5),
                     elasticity = c(0.015, 0.065, 0, 0.092, 0, 0.058))


# Create GVA factors table ------------------------------------------------

discount_rate <- c(0.04, 0.035, 0.03, 0.025, 0.02, 0.015)

gva_factors <- tibble(year = format(Sys.Date(), "%Y"):2200) %>%
    mutate(appraisal_year = row_number()) %>%
    mutate(discount = case_when(
        appraisal_year %in% 1:30 ~ 1/((1 + discount_rate[1]) ^ (year - 2011)),
        appraisal_year %in% 31:60 ~ 1/((1 + discount_rate[2]) ^ (year - 2011)),
        appraisal_year %in% 61:100 ~ 1/((1 + discount_rate[3]) ^ (year - 2011)),
        appraisal_year %in% 31:60 ~ 1/((1 + discount_rate[4]) ^ (year - 2011)),
        appraisal_year %in% 31:60 ~ 1/((1 + discount_rate[5]) ^ (year - 2011)),
        appraisal_year %in% 31:60 ~ 1/((1 + discount_rate[6]) ^ (year - 2011)),
    ),
    gva_growth = case_when(
        #year %in% c(2010:2014) ~ 1.014,
        year == 2016 ~ 1,
        year %in% c(2017:2019) ~ 1.036,
        year %in% c(2020:2024) ~ 1.022,
        TRUE ~ 1.023),
    gva_compound = cumprod(gva_growth))


# Load internal data for testing -----------------------------------------------

path_gc_dm_2024 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2024Impedance_DM.txt"
path_gc_ds_2024 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2024Impedance_DS.txt"
path_gc_dm_2039 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2039Impedance_DM.txt"
path_gc_ds_2039 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2039Impedance_DS.txt"
path_gc_dm_2054 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2054Impedance_DM.txt"
path_gc_ds_2054 <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/2054Impedance_DS.txt"

path_jobs <- "/home/dan/R/projects/agglomeration/aecom-python/foynes-limerick/Jobs.txt"

read_gc <- function(path) {
    read_table2(path,
                col_names = c("o_zone",
                              "d_zone",
                              "uc",
                              "tp1",
                              "tp2",
                              "tp3")) %>%
        select(o_zone, d_zone, tp1) %>%
        rename(gen_cost = tp1)
}

dm_2024 <- read_gc(path_gc_dm_2024)
ds_2024 <- read_gc(path_gc_ds_2024)
dm_2039 <- read_gc(path_gc_dm_2039)
ds_2039 <- read_gc(path_gc_ds_2039)
dm_2054 <- read_gc(path_gc_dm_2054)
ds_2054 <- read_gc(path_gc_ds_2054)

jobs <- read_jobs(path_jobs)

# Add tests to data/ folder -----------------------------------------------

usethis::use_data(parameters, overwrite = TRUE)
usethis::use_data(gva_factors, overwrite = TRUE)

usethis::use_data(dm_2024,
                  ds_2024,
                  dm_2039,
                  ds_2039,
                  dm_2054,
                  ds_2054,
                  jobs,
                  internal = FALSE,
                  overwrite = TRUE)
