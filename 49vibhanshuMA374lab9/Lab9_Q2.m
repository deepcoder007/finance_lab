function [] = Lab9_Q2()
    clc;
    figure_name = 'Lab9_Q2-Figure';
    figure_i = 1;
    opt_data = csvread('NIFTYOptionData-use.csv', 1, 2, [1, 2, 739, 5]);
    strike_price = opt_data(:, 1);
    call_price = opt_data(:, 3);
    maturity = opt_data(:, 4);
    s0 = 5633.85; r = 0.05;

    n = length(strike_price);
    tol = 10^-6;
    imp_vol = zeros(1, n);
    for i = 1:n
        sig0 = 0.5;
        sig1 = 1;
        K = strike_price(i);
        T = maturity(i);
        V = call_price(i);
        while sig1 > 0 && sig0 > 0
            d1 = log(s0 / K) + ((r + (sig0 * sig0 / 2)) * T);
            d1 = d1 / (sig0 * sqrt(T));
            d2 = d1 - (sig0 * sqrt(T));
            f = ((normcdf(d1) * s0) - (normcdf(d2) * K * exp(-r * T))) - V;
            fdx = normpdf(d1) * s0 * sqrt(T);
            sig1 = sig0 - (f / fdx);
            if sig1 < 0
                break;
            end
            if abs(sig0 - sig1) < tol
                break;
            end
            sig0 = sig1;
        end
        imp_vol(i) = sig0;
    end

    % 3D Plot.
    fig_name = 'Plot of Maturity and Strike Price vs. Implied Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot3(maturity, strike_price, imp_vol, 'r+');
    axis([min(maturity) max(maturity) min(strike_price) max(strike_price) 0 1]);
    grid on;
    xlabel('Maturity');
    ylabel('Strike Price');
    zlabel('Implied Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % 2D Plots.
    fig_name = 'Plot of Strike Price vs. Implied Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(strike_price, imp_vol, 'r.');
    axis([min(strike_price) max(strike_price) 0 1]);
    grid on;
    xlabel('Strike Price');
    ylabel('Implied Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = 'Plot of Maturity vs. Implied Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(maturity, imp_vol, 'r.');
    axis([min(maturity) max(maturity) 0 1]);
    grid on;
    xlabel('Maturity');
    ylabel('Implied Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
end