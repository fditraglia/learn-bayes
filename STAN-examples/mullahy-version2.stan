data {
  int<lower=0> N;
  vector[N] z;
  array[N] int<lower = 0> x;
  array[N] int<lower = 0> y;
}

transformed data {
  vector[N] log_xp1;
  for(i in 1:N) {
    log_xp1[i] = log(1 + x[i]);
  }
  vector[N] znorm = (z - mean(z)) / sd(z);
}

parameters {
  real<lower = 0> sigma_u; // fixes the sign of u
  real eta;
  real alpha; 
  real beta;
  real rho; 
  real delta;
  vector[N] u;  
}

model {
  sigma_u ~ exponential(1);
  eta ~ normal(0, 1);
  alpha ~ normal(0, 2);
  beta ~ normal(0, 1);
  rho ~ normal(0, 1);
  delta ~ normal(0, 1);
  u ~ normal(alpha, sigma_u);
  x ~ poisson_log(rho + delta * znorm + eta * u);
  y ~ poisson_log(beta * log_xp1 + u);
}

