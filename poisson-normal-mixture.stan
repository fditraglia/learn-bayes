data {
  int<lower=0> N;
  vector[N] x;
  array[N] int<lower = 0> y;
}

parameters {
  real<lower = 0> sigma;
  real alpha; 
  real beta;
  vector[N] errors;  
}

model {
  sigma ~ exponential(1);
  beta ~ normal(0, 0.2);
  alpha ~ normal(0, 1.5);
  errors ~ normal(0, 1);
  y ~ poisson_log(alpha + beta * x + sigma * errors);
}

