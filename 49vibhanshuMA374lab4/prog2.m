function [] = Lab4_Q2()
    clc;
    figure_name = 'Lab4_Q2-Figure';
    figure_i = 1;
    % Parameters for calculating the efficient frontier.
    asset_price = xlsread('price.xls');
    [M, C] = ReturnMeanCov(asset_price);
    [mean_vec, var_vec] = MarkowitzEfficientFrontier(M, C);
    
    fprintf('Part A - Figure 1\n\n');
    fig_name = ['\sigma vs. \mu (\mu = ', num2str(mean_vec(1)), ' to ', num2str(mean_vec(length(mean_vec))), ' with an increment of ', num2str(mean_vec(2) - mean_vec(1)), ')'];
    figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    p = plot(var_vec, mean_vec, 'r');
    grid on
    xlabel('\sigma');
    ylabel('\mu');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fprintf('\nPart B\n\n');
    rf = 0.07;
    u = ones(1, length(M));
    wt_m = (M - (rf * u)) / C;
    wt_m = wt_m / ((M - (rf * u)) / C * u');
    ret_m = M * wt_m';
    sig_m = sqrt(wt_m * C * wt_m');
    fprintf('The Market Portfolio has weights\n');
    disp(wt_m);
    fprintf('\nPart C - Figure 2\n\n');
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
    figure_i = figure_i + 1;
    
    fprintf('\nPart D - Figure 3\n\n');
    beta_var = 0:0.1:3;
    rets = rf + (beta_var * ((ret_m - rf)));
    fig_name = ['\beta vs. \mu (\beta = ', num2str(beta_var(1)), ' to ', num2str(beta_var(length(beta_var))), ' with an increment of ', num2str(beta_var(2) - beta_var(1)), ')'];
    figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    p = plot(beta_var, rets, 'r');
    grid on
    xlabel('\beta');
    ylabel('\mu');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
end

function [mean_vec, cov_mat] = ReturnMeanCov(prices)
    p_size = size(prices);
    n = p_size(2);
    m = p_size(1);
    mean_vec = zeros(1, n);
    for i = 1:n
        v1 = prices(:, i);
        rets = (v1(2:m) - v1(1:m-1)) ./ v1(1:m-1);
        mean_mat(i, :) = rets;
        mean_vec(i) = mean(rets);
    end
    cov_mat = cov(mean_mat');
end

function [port_mean_vec, port_var_vec] = MarkowitzEfficientFrontier(mean_vec, cov_mat)
    n = length(mean_vec);
    u = ones(1, n);
    a = (u / cov_mat) * u';
    b = (u / cov_mat) * mean_vec';
    c = (mean_vec / cov_mat) * mean_vec';
    del = (a * c) - (b * b);
    port_mean_vec = -0.2:0.01:0.3;
    port_var_vec = (a * (port_mean_vec .^ 2)) - (2 * b * port_mean_vec) + c;
    port_var_vec = port_var_vec / del;
end
