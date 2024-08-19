data { 
  int<lower=1> J; // # of experiments 
  array[J] int<lower=1> N; // # of trials in each experiment
  array[J] int<lower=0> Y; // # of "successes" in each experiment
}

parameters {
  real<lower=0> a; // canonical beta parameter
  real<lower=0> b; // canonical beta parameter
  vector<lower=0, upper=1>[J] Theta; // P(success) in each experiment
}

transformed parameters {
  real<lower=0, upper=1> gamma = a / (a + b);
  real<lower=0> kappa = a + b;
}

model {
  Y ~ binomial(N, Theta); // Likelihood
  Theta ~ beta(a, b); // Prior
  
  // hyperpriors (specified in terms of gamma and kappa)
  kappa ~ pareto(1, 1.5);
  gamma ~ beta(1, 1); // uniform
}
