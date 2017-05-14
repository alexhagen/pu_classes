function [f, grad_f] = objective_function(x)
    % First convert the input vector to variables in the problem
    b = x(1);
    h = x(2);
    
    % Then use a script to read in all parameters
    parameters;
    
    % Then we define our objective function
    f = rho * L * b * h;  

    if nargout > 1  % fun called with two output arguments
        % Matlab naming convention will use grad_f(1) as df/dx(1);
        % grad_f(2) as df/dx(2)
        grad_f = ...
            [rho*L*h; ...
             rho*L*b];
    end
end