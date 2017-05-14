x_0 = [0; 0];
options = optimset('LargeScale', 'off', 'GradObj', 'off', ...
                   'Display', 'iter');
[x,fval,exitflag,output,grad,hessian] = fminunc(@(x) Pi(x), x_0, options)