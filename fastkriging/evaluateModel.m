function [Ypred, Yvariance] = evaluateModel(model, Xval)
    Kv = KernelFunc(model.kernel, model.kerpar, Xval, model.Xny);
    Ypred = Kv*model.alpha;
    
    if nargout == 2
        Yvariance = (1-sum((Kv*model.R).*Kv,2))*diag(model.sigmaSq)';
    end
end