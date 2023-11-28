data {
  int<lower=0> N_obs;
  int<lower=0> N_cens;
  int<lower=0> ell;
  array[N_obs] int<lower=0> y_obs; 
  vector[N_obs] x_obs; 
  vector[N_cens] x_cens;
  vector[N_obs] z_obs;
  vector[N_cens] z_cens;
}

parameters {
  real alpha;
  real beta;
  real gamma;
  real delta;
}

model {
  // For the moment, see if we can get away with flat priors. My guess is that
  // we'll do a very poor job with the intercepts: an informative prior will be
  // needed on at least one of them.
  vector[N_obs] mu_obs = exp(alpha + beta * x_obs);
  vector[N_obs] pi_obs = inv_logit(gamma + delta * z_obs);
  vector[N_obs] lambda_obs = mu_obs .* pi_obs; // elementwise product
  y_obs ~ poisson(lambda_obs); 
  for (j in 1:N_cens) {
    real mu_cens = exp(alpha + beta * x_cens[j]);
    real pi_cens = inv_logit(gamma + delta * z_cens[j]);
    real lambda_cens = mu_cens * pi_cens;
    target += log_diff_exp(poisson_lccdf(ell | lambda_cens), poisson_lpmf(0 | lambda_cens));
  }
}

