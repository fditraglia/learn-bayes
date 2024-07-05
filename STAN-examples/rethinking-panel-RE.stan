data{
  int<lower=0> Ng;
  int<lower=0> Ni;
  array[Ni] int<lower=0> Y; 
  vector[Ng] Z; 
  vector[Ni] X; 
  array[Ni] int<lower=1> g;
}

parameters{
     vector[Ng] epsilon; 
     real beta; 
     real gamma;
     real abar;
     real<lower=0> tau;
}

transformed parameters {
  vector[Ng] alpha = abar + tau * epsilon;
}

model{
    vector[Ni] logit_p;
    gamma ~ normal(0, 1); 
    beta ~ normal(0, 1);
    abar ~ normal(0, 1);
    epsilon ~ normal(0, 1);
    tau ~ exponential(1);
    
    for (i in 1:Ni) {
        logit_p[i] = alpha[g[i]] + beta * X[i] + gamma * Z[g[i]];
    }
    Y ~ bernoulli_logit(logit_p);
}
