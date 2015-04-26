function [] = Lab5_Q2()
    clc;
    warning('off', 'all');
    rf = 0.07;
    [ind, nonind] = InterpretData('nsedata1-use.xls', rf);
    fprintf('NSE Indexed Betas - \n\n');
    disp(ind);
    fprintf('NSE Non-Indexed Betas - \n\n');
    disp(nonind);
    [ind, nonind] = InterpretData('bsedata1-use.xls', rf);
    fprintf('BSE Indexed Betas - \n\n');
    disp(ind);
    fprintf('BSE Non-Indexed Betas - \n\n');
    disp(nonind);
    warning('on', 'all');
end

function [beta_index, beta_nonindex] = InterpretData(FileName, rf)
    asset_data = xlsread(FileName);
    index_data = asset_data(:, 1);
    index_equity_data = asset_data(:, 2:11);
    nonindex_equity_data = asset_data(:, 12:21);
    rm = GetIndexReturn(index_data);
    index_rets = ReturnMean(index_equity_data);
    nonindex_rets = ReturnMean(nonindex_equity_data);
    beta_index = (index_rets - rf) ./ (rm - rf);
    beta_nonindex = (nonindex_rets - rf) ./ (rm - rf);
end

function [ind_ret] = GetIndexReturn(prices)
    n = length(prices);
    rets = (prices(1:n-1) - prices(2:n)) ./ prices(2:n);
    ind_ret = mean(rets) * 12;
end

function [ind_rets] = ReturnMean(prices)
    p_size = size(prices);
    n = p_size(2);
    m = p_size(1);
    ind_rets = zeros(1, n);
    for i = 1:n
        v1 = prices(:, i);
        rets = (v1(1:m-1) - v1(2:m)) ./ v1(2:m);
        ind_rets(i) = mean(rets) * 12;
    end
end