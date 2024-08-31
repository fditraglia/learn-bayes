data {
  int<lower=0> N; 
  vector[N] popn; // real for taking logs below to avoid truncation!
  vector[N] x; 
  array[N] int<lower=0> y; 
}

transformed data {
  real x_bar = mean(x); 
  real s_x = sd(x);
  vector[N] z = (x - x_bar) / s_x; 
  vector[N] log_popn = log(popn / 1000); // log in thousands
}

parameters {
  real alpha;
  real beta;
  real<lower=0> phi;
}

model {
  y ~ neg_binomial_2_log(log_popn + alpha + beta * z, phi); 
  // See if we can get away with flat priors
  //alpha ~ normal(3, 0.5);  // mean and sd
  //beta ~ normal(0, 0.2); // mean and sd
  //phi ~ ???
}

