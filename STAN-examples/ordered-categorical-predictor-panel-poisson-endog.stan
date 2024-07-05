data {
  int<lower=0> J;
  int<lower=0> Ni;
  int<lower=Ni> N;
  matrix[Ni, J] S;
  array[N] int<lower=0> X;
  vector[N] logXplus1;
  vector[Ni] Xtilde;
  array[N] int<lower=0> Y;
  array[N] int<lower=1> id;
  vector[N] Z;
}

transformed data {
  vector[J] ones_J;
  for(j in 1:J) {
    ones_J[j] = 1.0;
  }
}

parameters {
  // X model
  real theta_bar;
  real<lower=0> sigma_theta;
  vector[Ni] v;
  real pie;
  real kappa;
  vector[N] epsilon;
  
  // Y model
  real abar;
  real<lower=0> tau;
  vector[Ni] eta;
  simplex[J] delta;
  real beta;
  real gamma;
  real<lower=0> phi;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * eta;
  vector[Ni] theta = theta_bar + sigma_theta * v;
}

model {
  vector[N] log_lambda;
  vector[N] log_mu;
  vector[Ni] beta_heterog;
  vector[J + 1] delta_j;
  delta_j = append_row(0.0, delta); // simplifies book-keeping below
  
  // X model
  theta_bar ~ normal(0, 1);
  sigma_theta ~ exponential(1);
  v ~ normal(0, 1);
  pie ~ normal(0, 1);
  kappa ~ normal(0, 1); 
  epsilon ~ normal(0, 1);
  
  for(j in 1:N) {
    log_mu[j] = theta[id[j]] + pie * Z[j] + kappa * epsilon[j];
  }
  X ~ poisson_log(log_mu);
  
  // Y model
  abar ~ normal(0, 1);
  tau ~ exponential(1);
  eta ~ normal(0, 1);
  real a = 2.0; 
  delta ~ dirichlet(a * ones_J);
  beta ~ normal(0, 1);
  beta_heterog = beta * (1 - (S * delta_j[1:J]));
  gamma ~ normal(0, 1);
  phi ~ exponential(1); 
  
  for(j in 1:N) {
    log_lambda[j] = alpha[id[j]] + beta_heterog[id[j]] * logXplus1[j] + 
    gamma * Xtilde[id[j]] + phi * epsilon[j];
  }
  Y ~ poisson_log(log_lambda);
}
