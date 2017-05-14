x_0 = [0; 0];
options = optimset('LargeScale', 'on', 'GradObj', 'on', ...
                   'Hessian', 'on');
[x,fval,exitflag,output,grad,hessian] = fminunc(@(x) Pi(x), x_0, options)