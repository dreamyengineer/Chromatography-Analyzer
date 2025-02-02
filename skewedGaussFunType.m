function modelfun = skewedGaussFunType(n)
    % Initialize the output string
    modelfun = @(params, x) model(params, x, n);
    
    function y = model(params, x, n)

        y = zeros(size(x));

        for i = 1:n
            a = params(4*(i-1) + 1);
            b = params(4*(i-1) + 2);
            c = params(4*(i-1) + 3);
            d = params(4*(i-1) + 4);

            term = a/(c*sqrt(2*pi)) * exp(-((x-b).^2)/(2*c^2)) .* (1 + erf(d*(x-b)/(c*sqrt(2))));

            y = y + term;
        end
    end
end