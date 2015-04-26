function [] = Lab8_Q1 ()
    clc;
    figure_i = 1;
    figure_name = 'Lab8_Q1-Figure';
    bse_data = csvread ('bsedaily_use.csv', 0, 0, [0, 0, 29, 17]);
    nse_data = csvread ('nsedaily_use.csv', 0, 0, [0, 0, 29, 19]);
    
    %%%%%%%%%%%%%%%% PART A %%%%%%%%%%%%%%%%
    fprintf ('Part A\n\n');
    bse_vol = historicalVolatilityAnnual (bse_data);
    nse_vol = historicalVolatilityAnnual (nse_data);
    fprintf ('BSE Volatility - \n');
    disp (bse_vol);
    fprintf ('\nNSE Volatility - \n');
    disp (nse_vol);
    %%%%%%%%%%%%%%%% PART A %%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%% PART B %%%%%%%%%%%%%%%%
    fprintf ('\nPart B\n\n');
    s0_bse_vec = bse_data (1, :); s0_nse_vec = nse_data (1, :);
    r = 0.05; K_nse_vec = s0_nse_vec; K_bse_vec = s0_bse_vec;
    T = 0.5;
    n_bse = length (s0_bse_vec); n_nse = length (s0_nse_vec);
    fprintf ('BSE European Option Prices:-\n\n');
    for i = 1:n_bse
        call_val = BSCall (T, K_bse_vec(i), r, bse_vol(i), 0, s0_bse_vec(i));
        put_val = BSPut (T, K_bse_vec(i), r, bse_vol(i), 0, s0_bse_vec(i));
        fprintf ('For K = %f, \tCall Value = %f, \tPut Value = %f\n', K_bse_vec(i), call_val, put_val);
    end
    fprintf ('\nNSE European Option Prices:-\n\n');
    for i = 1:n_nse
        call_val = BSCall (T, K_nse_vec(i), r, nse_vol(i), 0, s0_nse_vec(i));
        put_val = BSPut (T, K_nse_vec(i), r, nse_vol(i), 0, s0_nse_vec(i));
        fprintf ('For K = %f, \tCall Value = %f, \tPut Value = %f\n', K_nse_vec(i), call_val, put_val);
    end

    fprintf ('\nBSE European Option Prices (Varying K):-\n');
    for i = 1:n_bse
        K_new = K_bse_vec(i) * (0.5:0.1:1.5);
        K_l = length (K_new);
        fprintf ('\nFor Stock %d\n\n', i);
        for j = 1:K_l
            call_val = BSCall (T, K_new(j), r, bse_vol(i), 0, s0_bse_vec(i));
            put_val = BSPut (T, K_new(j), r, bse_vol(i), 0, s0_bse_vec(i));
            fprintf ('For K = %f, \tCall Value = %f, \tPut Value = %f\n', K_new(j), call_val, put_val);
        end
    end
    fprintf ('\nNSE European Option Prices (Varying K):-\n');
    for i = 1:n_nse
        K_new = K_nse_vec(i) * (0.5:0.1:1.5);
        K_l = length (K_new);
        fprintf ('\nFor Stock %d\n\n', i);
        for j = 1:K_l
            call_val = BSCall (T, K_new(j), r, nse_vol(i), 0, s0_nse_vec(i));
            put_val = BSPut (T, K_new(j), r, nse_vol(i), 0, s0_nse_vec(i));
            fprintf ('For K = %f, \tCall Value = %f, \tPut Value = %f\n', K_new(j), call_val, put_val);
        end
    end
    %%%%%%%%%%%%%%%% PART B %%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%% PART C %%%%%%%%%%%%%%%%
    fprintf ('\n\nPart C - Figures 1 to 50\n\n');

    % For BSE Data.
    bse_time = 30:30:1950;
    bse_time = bse_time - 1;
    bse_time = [bse_time, 1971];
    n_bse_time = length (bse_time);
    vol_st_bse = zeros (n_bse_time, n_bse);
    bse_col = hsv (n_bse);
    for i = 1:n_bse_time
        bse_data_tmp = csvread ('bsedaily_use.csv', 0, 0, [0, 0, bse_time(i), 17]);
        vol_st_bse(i, :) = historicalVolatilityAnnual (bse_data_tmp);
    end
    fig_name = 'Plot of Time Period Length vs. Volatility for BSE Stocks and Sensex';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_bse
        plot (bse_time, vol_st_bse(:, i), 'Color', bse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Volatility');
    title (fig_name);
    legend ('Location', 'WestOutside', 'SENSEX', 'WIPRO', 'LNT', 'AIRTEL', 'TATAPOWER', 'HUL', 'SUNPHARMA', 'MARUTI', 'ONGC', 'CIPLA', 'ALLBANK', 'BLUEDART', 'CORPBANK', 'HMTSL', 'BELSL', 'ESSAROIL', 'CRISIL', 'BATA');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    fig_name = 'Plot of Time Period Length vs. Call Option Price for BSE Stocks and Sensex';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_bse
        call_val = BSCall (T, K_bse_vec(i), r, vol_st_bse(:, i), 0, s0_bse_vec(i));
        plot (bse_time, call_val, 'Color', bse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Call Price');
    title (fig_name);
    legend ('Location', 'WestOutside', 'SENSEX', 'WIPRO', 'LNT', 'AIRTEL', 'TATAPOWER', 'HUL', 'SUNPHARMA', 'MARUTI', 'ONGC', 'CIPLA', 'ALLBANK', 'BLUEDART', 'CORPBANK', 'HMTSL', 'BELSL', 'ESSAROIL', 'CRISIL', 'BATA');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    fig_name = 'Plot of Time Period Length vs. Put Option Price for BSE Stocks and Sensex';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_bse
        put_val = BSPut (T, K_bse_vec(i), r, vol_st_bse(:, i), 0, s0_bse_vec(i));
        plot (bse_time, put_val, 'Color', bse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Put Price');
    title (fig_name);
    legend ('Location', 'WestOutside', 'SENSEX', 'WIPRO', 'LNT', 'AIRTEL', 'TATAPOWER', 'HUL', 'SUNPHARMA', 'MARUTI', 'ONGC', 'CIPLA', 'ALLBANK', 'BLUEDART', 'CORPBANK', 'HMTSL', 'BELSL', 'ESSAROIL', 'CRISIL', 'BATA');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    K_mul = 0.5:0.1:1.5;
    K_l = length (K_mul);
    for i = 1:K_l
        fig_name = ['Plot of Time Period Length vs. Call Option Price for BSE Stocks and Sensex for A = ', num2str(K_mul(i))];
        p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
        K_new = K_mul(i) * K_bse_vec;
        for j = 1:n_bse
            call_val = BSCall (T, K_new(j), r, vol_st_bse(:, j), 0, s0_bse_vec(j));
            plot (bse_time, call_val, 'Color', bse_col (j, :));
            hold on
        end
        hold off
        xlabel ('Days');
        ylabel ('Call Price');
        title (fig_name);
        legend ('Location', 'WestOutside', 'SENSEX', 'WIPRO', 'LNT', 'AIRTEL', 'TATAPOWER', 'HUL', 'SUNPHARMA', 'MARUTI', 'ONGC', 'CIPLA', 'ALLBANK', 'BLUEDART', 'CORPBANK', 'HMTSL', 'BELSL', 'ESSAROIL', 'CRISIL', 'BATA');
        saveas(p, [figure_name, num2str(figure_i)], 'png');
        figure_i = figure_i + 1;
    end
    for i = 1:K_l
        fig_name = ['Plot of Time Period Length vs. Put Option Price for BSE Stocks and Sensex for A = ', num2str(K_mul(i))];
        p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
        K_new = K_mul(i) * K_bse_vec;
        for j = 1:n_bse
            put_val = BSPut (T, K_new(j), r, vol_st_bse(:, j), 0, s0_bse_vec(j));
            plot (bse_time, put_val, 'Color', bse_col (j, :));
            hold on
        end
        hold off
        xlabel ('Days');
        ylabel ('Put Price');
        title (fig_name);
        legend ('Location', 'WestOutside', 'SENSEX', 'WIPRO', 'LNT', 'AIRTEL', 'TATAPOWER', 'HUL', 'SUNPHARMA', 'MARUTI', 'ONGC', 'CIPLA', 'ALLBANK', 'BLUEDART', 'CORPBANK', 'HMTSL', 'BELSL', 'ESSAROIL', 'CRISIL', 'BATA');
        saveas(p, [figure_name, num2str(figure_i)], 'png');
        figure_i = figure_i + 1;
    end

    % For NSE Data;
    nse_time = 30:30:1980;
    nse_time = nse_time - 1;
    nse_time = [nse_time, 1987];
    n_nse_time = length (nse_time);
    vol_st_nse = zeros (n_nse_time, n_nse);
    nse_col = hsv (n_nse);
    for i = 1:n_nse_time
        nse_data_tmp = csvread ('nsedaily_use.csv', 0, 0, [0, 0, nse_time(i), 19]);
        vol_st_nse(i, :) = historicalVolatilityAnnual (nse_data_tmp);
    end
    fig_name = 'Plot of Time Period Length vs. Volatility for NSE Stocks and Nifty';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_nse
        plot (nse_time, vol_st_nse(:, i), 'Color', nse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Volatility');
    title (fig_name);
    legend ('Location', 'WestOutside', 'NIFTY', 'ITC', 'DRREDDY', 'BPCL', 'INFY', 'ICICI', 'BHEL', 'TCS', 'SBIN', 'GAIL', 'HCL', 'BATA', 'TATACHEM', 'IDBI', 'SAIL', 'ASHOKLEY', 'JSWSTEEL', 'ANDHRABANK', 'UNIONBANK', 'MRF');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    fig_name = 'Plot of Time Period Length vs. Call Option Price for NSE Stocks and Nifty';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_nse
        call_val = BSCall (T, K_nse_vec(i), r, vol_st_nse(:, i), 0, s0_nse_vec(i));
        plot (nse_time, call_val, 'Color', nse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Call Price');
    title (fig_name);
    legend ('Location', 'WestOutside', 'NIFTY', 'ITC', 'DRREDDY', 'BPCL', 'INFY', 'ICICI', 'BHEL', 'TCS', 'SBIN', 'GAIL', 'HCL', 'BATA', 'TATACHEM', 'IDBI', 'SAIL', 'ASHOKLEY', 'JSWSTEEL', 'ANDHRABANK', 'UNIONBANK', 'MRF');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    fig_name = 'Plot of Time Period Length vs. Put Option Price for NSE Stocks and Nifty';
    p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
    for i = 1:n_nse
        put_val = BSPut (T, K_nse_vec(i), r, vol_st_nse(:, i), 0, s0_nse_vec(i));
        plot (nse_time, put_val, 'Color', nse_col (i, :));
        hold on
    end
    hold off
    xlabel ('Days');
    ylabel ('Put Price');
    title (fig_name);
    legend ('Location', 'WestOutside', 'NIFTY', 'ITC', 'DRREDDY', 'BPCL', 'INFY', 'ICICI', 'BHEL', 'TCS', 'SBIN', 'GAIL', 'HCL', 'BATA', 'TATACHEM', 'IDBI', 'SAIL', 'ASHOKLEY', 'JSWSTEEL', 'ANDHRABANK', 'UNIONBANK', 'MRF');
    saveas(p, [figure_name, num2str(figure_i)], 'png');
    figure_i = figure_i + 1;

    K_mul = 0.5:0.1:1.5;
    K_l = length (K_mul);
    for i = 1:K_l
        fig_name = ['Plot of Time Period Length vs. Call Option Price for NSE Stocks and Nifty for A = ', num2str(K_mul(i))];
        p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
        K_new = K_mul(i) * K_nse_vec;
        for j = 1:n_nse
            call_val = BSCall (T, K_new(j), r, vol_st_nse(:, j), 0, s0_nse_vec(j));
            plot (nse_time, call_val, 'Color', nse_col (j, :));
            hold on
        end
        hold off
        xlabel ('Days');
        ylabel ('Call Price');
        title (fig_name);
        legend ('Location', 'WestOutside', 'NIFTY', 'ITC', 'DRREDDY', 'BPCL', 'INFY', 'ICICI', 'BHEL', 'TCS', 'SBIN', 'GAIL', 'HCL', 'BATA', 'TATACHEM', 'IDBI', 'SAIL', 'ASHOKLEY', 'JSWSTEEL', 'ANDHRABANK', 'UNIONBANK', 'MRF');
        saveas(p, [figure_name, num2str(figure_i)], 'png');
        figure_i = figure_i + 1;
    end
    for i = 1:K_l
        fig_name = ['Plot of Time Period Length vs. Put Option Price for NSE Stocks and Nifty for A = ', num2str(K_mul(i))];
        p = figure ('Position', [0, 0, 640, 480], 'Name', fig_name);
        K_new = K_mul(i) * K_nse_vec;
        for j = 1:n_nse
            put_val = BSPut (T, K_new(j), r, vol_st_nse(:, j), 0, s0_nse_vec(j));
            plot (nse_time, put_val, 'Color', nse_col (j, :));
            hold on
        end
        hold off
        xlabel ('Days');
        ylabel ('Put Price');
        title (fig_name);
        legend ('Location', 'WestOutside', 'NIFTY', 'ITC', 'DRREDDY', 'BPCL', 'INFY', 'ICICI', 'BHEL', 'TCS', 'SBIN', 'GAIL', 'HCL', 'BATA', 'TATACHEM', 'IDBI', 'SAIL', 'ASHOKLEY', 'JSWSTEEL', 'ANDHRABANK', 'UNIONBANK', 'MRF');
        saveas(p, [figure_name, num2str(figure_i)], 'png');
        figure_i = figure_i + 1;
    end
    %%%%%%%%%%%%%%%% PART C %%%%%%%%%%%%%%%%
end

function [put_fn] = BSPut(T, K, r, sig, t, s)
    call_val = BSCall(T, K, r, sig, t, s);
    put_fn = (K * exp(-r * (T - t))) - s + call_val;
end

function [call_fn] = BSCall(T, K, r, sig, t, s)
    d1 = log(s / K) + ((r + (sig .* sig / 2)) * (T - t));
    d1 = d1 ./ (sig * sqrt(T - t));
    d2 = d1 - (sig * sqrt(T - t));
    call_fn = (normcdf(d1) .* s) - (normcdf(d2) .* K .* exp(-r * (T - t)));
end

function [vol_st] = historicalVolatilityAnnual (stock_data)
    vol_st = historicalVolatility (stock_data);
    vol_st = vol_st * sqrt (252);
end

function [vol_st] = historicalVolatility (stock_data)
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