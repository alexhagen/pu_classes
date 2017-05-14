function phi = pseudoobjfunc(x)

    hmwk3_prob4_header;
    convert_bits;
    
    f = massfunc(x);
    
    g = constraintsfunc(x);
    
    P = 0.0;
    for i = 1:length(g)
        P = P + rp(i) * max(0, g(i));
    end
    
    phi = f + P;
end