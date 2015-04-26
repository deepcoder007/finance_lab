function [] = Lab7_Q2()
    clc;
    figure_i = 1;
    figure_name = 'Lab7_Q2-Figure';
    % Parameters for classical BSM.
    T = 1; K = 1; r = 0.05; sig = 0.6;
    t = [0 0.2 0.4 0.6 0.8 1];
    plot_col = ['r', 'b', 'g', 'k', 'c', 'm'];

    % For Call.
    s_vec = 0.5:0.01:1.5;
    fig_name = ['Plot of s vs. C(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t)
        c_s_t = BSCall(T, K, r, sig, t(i), s_vec);
        plot(s_vec, c_s_t, plot_col(i));
        grid on
        xlabel('s');
        ylabel('C(t, s)');
        title(fig_name);
        hold on;
    end
    hold off;
    legend('Location', 'NorthWest', 't = 0.0', 't = 0.2', 't = 0.4', 't = 0.6', 't = 0.8', 't = 1.0');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % For Put.
    fig_name = ['Plot of s vs. P(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t)
        p_s_t = BSPut(T, K, r, sig, t(i), s_vec);
        plot(s_vec, p_s_t, plot_col(i));
        grid on
        xlabel('s');
        ylabel('P(t, s)');
        title(fig_name);
        hold on;
    end
    hold off;
    legend('Location', 'NorthEast', 't = 0.0', 't = 0.2', 't = 0.4', 't = 0.6', 't = 0.8', 't = 1.0');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Surface Plot for Call.
    c_s_t_var = zeros(length(t), length(s_vec));
    fig_name = ['Surface Plot of (s, t) vs. C(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t)
        c_s_t_var(i, :) = BSCall(T, K, r, sig, t(i), s_vec);
    end
    stem3(s_vec, t, c_s_t_var);
    xlabel('s');
    ylabel('t');
    zlabel('C(t, s)');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Surface Plot for Put.
    p_s_t_var = zeros(length(t), length(s_vec));
    fig_name = ['Surface Plot of (s, t) vs. P(t, s) (s = ', num2str(s_vec(1)), ' to ', num2str(s_vec(length(s_vec))), ' with an increment of ', num2str(s_vec(2) - s_vec(1)), ')'];
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:length(t)
        p_s_t_var(i, :) = BSPut(T, K, r, sig, t(i), s_vec);
    end
    stem3(s_vec, t, p_s_t_var);
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