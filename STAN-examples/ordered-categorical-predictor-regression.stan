data {
  int J;
  int N;
  array[N] int<lower=1> H;
  vector[N] X;
  vector[N] Y;
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
  simplex[J] delta;
}

model {
  vector[N] mu;
  vector[J + 1] delta_j;
  delta_j = append_row(0.0, delta); // simplifies book-keeping below
  
  // Construct vector of parameters for Dirichlet prior
  vector[J] a;
  for(j in 1:J) {
    a[j] = 2.0; // change as desired: (exchangeable Dirichlet distribution)
  }
  delta ~ dirichlet(a);
  
  sigma ~ exponential(1);
  beta ~ normal(0, 2);
  alpha ~ normal(0, 2);
  
  for(i in 1:N) {
    mu[i] = alpha + beta * (1 - sum(delta_j[1:H[i]])) * X[i]; 
  }
  Y ~ normal(mu, sigma);
  
}
