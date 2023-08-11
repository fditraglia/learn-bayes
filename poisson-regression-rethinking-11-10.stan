data {
  int<lower=0> N_obs; 
  int<lower=0> N_groups; 
  array[N_obs] int<lower=0> total_tools; 
  vector[N_obs] pop; 
  array[N_obs] int<lower=1,upper=N_groups> group; 
}

transformed data {
  vector[N_obs] lpopz = (log(pop) - mean(log(pop))) / sd(log(pop));
}

parameters {
  vector[N_groups] alpha;
  vector[N_groups] beta;
}

model{
 vector[N_obs] lambda; 
 
 alpha ~ normal(3, 0.5);
 beta ~ normal(0, 0.2);
 
 for (i in 1:N_obs) {
   lambda[i] = alpha[group[i]] + beta[group[i]] * lpopz[i];
 }
 
 total_tools ~ poisson_log(lambda);
}


