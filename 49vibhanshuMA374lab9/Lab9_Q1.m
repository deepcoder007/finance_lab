function [] = Lab9_Q1()
    clc;
    figure_name = 'Lab9_Q1-Figure';
    figure_i = 1;
    opt_data = csvread('NIFTYOptionData-use.csv', 1, 2, [1, 2, 739, 5]);
    strike_price = opt_data(:, 1);
    put_price = opt_data(:, 2);
    call_price = opt_data(:, 3);
    maturity = opt_data(:, 4);
    
    % 3D Plots.
    % Call Option.
    fig_name = 'Plot of Maturity and Strike Price vs. Call Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot3(maturity, strike_price, call_price, 'b+');
    grid on;
    xlabel('Maturity');
    ylabel('Strike Price');
    zlabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Put Option.
    fig_name = 'Plot of Maturity and Strike Price vs. Put Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot3(maturity, strike_price, put_price, 'r+');
    grid on;
    xlabel('Maturity');
    ylabel('Strike Price');
    zlabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % 2D Plots.
    % Call Option.
    fig_name = 'Plot of Strike Price vs. Call Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(strike_price, call_price, 'b.');
    grid on;
    xlabel('Strike Price');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = 'Plot of Maturity vs. Call Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(maturity, call_price, 'b.');
    grid on;
    xlabel('Maturity');
    ylabel('Call Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    % Put Option.
    fig_name = 'Plot of Strike Price vs. Put Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(strike_price, put_price, 'r.');
    grid on;
    xlabel('Strike Price');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;
    fig_name = 'Plot of Maturity vs. Put Option Price';
    p = figure('Position', [0, 0, 640, 480], 'Name', fig_name);
    plot(maturity, put_price, 'r.');
    grid on;
    xlabel('Maturity');
    ylabel('Put Price');
    title(fig_name);
    saveas(p, [figure_name, num2str(figure_i)], 'png');
end