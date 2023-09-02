data {
  int<lower=0> N;
  int<lower=0> Ni;
  vector[N] Y; 
  vector[Ni] Z; 
  vector[N] X; 
  array[N] int<lower=1> id;
}

parameters {
     vector[Ni] U;
     real beta; 
     real gamma;
     real abar;
     real lambda;
     real<lower=0> kappa;
     real<lower=0> nu;
     real tau;
     real<lower=0> sigma;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * U;
}

model {
    vector[N] mu;
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
    gamma ~ normal(0, 1); 
    beta ~ normal(0, 1);
    abar ~ normal(0, 1);
    tau ~ normal(0, 1);
    sigma ~ exponential(1);
    for (j in 1:N) {
        mu[j] = alpha[id[j]] + beta * X[j] + gamma * Z[id[j]];
    }
    Y ~ normal(mu, sigma);
}
