// Example 11-12 from Statistical Rethinking
data {
  int<lower=0> N_obs;
  vector[N_obs] days; // store as real for taking logs below
  array[N_obs] int<lower=1,upper=2> monastery;
  array[N_obs] int<lower=0> manuscripts;
}

transformed data {
  vector[N_obs] log_days = log(days);
}

parameters {
  vector[2] alpha;
}

transformed parameters {
  vector[2] lambda = exp(alpha);
  real d = lambda[2] - lambda[1];
}

model {
  vector[N_obs] log_lambda;
  alpha ~ normal(1, 1);
  
  for(i in 1:N_obs) {
    log_lambda[i] = log_days[i] + alpha[monastery[i]];
  }
  manuscripts ~ poisson_log(log_lambda);
}
