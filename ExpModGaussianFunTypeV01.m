function modelfun = ExpModGaussianFunTypeV01(n)
    % Initialize the output string
    modelfun = @(params, x) model(params, x, n);
    
    function y = model(params, x, n)

        y = zeros(size(x));

        for i = 1:n
            a = params(4*(i-1) + 1);
            b = params(4*(i-1) + 2);
            c = params(4*(i-1) + 3);
            d = params(4*(i-1) + 4);

            term = ((a*c)/d)*sqrt(pi/2)*exp(0.5*(c/d)^2 -(x-b)/d)*erfc((1/sqrt(2))*(c/d -(x-b)/c));
            y = y + term;
        end
    end
end