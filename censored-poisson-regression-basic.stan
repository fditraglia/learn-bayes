data {
  int<lower=0> ell;
  int<lower=0> N_obs;
  int<lower=0> N_cens; 
  vector[N_obs] x_obs; 
  vector[N_cens] x_cens;
  array[N_obs] int<lower=0> y_obs; 
}

transformed data {
  int<lower=0> N = N_obs + N_cens;
  vector[N] x = append_row(x_obs, x_cens);
  real x_bar = mean(x); 
  real s_x = sd(x);
  vector[N_obs] z_obs = (x_obs - x_bar) / s_x;
  vector[N_cens] z_cens = (x_cens - x_bar) / s_x; 
}

parameters {
  real alpha;
  real beta;
}

model {
  y_obs ~ poisson_log(alpha + beta * z_obs); 
  target += log_diff_exp(poisson_lcdf(ell | exp(alpha + beta * z_cens)),  
                         poisson_log_lpmf(0 | alpha + beta * z_cens));
    
  // See if we can get away with flat priors here. 
  //alpha ~ normal(3, 0.5);  // mean and sd
  //beta ~ normal(0, 0.2); // mean and sd
}

