function [] = f()
    M = [0.1 0.2 0.15];
    C = [0.005 -0.010 0.004; -0.010 0.040 -0.002; 0.004 -0.002 0.023];
    
    [mean_vec, var_vec] = MarkowitzEfficientFrontier(M, C);
    plot(var_vec, mean_vec)
    [mean_vec, var_vec ] = my_func( M,C);
    plot(var_vec,mean_vec)
    grid on
end    

function [ my_mean, my_var ] = my_func( m, C)
    

    my_mean = 0:0.01:0.3;
    
    for i = 1:length(my_mean)
        mu = my_mean(i);
        n = length(m);
        u = ones(1,n);
        a = u*inv(C)*(u');
        b = u*inv(C)*(m');
        c = m*inv(C)*(m'); 
        D1 = c - mu*b;
        D2 = mu*a - b;
        D3 = c*a - b*b;
        w = (D1*u*inv(C) - D2*m*inv(C))/D3;
        my_var(1,i)= (w*C*(w'));
    end    
end
    
    
function [port_mean_vec, port_var_vec] = MarkowitzEfficientFrontier(mean_vec, cov_mat)
    n = length(mean_vec);
    u = ones(1, n);
    a = (u / cov_mat) * u';
    b = (u / cov_mat) * mean_vec';
    c = (mean_vec / cov_mat) * mean_vec';
    del = (a * c) - (b * b);
    port_mean_vec = 0:0.01:0.3;
    port_var_vec = (a * (port_mean_vec .^ 2)) - (2 * b * port_mean_vec) + c;
    port_var_vec = port_var_vec / del;
end
 

    % Parameters for calculating the efficient frontier.
    