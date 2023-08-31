data {
  int<lower=0> N;
  int<lower=0> Ni;
  vector[N] Y; 
  vector[Ni] Z; 
  vector[N] X; 
  vector[Ni] Xbar;
  array[N] int<lower=1> id;
}

parameters {
     vector[Ni] epsilon; 
     real beta; 
     real gamma;
     real delta;
     real abar;
     real<lower=0> tau;
     real<lower=0> sigma;
}

transformed parameters {
  vector[Ni] alpha = abar + tau * epsilon;
}

model {
    vector[N] mu;
    gamma ~ normal(0, 1); 
    beta ~ normal(0, 1);
    delta ~ normal(0, 1);
    abar ~ normal(0, 1);
    epsilon ~ normal(0, 1);
    tau ~ exponential(1);
    sigma ~ exponential(1);
    
    for (j in 1:N) {
        mu[j] = alpha[id[j]] + beta * X[j] + gamma * Z[id[j]] + delta * Xbar[id[j]];
    }
    Y ~ normal(mu, sigma);
}
