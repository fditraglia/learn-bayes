data {
  int<lower=0> Ni;
  int<lower=Ni> N;
  array[N] int<lower=1> id;
  array[N] int<lower=0> X;
  vector[N] logXplus1;
  vector[Ni] Xtilde;
  array[N] int<lower=0> Y;
  vector[N] Z;
}

parameters {
  // X model
  real theta_bar;
  real<lower=0> sigma_theta;
  vector[Ni] v;
  real pi;
  real kappa;
  vector[N] epsilon;
  
  // Y model
  real abar;
  real xi;
  real<lower=0> tau;
  real beta;
  real<lower=0> phi;
  vector[Ni] eta;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * eta; 
  vector[Ni] theta = theta_bar + sigma_theta * v;
}

model {
  
  //X priors
  theta_bar ~ normal(0, 1);
  sigma_theta ~ exponential(1);
  v ~ normal(0, 1);
  pi ~ normal(0, 1);
  kappa ~ normal(0, 1);
  epsilon ~ normal(0, 1);
  
  //X Model
  vector[N] log_mu;
  for(j in 1:N) {
   log_mu[j] = theta[id[j]] + pi * Z[j] + kappa * epsilon[j]; 
  }
  X ~ poisson_log(log_mu);
  
  //Y priors
  abar ~ normal(0, 1);
  xi ~ normal(0, 1);
  tau ~ exponential(1);
  beta ~ normal(0, 1);
  phi ~ exponential(1);
  eta ~ normal(0, 1);
  
  //Y Model
  vector[N] log_lambda;
  for(j in 1:N) {
    // Mundlak term included! 
    log_lambda[j] = alpha[id[j]] + beta * logXplus1[j] + xi * Xtilde[id[j]] + 
      phi * epsilon[j];  
  }
  Y ~ poisson_log(log_lambda);
  
}
