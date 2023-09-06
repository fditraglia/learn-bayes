data {
  int<lower=0> J;
  int<lower=0> Ni;
  int<lower=Ni> N;
  matrix[Ni, J] S;
  vector[N] logXplus1;
  vector[Ni] Xtilde;
  array[N] int<lower=0> Y;
  array[N] int<lower=1> id;
  
}

transformed data {
  vector[J] ones_J;
  for(j in 1:J) {
    ones_J[j] = 1.0;
  }
}

parameters {
  simplex[J] delta;
  real beta;
  real gamma;
  real abar;
  real<lower=0> tau;
  vector[Ni] eta;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * eta;
}

model {
  vector[N] log_lambda;
  vector[Ni] beta_heterog;
  
  vector[J + 1] delta_j;
  delta_j = append_row(0.0, delta); // simplifies book-keeping below
 
  // Construct vector of parameters for Dirichlet prior
  real a = 2.0; // change as desired: exchangeable Dirichlet distribution
  delta ~ dirichlet(a * ones_J);
  
  beta ~ normal(0, 2);
  gamma ~ normal(0, 2);
  abar ~ normal(0, 2);
  eta ~ normal(0, 1);
  tau ~ exponential(1);
  
  beta_heterog = beta * (1 - (S * delta_j[1:J]));
  
  for(j in 1:N) {
    log_lambda[j] = alpha[id[j]] + beta_heterog[id[j]] * logXplus1[j] + 
    gamma * Xtilde[id[j]];
  }
  
  Y ~ poisson_log(log_lambda);
}
