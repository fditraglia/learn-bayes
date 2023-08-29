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
  real<lower = 0> sigma_y; // fixes the sign of u
  real sigma_x;
  real alpha; 
  real beta;
  real gamma; 
  real delta;
  vector[N] u;  
}

model {
  sigma_y ~ exponential(1);
  sigma_x ~ normal(0, 1);
  alpha ~ normal(0, 2);
  beta ~ normal(0, 1);
  gamma ~ normal(0, 1);
  delta ~ normal(0, 1);
  u ~ normal(0, 1);
  x ~ poisson_log(gamma + delta * znorm + sigma_x * u);
  y ~ poisson_log(alpha + beta * log_xp1 + sigma_y * u);
}

