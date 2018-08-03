function bstop = showJ_history(x, optv, state)
    plot(optv.iteration, optv.fval, 'x')
    % setting bstop to true stops optimization
    bstop = false;
end
