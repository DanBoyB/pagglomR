# Run process on case study -----------------------------------------------

eff_dens_dm_2024 <- calc_eff_dens(dm_2024, jobs, 2024)
eff_dens_ds_2024 <- calc_eff_dens(ds_2024, jobs, 2024)
eff_dens_dm_2039 <- calc_eff_dens(dm_2039, jobs, 2039)
eff_dens_ds_2039 <- calc_eff_dens(ds_2039, jobs, 2039)
eff_dens_dm_2054 <- calc_eff_dens(dm_2054, jobs, 2054)
eff_dens_ds_2054 <- calc_eff_dens(ds_2054, jobs, 2054)

prod_2024 <- calc_prod_impacts(eff_dens_dm_2024, eff_dens_ds_2024, jobs)
prod_2039 <- calc_prod_impacts(eff_dens_dm_2039, eff_dens_ds_2039, jobs)
prod_2054 <- calc_prod_impacts(eff_dens_dm_2054, eff_dens_ds_2054, jobs)

discounted_benefits <- discounted_prod(appraisal_year = 2020,
                                       prod_2024,
                                       prod_2039,
                                       prod_2054)

# Undertake tests ---------------------------------------------------------

context("Case Study Tests")

test_that("Productivity projections are correct", {

    # check sizes of effective density matrices
    expect_equal(dim(eff_dens_dm_2024$eff_dens), c(110, 6))
    expect_equal(dim(eff_dens_ds_2024$eff_dens), c(110, 6))
    expect_equal(dim(eff_dens_dm_2039$eff_dens), c(110, 6))
    expect_equal(dim(eff_dens_ds_2039$eff_dens), c(110, 6))
    expect_equal(dim(eff_dens_dm_2054$eff_dens), c(110, 6))
    expect_equal(dim(eff_dens_ds_2054$eff_dens), c(110, 6))

    # # check productivity calculations
    expect_equal(prod_2024$prod_total, 2707225.43041139)
    expect_equal(prod_2039$prod_total, 2921467.68728561)
    expect_equal(prod_2054$prod_total, 2906733.56789363)
    #
    # # check size of discounted benefits dataframe
    expect_equal(dim(discounted_benefits), c(64, 5))
    #
    # # check nominal benefits
    expect_equal(sum(discounted_benefits$nominal), 470993862)
    #
    # # check discounted benefits
    expect_equal(sum(discounted_benefits$discounted), 97757122)
    #
    # # Check 30 year benefits from summary table
    expect_equal(prod_summary(discounted_benefits)[[1, 2]], 53425447)
    #
    # # Check residual value benefits from summary table
    expect_equal(prod_summary(discounted_benefits)[[2, 2]], 44331675)

})


