data { 
  int<lower=1> J; 
  array[J] int<lower=1> N; 
  array[J] int<lower=0> Y; 
}

parameters {
  real<lower=0> a; 
  real<lower=0> b; 
  vector<lower=0, upper=1>[J] Theta; 
}

transformed parameters {
  real<lower=0, upper=1> phi = a / (a + b);
  real<lower=0> kappa = a + b;
}

model {
  Y ~ binomial(N, Theta); 
  Theta ~ beta(a, b); 
  kappa ~ pareto(1, 1.5);
  phi ~ beta(1, 1);  // Uniform(0,1)
}
