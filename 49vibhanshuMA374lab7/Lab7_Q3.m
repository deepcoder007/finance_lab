function [] = Lab7_Q3()
    clc;
    figure_i = 1;
    figure_name = 'Lab7_Q3-Figure';
    % Parameters for classical BSM.
    T = 1; K = 1; r = 0.05; sig = 0.6;
    t_vec = 0:0.01:1;
    s_vec = 0.5:0.01:1.5;

    % Surface Plot for Call.
    c_s_t_var = zeros(length(t_vec), length(s_vec));
    fig_name = ['Surface Plot of (s, t) vs. C(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ', t = ', num2str(t_vec(1)), ' to ', num2str(t_vec(length(t_vec))), ' with an increment of ', num2str(t_vec(2) - t_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t_vec)
        c_s_t_var(i, :) = BSCall(T, K, r, sig, t_vec(i), s_vec);
    end
    surf(s_vec, t_vec, c_s_t_var);
    xlabel('s');
    ylabel('t');
    zlabel('C(t, s)');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Surface Plot for Put.
    p_s_t_var = zeros(length(t_vec), length(s_vec));
    fig_name = ['Surface Plot of (s, t) vs. P(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ', t = ', num2str(t_vec(1)), ' to ', num2str(t_vec(length(t_vec))), ' with an increment of ', num2str(t_vec(2) - t_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t_vec)
        p_s_t_var(i, :) = BSPut(T, K, r, sig, t_vec(i), s_vec);
    end
    surf(s_vec, t_vec, p_s_t_var);
    xlabel('s');
    ylabel('t');
    zlabel('P(t, s)');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
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