function yFits = generateFits(coefs, x)
    % Number of complete sets of coefficients in the input vector
    numFits = floor(length(coefs) / 4);

    % Initialize the cell array to store each fit function
    yFits = cell(1, numFits);

    % Loop through each set of coefficients
    for i = 1:numFits
        % Extract the coefficients for the i-th fit
        a1 = coefs((i-1)*4 + 1);
        b1 = coefs((i-1)*4 + 2);
        c1 = coefs((i-1)*4 + 3);
        d1 = coefs((i-1)*4 + 4);
        
        % Compute the i-th fit using the extracted coefficients
        yFits{i} = a1 / (c1 * sqrt(2 * pi)) * exp(-((x - b1).^2) / (2 * c1^2)) .* ...
                   (1 + erf(d1 * (x - b1) / (c1 * sqrt(2))));
    end
end