// Based on this blog post:
// <https://luiarthur.github.io/TuringBnpBenchmarks/dpsbgmm>
//
// I made as few changes as possible but there has been a change to STAN syntax
// since version 2.33.0 that initially caused the following errors during 
// compilation:
//
// "Declaration of arrays by placing brackets after a variable name was removed 
//  in Stan 2.33.0. Instead use the array keyword before the type. This can be
//  changed automatically using the auto-format flag to stanc"

data {
  int<lower=0> K;  // Number of clusters
  int<lower=0> N;  // Number of observations
  array[N] real y;  // observations
  real<lower=0> alpha_shape;
  real<lower=0> alpha_rate;
  real<lower=0> sigma_shape;
  real<lower=0> sigma_rate;
}

parameters {
  array[K] real mu; // cluster means
  // real <lower=0,upper=1> v[K - 1];  // stickbreak components
  vector<lower=0,upper=1>[K - 1] v;  // stickbreak components
  array[K] real<lower=0> sigma;  // error scale
  real<lower=0> alpha;  // hyper prior DP(alpha, base)
}

transformed parameters {
  simplex[K] eta;
  vector<lower=0,upper=1>[K - 1] cumprod_one_minus_v;

  cumprod_one_minus_v = exp(cumulative_sum(log1m(v)));
  eta[1] = v[1];
  eta[2:(K-1)] = v[2:(K-1)] .* cumprod_one_minus_v[1:(K-2)];
  eta[K] = cumprod_one_minus_v[K - 1];
}

model {
  array[K] real ps;
  // real alpha = 1;
  
  alpha ~ gamma(alpha_shape, alpha_rate);  // mean = a/b = shape/rate 
  sigma ~ gamma(sigma_shape, sigma_rate);
  mu ~ normal(0, 3);
  v ~ beta(1, alpha);

  for(i in 1:N){
    for(k in 1:K){
      ps[k] = log(eta[k]) + normal_lpdf(y[i] | mu[k], sigma[k]);
    }
    target += log_sum_exp(ps);
  }
}

generated quantities {
  real ll;
  array[K] real ps_;
  
  ll = 0;
  for(i in 1:N){
    for(k in 1:K){
      ps_[k] = log(eta[k]) + normal_lpdf(y[i] | mu[k], sigma[k]);
    }
    ll += log_sum_exp(ps_);
  }  
}
