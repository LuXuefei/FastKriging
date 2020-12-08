function model = FastKringing(Xtr, Ytr, kernel, ntr, M, lossfunc, func_eval)
    
    if ~exist('lossfunc', 'var')
        lossfunc = 'mse';
    end
    
    if ~exist('func_eval', 'var');
        func_eval = 40;
    end
    
    if ~exist('M', 'var')
        M = min(ntr, 20*sqrt(ntr));
    end

    ntot = size(Xtr,1);
    nval = ceil(max(min(ntot - ntr, 2000), ntr*0.3));
    [Xt, Yt, Xv, Yv, Xny] = split(Xtr, Ytr, ntr, nval, M);

    p0 = [log(1/size(Xt,1)); KernelFunc(kernel, [], Xt, [], 1)];
    
    
    func = @(p) computeError(evaluateModel(computeModel(Xt, Yt, Xny, kernel, exp(p(1)), p(2:end), 0), Xv),Yv, lossfunc); 
    
    opts = optimset('Display', 'iter-detailed', 'MaxFunEvals', func_eval);
    p = fminunc(func, p0, opts);
    
    nval = 0;
    [Xt, Yt, ~, ~, ~] = split(Xtr, Ytr, ntr, nval, M);
    model = computeModel(Xt, Yt, Xny, kernel, exp(p(1)),p(2:end));
end

function [Xt, Yt, Xv, Yv, Xny] = split(Xtr, Ytr, ntr, nval, M)
    ntot = size(Xtr,1);
    ind = randperm(ntot, min(ntr+nval, ntot));
    Xv = Xtr(ind(1:nval),:);
    Yv = Ytr(ind(1:nval),:);
    Xt = Xtr(ind((nval+1):end),:);
    Yt = Ytr(ind((nval+1):end),:);
    Xny = Xt(randperm(size(Xt,1),min(M,size(Xt,1))),:);
end