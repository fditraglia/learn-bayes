data{
     int Ng;
    array[200] int Y;
     vector[30] Z;
     vector[200] X;
    array[200] int g;
}
parameters{
     vector[30] a;
     real bzy;
     real bxy;
}
model{
     vector[200] p;
    bxy ~ normal( 0 , 1 );
    bzy ~ normal( 0 , 1 );
    a ~ normal( 0 , 10 );
    for ( i in 1:200 ) {
        p[i] = a[g[i]] + bxy * X[i] + bzy * Z[g[i]];
        p[i] = inv_logit(p[i]);
    }
    Y ~ bernoulli( p );
}
