function g = constraintsfunc(x)
    convert_bits;
    A = [w_1 * h_1, w_2 * h_2, w_3 * h_3];
    E = [E_1 E_2 E_3];
    sigma = stressHW3(A, E);
    sigma_1 = sigma(1);
    sigma_2 = sigma(2);
    sigma_3 = sigma(3);
    g = [ abs(sigma_1)/sigma_y1 - 1, ...
          abs(sigma_2)/sigma_y2 - 1, ...
          abs(sigma_3)/sigma_y3 - 1];
end