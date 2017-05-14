function [E, rho, sigma_y] = material(x)
    switch x
        case 1
            E=68.9e9;
            rho = 2700;
            sigma_y = 55.2e6;
        case 2
            E = 116e9;
            rho = 4500;
            sigma_y = 140e6;
        case 3
            E = 205e9;
            rho=7872;
            sigma_y = 285e6;
        case 4
            E = 207e9;
            rho = 8800;
            sigma_y = 59.0e6;
        otherwise
            error('We dont have that material information');
    end
end