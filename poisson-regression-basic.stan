data {
  int<lower=0> N; 
  vector[N] x; 
  array[N] int<lower=0> y; 
}

transformed data {
  real x_bar = mean(x); 
  real s_x = sd(x);
  vector[N] z = (x - x_bar) / s_x; 
}

parameters {
  real alpha;
  real beta;
}

model {
  y ~ poisson_log(alpha + beta * z); 
  // See if we can get away with flat priors
  //alpha ~ normal(3, 0.5);  // mean and sd
  //beta ~ normal(0, 0.2); // mean and sd
}

