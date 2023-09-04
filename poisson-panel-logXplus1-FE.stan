data {
  int<lower=0> Ni;
  int<lower=0> N;
  array[N] int<lower=0> Y;
  vector[N] logXplus1;
  array[N] int<lower=1> id;
}

parameters {
  vector[Ni] alpha;
  real beta;
}

model {
  vector[N] log_lambda;
  alpha ~ normal(0, 10);
  beta ~ normal(0, 1);
  for(j in 1:N) {
    log_lambda[j] = alpha[id[j]] + beta * logXplus1[j];
  }
  Y ~ poisson_log(log_lambda);
}
