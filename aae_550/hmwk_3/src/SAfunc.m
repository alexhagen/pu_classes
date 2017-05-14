function f = SAfunc(x)
    hmwk3_header;
    f = 0.0;
    for i = 1:d
        f = f + (-x(i) * sin(sqrt(abs(x(i)))));
    end
    f = f + a * d;

