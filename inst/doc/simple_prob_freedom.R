## ---- echo = TRUE, eval = TRUE, message = FALSE, results = 'hide'-------------
library(freedom)

Hse <- rep(0.2, 500)
dp <- rep(0.01, 500)
SysSe <- sysse(dp, Hse)


## ---- echo = TRUE, eval = TRUE, message = FALSE, results = 'hide'-------------
prior_pr <- 0.5
prob_intro <- 0.01

pr_free <- data.frame(year = 2012:2020,
                      prior_fr = NA,
                      post_fr = NA,
                      stringsAsFactors = FALSE)
## At the beginning of the first year the probability of freedom is just
## the prior.

pr_free$prior_fr[1] <- prior_pr
pr_free$post_fr[1] <- post_fr(pr_free$prior_fr[1], SysSe)

## Then we use the temporal discouting proceedure to calculate the subsequent
## years:

for (i in seq(2, nrow(pr_free))) {
    pr_free$prior_fr[i] <- prior_fr(pr_free$post_fr[i - 1], prob_intro)
    pr_free$post_fr[i] <- post_fr(pr_free$prior_fr[i], SysSe)
}


## ---- echo = TRUE, eval = TRUE, message = FALSE-------------------------------
pr_free
plot(x = pr_free$year,
     y = pr_free$post_fr,
     type = "l",
     xlab = "year",
     ylab = "probability of freedom",
     main = "Probability of freedom at the end of each calendar year")

