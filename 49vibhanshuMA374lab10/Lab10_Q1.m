function [] = Lab10_Q1()
    clc;
    figure_name = 'Lab10_Q1-Figure';
    figure_i = 1;
    mu_r = 0.1; sig = 0.2; r = 0.05; s0 = 100; T = 1;
    N_paths = 10; N_pts = 5000;
    cols = hsv(N_paths);

    % Simulated Paths for Real World.
    fig_name = 'Plot of Time vs. Stock Price in the Real World';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:N_paths
        [t, st_path] = StockGBM(s0, mu_r, sig, T, N_pts);
        plot(t, st_path, 'Color', cols(i, :));
        hold on
    end
    hold off
    grid on;
    xlabel('Time');
    ylabel('Stock Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Simulated Paths for Risk-Neutral World.
    fig_name = 'Plot of Time vs. Stock Price in the Risk-Neutral World';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:N_paths
        [t, st_path] = StockGBM(s0, r, sig, T, N_pts);
        plot(t, st_path, 'Color', cols(i, :));
        hold on
    end
    hold off
    grid on;
    xlabel('Time');
    ylabel('Stock Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Computing Price for Asian Option.
    % Parameter definition.
    r = 0.05; sig = 0.2; T = 0.5; s0 = 100; K = 105;
    N_paths = 1000; N_prices = 1000; N_vals = 100;

    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig, K, T, N_prices, N_paths);
    end
    [put_l, put_r] = ConfidenceInterval95(put_prices);
    [call_l, call_r] = ConfidenceInterval95(call_prices);
    fprintf('95%% Confidence Interval for Asian Call Option with K = %d,\n', K);
    fprintf('[%0.6f, %0.6f]\n\n', call_l, call_r);
    fprintf('95%% Confidence Interval for Asian Put Option with K = %d,\n', K);
    fprintf('[%0.6f, %0.6f]\n\n', put_l, put_r);

    % For K = 110.
    K_new = 110;
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig, K_new, T, N_prices, N_paths);
    end
    [put_l, put_r] = ConfidenceInterval95(put_prices);
    [call_l, call_r] = ConfidenceInterval95(call_prices);
    fprintf('95%% Confidence Interval for Asian Call Option with K = %d,\n', K_new);
    fprintf('[%0.6f, %0.6f]\n\n', call_l, call_r);
    fprintf('95%% Confidence Interval for Asian Put Option with K = %d,\n', K_new);
    fprintf('[%0.6f, %0.6f]\n\n', put_l, put_r);

    % For K = 90.
    K_new = 90;
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig, K_new, T, N_prices, N_paths);
    end
    [put_l, put_r] = ConfidenceInterval95(put_prices);
    [call_l, call_r] = ConfidenceInterval95(call_prices);
    fprintf('95%% Confidence Interval for Asian Call Option with K = %d,\n', K_new);
    fprintf('[%0.6f, %0.6f]\n\n', call_l, call_r);
    fprintf('95%% Confidence Interval for Asian Put Option with K = %d,\n', K_new);
    fprintf('[%0.6f, %0.6f]\n\n', put_l, put_r);

    % Sensitivity Analysis.
    % Varying S0.
    s0_var = 50:1:150;
    N_vals = length(s0_var);
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0_var(i), r, sig, K, T, N_prices, N_paths);
    end
    fig_name = ['Plot of S0 vs. Asian Call Price (S0 = ', num2str(s0_var(1)), ' to ', num2str(s0_var(N_vals)), ' with an increment of ', num2str(s0_var(2) - s0_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(s0_var, call_prices, 'b');
    grid on;
    xlabel('S0');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = ['Plot of S0 vs. Asian Put Price (S0 = ', num2str(s0_var(1)), ' to ', num2str(s0_var(N_vals)), ' with an increment of ', num2str(s0_var(2) - s0_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(s0_var, put_prices, 'r');
    grid on;
    xlabel('S0');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    
    % Varying r.
    r_var = 0:0.01:0.4;
    N_vals = length(r_var);
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r_var(i), sig, K, T, N_prices, N_paths);
    end
    fig_name = ['Plot of r vs. Asian Call Price (r = ', num2str(r_var(1)), ' to ', num2str(r_var(N_vals)), ' with an increment of ', num2str(r_var(2) - r_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(r_var, call_prices, 'b');
    grid on;
    xlabel('r');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = ['Plot of r vs. Asian Put Price (r = ', num2str(r_var(1)), ' to ', num2str(r_var(N_vals)), ' with an increment of ', num2str(r_var(2) - r_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(r_var, put_prices, 'r');
    grid on;
    xlabel('r');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Varying sigma.
    sig_var = 0:0.01:0.5;
    N_vals = length(sig_var);
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig_var(i), K, T, N_prices, N_paths);
    end
    fig_name = ['Plot of \sigma vs. Asian Call Price (\sigma = ', num2str(sig_var(1)), ' to ', num2str(sig_var(N_vals)), ' with an increment of ', num2str(sig_var(2) - sig_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(sig_var, call_prices, 'b');
    grid on;
    xlabel('\sigma');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = ['Plot of \sigma vs. Asian Put Price (\sigma = ', num2str(sig_var(1)), ' to ', num2str(sig_var(N_vals)), ' with an increment of ', num2str(sig_var(2) - sig_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(sig_var, put_prices, 'r');
    grid on;
    xlabel('\sigma');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Varying K.
    K_var = 50:1:150;
    N_vals = length(K_var);
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig, K_var(i), T, N_prices, N_paths);
    end
    fig_name = ['Plot of K vs. Asian Call Price (K = ', num2str(K_var(1)), ' to ', num2str(K_var(N_vals)), ' with an increment of ', num2str(K_var(2) - K_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(K_var, call_prices, 'b');
    grid on;
    xlabel('K');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = ['Plot of K vs. Asian Put Price (K = ', num2str(K_var(1)), ' to ', num2str(K_var(N_vals)), ' with an increment of ', num2str(K_var(2) - K_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(K_var, put_prices, 'r');
    grid on;
    xlabel('K');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Varying T.
    T_var = 0.2:0.01:1.2;
    N_vals = length(T_var);
    put_prices = zeros(1, N_vals);
    call_prices = zeros(1, N_vals);
    for i = 1:N_vals
        [put_prices(i), call_prices(i)] = AsianOptionPrice(s0, r, sig, K, T_var(i), N_prices, N_paths);
    end
    fig_name = ['Plot of T vs. Asian Call Price (T = ', num2str(T_var(1)), ' to ', num2str(T_var(N_vals)), ' with an increment of ', num2str(T_var(2) - T_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(T_var, call_prices, 'b');
    grid on;
    xlabel('T');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = ['Plot of T vs. Asian Put Price (T = ', num2str(T_var(1)), ' to ', num2str(T_var(N_vals)), ' with an increment of ', num2str(T_var(2) - T_var(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(T_var, put_prices, 'r');
    grid on;
    xlabel('T');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
end

function [ival1, ival2] = ConfidenceInterval95(vals)
    N = length(vals);
    avg_val = mean(vals);
    var_val = sqrt(var(vals));
    ival1 = avg_val - (1.96 * var_val / sqrt(N));
    ival2 = avg_val + (1.96 * var_val / sqrt(N));
end

function [put_price, call_price] = AsianOptionPrice(s0, r, sig, K, T, N_prices, N_paths)
    payoff_call = zeros(1, N_paths);
    payoff_put = zeros(1, N_paths);
    for i = 1:N_paths
        [t, st_path] = StockGBM(s0, r, sig, T, N_prices);
        tmp_var = mean(st_path);
        payoff_call(i) = max((tmp_var - K), 0);
        payoff_put(i) = max((K - tmp_var), 0);
    end
    put_price = mean(payoff_put) * exp(-r * T);
    call_price = mean(payoff_call) * exp(-r * T);
end

function [t, st_path] = StockGBM(s0, mu_r, sig, T, N)
    del_T = T / N;
    norm_dis = randn(1, N);
    norm_dis1 = [0 cumsum(norm_dis)] * sqrt(del_T);
    t = 0:del_T:T;
    st_path = ((mu_r - (0.5 * sig * sig)) .* t) + (sig .* norm_dis1);
    st_path = s0 * exp(st_path);
end