data{
  int<lower=0> N;
  int<lower=0> Ni;
  vector[N] Y; 
  vector[N] X; 
  array[N] int<lower=1> id;
}

parameters{
     vector[Ni] alpha; 
     real beta; 
     real<lower=0> sigma;
}

model{
    vector[N] mu; 
    beta ~ normal(0, 1);
    alpha ~ normal(0, 10);
    sigma ~ exponential(1);
    for (i in 1:N) {
        mu[i] = alpha[id[i]] + beta * X[i];
    }
    Y ~ normal(mu, sigma);
}
