data {
  int<lower=0> N;
  array[N] int<lower=0> y;
}

parameters {
  real alpha_p;
  real alpha_lam; 
}

transformed parameters {
  real p = inv_logit(alpha_p);
  real lambda = exp(alpha_lam);
}

model {
  alpha_p ~ normal(-1.5, 1);
  alpha_lam ~ normal(1, 0.5);
  
  for(i in 1:N) {
    if(y[i] == 0) {
      target += log_mix(p, 0, poisson_log_lpmf(0 | alpha_lam));
    } else {
      target += log1m(p) + poisson_log_lpmf(y[i] | alpha_lam);
    }
  }
}
