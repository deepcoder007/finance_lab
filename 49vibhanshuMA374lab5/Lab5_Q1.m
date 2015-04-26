function [] = Lab5_Q1()
    clc;
    figure_name = 'Lab5_Q1-Figure';
    figure_i = 1;
    % Parameters for calculating the efficient frontier.
    M = [0.1 0.2 0.15];
    C = [0.005 -0.010 0.004; -0.010 0.040 -0.002; 0.004 -0.002 0.023];
    
    [mean_vec, var_vec] = MarkowitzEfficientFrontier(M, C);
    [mean_vec1, var_vec1] = MarkowitzEfficientFrontier(M(1:2), C(1:2, 1:2));
    [mean_vec2, var_vec2] = MarkowitzEfficientFrontier(M(2:3), C(2:3, 2:3));
    [mean_vec3, var_vec3] = MarkowitzEfficientFrontier(M(1:2:3), C(1:2:3, 1:2:3));
    w1 = rand(1, 5000);
    w2 = rand(1, 5000);
    w3 = 1 - (w1 + w2);
    j = 1;
    for i = 1:length(w1)
        if (w1(i) >= 0) && (w2(i) >= 0) && (w3(i) >= 0)
            wts_tmp = [w1(i) w2(i) w3(i)];
            mean_vec4(j) = M * wts_tmp';
            var_vec4(j) = wts_tmp * C * wts_tmp';
            j = j+1;
        end
    end

    fig_name = ['All Minimum Variance Curves, \sigma vs. \mu (\mu = ', num2str(mean_vec(1)), ' to ', num2str(mean_vec(length(mean_vec))), ' with an increment of ', num2str(mean_vec(2) - mean_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(sqrt(var_vec), mean_vec, 'r', sqrt(var_vec1), mean_vec1, 'b', sqrt(var_vec2), mean_vec2, 'g', sqrt(var_vec3), mean_vec3, 'k');
    grid on
    xlabel('\sigma');
    ylabel('\mu');
    title(fig_name);
    legend('All 3', '1, 2', '2, 3', '1, 3');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    fig_name = 'Plot of Feasible Region Assuming No Short Sales (\sigma vs. \mu)';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(sqrt(var_vec), mean_vec, 'r', sqrt(var_vec1), mean_vec1, 'b', sqrt(var_vec2), mean_vec2, 'g', sqrt(var_vec3), mean_vec3, 'k', sqrt(var_vec4), mean_vec4, 'r.');
    grid on
    xlabel('\sigma');
    ylabel('\mu');
    title(fig_name);
    legend('All 3', '1, 2', '2, 3', '1, 3', 'Feasible Region');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    u = ones(1, length(M));
    a = (u / C) * u';
    b = (u / C) * M';
    c = (M / C) * M';
    del = (a * c) - (b * b);
    j = 1;
    for i = 2:2:20
        l1 = (c - (b * mean_vec(i))) / del;
        l2 = ((a * mean_vec(i)) - b) / del;
        weights = ((l1 * u) + (l2 * M)) / C;
        w1_p(j) = weights(1);
        w2_p(j) = weights(2);
        j = j + 1;
    end

    fig_name = 'w1 vs. w2 for Points on the Minimum Variance Curve';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    tmp_x = min(w1_p):0.1:max(w1_p);
    plot(w1_p, w2_p, 'r', tmp_x, 1 - tmp_x, 'b', tmp_x, zeros(length(tmp_x)), 'k', zeros(length(tmp_x)), tmp_x, 'k');
    grid on
    xlabel('w1');
    ylabel('w2');
    title(fig_name);
    legend('w1, w2', 'x + y = 1', 'x-axis', 'y-axis');
    saveas(p, [figure_name, num2str(figure_i)], 'png');

    wts_eqn = WeightsByPortfolioMean(M, C);
    fprintf('Weights as a Function of Portfolio Mean:- \n\n');
    disp(wts_eqn);
end

function [weights_eqn] = WeightsByPortfolioMean(M, C)
    syms x;
    u = ones(1, length(M));
    v1 = u / C * M';
    v2 = M / C * M';
    v3 = u / C * u';
    v4 = M / C * u';
    weights_eqn = ((det([1 v1; x v2]) * (u / C)) + (det([v3 1; v4 x]) * (M / C))) / det([v3 v1; v4 v2]);
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
