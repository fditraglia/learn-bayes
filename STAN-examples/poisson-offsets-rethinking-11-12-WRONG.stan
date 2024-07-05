// THIS FILE HAS AN ERROR! 
// The offset is calculated incorrectly; the error is quite subtle. I'm keeping
// this as an example to avoid making the same mistake again. See the writeup
// in poisson-regression-STAN.qmd for more details.
//
// Example 11-12 from Statistical Rethinking. 
data {
  int<lower=0> N_obs;
  array[N_obs] int<lower=1> days;
  array[N_obs] int<lower=1,upper=2> monastery;
  array[N_obs] int<lower=0> manuscripts;
}

transformed data {
  array[N_obs] real log_days = log(days);
  print("Transformed data log(days): ", log_days);
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
