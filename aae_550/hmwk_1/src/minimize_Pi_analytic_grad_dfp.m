x_0 = [0; 0];
options = optimset('LargeScale', 'off', 'GradObj', 'on', ...
                   'Display', 'iter', 'HessUpdate', 'dfp');
[x,fval,exitflag,output,grad,hessian] = fminunc(@(x) Pi(x), x_0, options)