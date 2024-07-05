data {
  int<lower=0> Ni;
  int<lower=0> N;
  array[N] int<lower=0> Y;
  vector[N] logXplus1;
  array[N] int<lower=1> id;
  vector[Ni] Xtilde;
}

parameters {
  vector[Ni] eta;
  real abar;
  real<lower=0> tau;
  real beta;
  real gamma;
}

model {
  vector[N] log_lambda;
  
  eta ~ normal(0, 1);
  abar ~ normal(0, 1);
  tau ~ exponential(1);
  beta ~ normal(0, 1);
  gamma ~ normal(0, 1);
  
  vector[Ni] alpha = abar + tau * eta;
  
  for(j in 1:N) {
    log_lambda[j] = alpha[id[j]] + beta * logXplus1[j] + gamma * Xtilde[id[j]];
  }
  
  Y ~ poisson_log(log_lambda);
}
