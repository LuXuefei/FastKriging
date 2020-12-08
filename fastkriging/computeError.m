function err = computeError(Ypred, Ytrue, lossfunc)
    if strcmp(lossfunc,'mse')
        err = mean(mean((Ypred-Ytrue).^2));
    elseif strcmp(lossfunc,'perc_mse')
        err = mean(mean((Ypred./Ytrue-1).^2));
    end
end