library(freedom)
## Tolerance of the agreement between observed and expected
tol <- 1e-7

## 50 herds sample data
df <- sample_data(nherds = 50,
                 mean_herd_size = 500,
                 n_herd_urg = 1,
                 herd_dist = c(1),
                 herd_samp_frac = 0.15,
                 herd_samp_dist = c(1),
                 n_animal_urg = 1,
                 animal_dist = c(1),
                 animal_samp_frac = 0.15,
                 animal_samp_dist = c(1),
                 seed = 1)

## Because there is only 1 unit risk group at the herd and animal
## level the Adjusted risks are 1 and the effective probability of
## infection is the same as the design prevalence. The Design
## prevalence for the calculation below is 2% at the herd level and
## 15% at the animal level. The sensitivity of the test is 70%. We
## will calculate the Sensitivity of the surveillance system.
##
## First the Herd sensitivity
##
hse <- hse_finite(df$ppn,
                  df$n_animal_urg,
                  df$N_animal_urg,
                  0.70,
                  0.15)
df$hse <- hse$HSe[match(df$ppn, hse$id)]

## Then the system sensitivity
system_sens <- sysse(rep(0.02, nrow(df)), df$hse)

## Posterior probability of freedom.
##
## This is calculated based on the prior probability of freedom and
## the sensitivity of the surveillance system.
post_pf <- post_fr(0.5, system_sens)

## Prior probability at next year assuming an annual risk of
## introduction of 0.05%
stopifnot(all(abs(prior_fr(post_pf, 0.05) - 0.696163691219548) < tol))
