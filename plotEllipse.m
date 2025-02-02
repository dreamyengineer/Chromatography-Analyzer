function plotEllipse(xCenter, yCenter, a, b, color)
    % Create theta values for the ellipse
    theta = linspace(0, 2*pi, 100);
    
    % Parametric equations for the ellipse
    x = a * cos(theta);
    y = b * sin(theta);
    
    % Rotate ellipse and translate to the correct center
    xEllipse = xCenter + x;
    yEllipse = yCenter + y;
    
    % Plot the ellipse
    plot(xEllipse, yEllipse, color, 'LineWidth', 1,'Color','r');
end