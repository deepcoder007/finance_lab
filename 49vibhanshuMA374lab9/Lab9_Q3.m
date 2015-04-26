function [] = Lab9_Q3()
    clc;
    figure_name = 'Lab9_Q3-Figure';
    figure_i = 1;
    opt_data = csvread('NIFTYOptionData-use.csv', 1, 2, [1, 2, 739, 5]);
    nifty_data = csvread('NIFTYData.csv', 1, 1, [1, 1, 1739, 1]);
    strike_price = opt_data(:, 1);
    maturity = opt_data(:, 4);

    n = length(strike_price);
    hist_vol = zeros(1, n);
    for i = 1:n
        days = round(maturity(i) * 365);
        hist_vol(i) = historicalVolatilityAnnual(nifty_data, days);
    end

    % 3D Plot.
    fig_name = 'Plot of Maturity and Strike Price vs. Historical Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot3(maturity, strike_price, hist_vol, 'r+');
    axis([min(maturity) max(maturity) min(strike_price) max(strike_price) 0 1]);
    grid on;
    xlabel('Maturity');
    ylabel('Strike Price');
    zlabel('Historical Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % 2D Plots.
    fig_name = 'Plot of Strike Price vs. Historical Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(strike_price, hist_vol, 'r.');
    axis([min(strike_price) max(strike_price) 0 1]);
    grid on;
    xlabel('Strike Price');
    ylabel('Historical Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = 'Plot of Maturity vs. Historical Volatility';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(maturity, hist_vol, 'r.');
    axis([min(maturity) max(maturity) 0 1]);
    grid on;
    xlabel('Maturity');
    ylabel('Historical Volatility');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
end

function [vol_st] = historicalVolatilityAnnual(stock_data, days)
    vol_st = historicalVolatility (stock_data, days);
    vol_st = vol_st * sqrt (252);
end

function [vol_st] = historicalVolatility(stock_data, days)
    stock_data = stock_data(1:days);
    size_data = size (stock_data);
    n = size_data(2);
    m = size_data(1);
    vol_st = zeros (1, n);
    for i = 1:n
        tmp_data = stock_data (:, i);
        tmp_rets = (tmp_data(1:m-1) - tmp_data(2:m)) ./ tmp_data(2:m);
        vol_st(i) = sqrt (var (tmp_rets));
    end
end