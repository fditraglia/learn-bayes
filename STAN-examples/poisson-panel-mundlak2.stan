data {
  int<lower=0> N;
  int<lower=0> Ni;
  array[N] int<lower=0> Y; 
  vector[Ni] Z; 
  vector[N] X; 
  array[N] int<lower=1> id;
}

parameters {
     vector[Ni] U; 
     real abar;
     real<lower=0> tau;
     real beta; 
     real gamma;
     real lambda;
     real<lower=0> kappa;
     real<lower=0> nu;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * U;
}

model {
    vector[N] log_mu;
    vector[N] eta;
    
    // X model
    U ~ normal(0, 1);
    lambda ~ normal(0, 1);
    kappa ~ exponential(1);
    nu ~ exponential(1);
    for(j in 1:N) {
      eta[j] = lambda + kappa * U[id[j]];
    }
    X ~ normal(eta, nu);
    
    // Y model
    abar ~ normal(0, 1);
    tau ~ exponential(1);
    beta ~ normal(0, 1);
    gamma ~ normal(0, 1);
    for(j in 1:N) {
        log_mu[j] = alpha[id[j]] + beta * X[j] + gamma * Z[id[j]];
    }
    Y ~ poisson_log(log_mu);
}
