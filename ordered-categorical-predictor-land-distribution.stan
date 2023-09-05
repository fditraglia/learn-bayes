data {
  int<lower=0> J;
  int<lower=0> N;
  matrix[N, J] S;
  vector[N] X;
  vector[N] Y;
}

transformed data {
  vector[J] ones_J;
  for(j in 1:J) {
    ones_J[j] = 1.0;
  }
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
  simplex[J] delta;
}

model {
  vector[N] mu;
  vector[N] beta_heterog;
  
  vector[J + 1] delta_j;
  delta_j = append_row(0.0, delta); // simplifies book-keeping below
 
  // Construct vector of parameters for Dirichlet prior
  real a = 2.0; // change as desired: exchangeable Dirichlet distribution
  delta ~ dirichlet(a * ones_J);
  
  sigma ~ exponential(1);
  beta ~ normal(0, 2);
  alpha ~ normal(0, 2);
  
  beta_heterog = beta * (1 - (S * delta_j[1:J]));
  mu = alpha + beta_heterog .* X;
  Y ~ normal(mu, sigma);
}
