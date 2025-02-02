function result = genBeta0(pks,mean_val)
    % Number of elements in mean_val
    n = length(mean_val);

    % Preallocate the result array
    result = zeros(1, n * 4)';

    % Initialize positions for inserting mean_val
    idx = 2:4:length(result) - 2;

    % Insert mean_val values into the result
    result(idx-1) = pks;
    
    result(idx) = mean_val;

    result(idx+1) = 1;

    result(idx+2) = 1;

    % Fill the remaining elements with 1s
    %result(result == 0) = 1;
end