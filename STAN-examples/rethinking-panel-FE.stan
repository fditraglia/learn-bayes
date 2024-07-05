data{
  int<lower=0> Ng;
  int<lower=0> Ni;
  array[Ni] int<lower=0> Y; 
  vector[Ng] Z; 
  vector[Ni] X; 
  array[Ni] int<lower=1> g;
}

parameters{
     vector[Ng] alpha; 
     real beta; 
     real gamma;
}

model{
    vector[Ni] logit_p;
    beta ~ normal(0, 1);
    alpha ~ normal(0, 10);
    for (i in 1:Ni) {
        logit_p[i] = alpha[g[i]] + beta * X[i] + gamma * Z[g[i]];
    }
    Y ~ bernoulli_logit(logit_p);
}
