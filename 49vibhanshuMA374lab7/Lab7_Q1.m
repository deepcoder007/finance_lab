function [] = Lab7_Q1()
    clc;
    % Parameters for classical BSM.
    T = 7/365; K = 1; r = 0.05; sig = 0.6;
    BSCall(T, K, r, sig, 0, 1)
    BSPut(T, K, r, sig, 0, 1)
end

function [call_fn] = BSCall(T, K, r, sig, t, s)
    d1 = log(s / K) + ((r + (sig * sig / 2)) * (T - t));
    d1 = d1 ./ (sig * sqrt(T - t));
    d2 = d1 - (sig * sqrt(T - t));
    call_fn = (normcdf(d1) .* s) - (normcdf(d2) .* K .* exp(-r * (T - t)));
end

function [put_fn] = BSPut(T, K, r, sig, t, s)
    call_val = BSCall(T, K, r, sig, t, s);
    put_fn = (K * exp(-r * (T - t))) - s + call_val;
end