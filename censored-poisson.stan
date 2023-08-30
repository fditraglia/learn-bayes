data {
  int<lower=0> N_obs;
  int<lower=0> N_cens;
  int<lower=0> ell;
  array[N_obs] int<lower=0> y_obs;
}
parameters {
  real<lower=0> mu;
}
model {
  y_obs ~ poisson(mu);
  target += N_cens * (log_diff_exp(poisson_lcdf(ell | mu), poisson_lpmf(0 | mu)));
}
