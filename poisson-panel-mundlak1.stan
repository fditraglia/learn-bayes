data {
  int<lower=0> N;
  int<lower=0> Ni;
  array[N] int<lower=0> Y; 
  vector[Ni] Z; 
  vector[N] X; 
  vector[Ni] Xbar;
  array[N] int<lower=1> id;
}

parameters {
     vector[Ni] U; 
     real abar;
     real beta; 
     real gamma;
     real delta;
     real<lower=0> tau;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * U;
}

model {
    vector[N] log_mu;
    abar ~ normal(0, 1);
    beta ~ normal(0, 1);
    gamma ~ normal(0, 1); 
    delta ~ normal(0, 1);
    U ~ normal(0, 1);
    tau ~ exponential(1);
    
    for (j in 1:N) {
        log_mu[j] = alpha[id[j]] + beta * X[j] + gamma * Z[id[j]] + delta * Xbar[id[j]];
    }
    Y ~ poisson_log(log_mu);
}
