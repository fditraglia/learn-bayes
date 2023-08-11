// STAN code to implement Example 11-11 from Statistical Rethinking
data {
  int<lower=0> N_obs;
  int<lower=0> N_groups;
  vector[N_obs] pop; // allows vectorized log() below 
  array[N_obs] int<lower=0> total_tools;
  array[N_obs] int<lower=1,upper=N_groups> group;
}

transformed data {
  vector[N_obs] lpop = log(pop);
}

parameters {
  vector[N_groups] delta;
  array[N_groups] real<lower=0> beta;
}

transformed parameters {
  vector[N_groups] alpha = exp(delta);
}

model {
  vector[N_obs] log_lambda;
  
  delta ~ normal(1, 1);
  beta ~ exponential(1);
  
  for (i in 1:N_obs) {
    log_lambda[i] = delta[group[i]] + beta[group[i]] * lpop[i];
  }
  total_tools ~ poisson_log(log_lambda);
}

// Blank line below prevents the warning "incomplete final line found on..."
// See: https://discourse.mc-stan.org/t/incomplete-final-line-found/6907

