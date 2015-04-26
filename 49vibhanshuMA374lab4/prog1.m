function [] = Lab4_Q1()
    clc;
    figure_name = 'Lab4_Q1-Figure';
    figure_i = 1;
    % Parameters for calculating the efficient frontier.
    M = [0.1 0.2 0.15];
    C = [0.005 -0.010 0.004; -0.010 0.040 -0.002; 0.004 -0.002 0.023];
    
    [mean_vec, var_vec] = MarkowitzEfficientFrontier(M, C);
    %[mean_vec, var_vec] = my_func(M, C);
    
    
    fprintf('Part A - Figure 1');
    fig_name = ['\sigma vs. \mu (\mu = ', num2str(mean_vec(1)), ' to ', num2str(mean_vec(length(mean_vec))), ' with an increment of ', num2str(mean_vec(2) - mean_vec(1)), ')'];
    figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    p = plot(var_vec, mean_vec, 'r');
    grid on
    xlabel('\sigma');
    ylabel('\mu');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    
    figure_i = figure_i + 1;
    fprintf('\n\nPart B\n\n');
    u = ones(1, length(M));
    a = (u / C) * u';
    b = (u / C) * M';
    c = (M / C) * M';
    del = (a * c) - (b * b);
    for i = 2:2:20
        l1 = (c - (b * mean_vec(i))) / del;
        l2 = ((a * mean_vec(i)) - b) / del;
        weights = ((l1 * u) + (l2 * M)) / C;
        fprintf('For mean = %.8f, variance = %.8f, ', mean_vec(i), var_vec(i));
        display(weights);
    end
    
    
    fprintf('\nPart C\n\n');
    a = (u / C) * u';
    b = (u / C) * M';
    c = (M / C) * M';
    del = (a * c) - (b * b);
    risk = 0.15;
    returns = roots([a (-2 * b) (c - (risk * risk * del))]);
    fprintf('Returns are\n');
    disp(returns);
    
    fprintf('\nPart D\n\n');
    returns = 0.18;
    risk = ((a * returns * returns) - (2 * b * returns) + c) / del;
    fprintf('Minimum Risk is\n');
    disp(risk);
    
    fprintf('\nPart E\n\n');
    rf = 0.10;
    u = ones(1, length(M));
    wt_m = (M - (rf * u)) / C;
    wt_m = wt_m / ((M - (rf * u)) / C * u');
    ret_m = M * wt_m';
    sig_m = sqrt(wt_m * C * wt_m');
    fprintf('The Market Portfolio has weights\n');
    disp(wt_m);
    sigs = 0:0.01:0.3;
    rets = rf + (sigs * ((ret_m - rf) / sig_m));
    fig_name = ['\sigma vs. \mu (\sigma = ', num2str(sigs(1)), ' to ', num2str(sigs(length(sigs))), ' with an increment of ', num2str(sigs(2) - sigs(1)), ')'];
    figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    p = plot(sigs, rets, 'r');
    grid on
    xlabel('\sigma');
    ylabel('\mu');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    
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
        my_var(1,i)= sqrt(w*C*(w'));
    end    
end
    
