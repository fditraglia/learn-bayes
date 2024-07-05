data {
  int<lower=0> N_obs;
  int<lower=0> N_cens;
  int<lower=0> ell;
  array[N_obs] int<lower=0> y_obs; 
  vector[N_obs] x_obs; 
  vector[N_cens] x_cens;
}

parameters {
  real alpha;
  real beta;
}

model {
  y_obs ~ poisson_log(alpha + beta * x_obs); 
  real mu_j;
  for(j in 1:N_cens) {
    mu_j = exp(alpha + beta * x_cens[j]);
    target += log_diff_exp(poisson_lcdf(ell | mu_j), poisson_lpmf(0 | mu_j));
  }
}

