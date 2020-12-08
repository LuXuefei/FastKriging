function model = computeModel(Xt, Yt, Xny, kernel, lambda, kerpar, computeVariance)
    if ~exist('computeVariance', 'var')
        computeVariance = 1;
    end
    
    R = chol(KernelFunc(kernel, kerpar, Xny, Xny)+ 1e-12*size(Xt,1)*eye(size(Xny,1)));
    
    A = KernelFunc(kernel, kerpar, Xt, Xny)/R;
    
    
    n = size(Xt,1);
    R0 = (A'*A + lambda*n*eye(size(R,1)));
    alpha = R\(R0\(A'*Yt));
    
    model = struct(); model.Xny = Xny; model.kernel = kernel;
    model.lambda = lambda; model.kerpar = kerpar; model.alpha = alpha;
    
    if computeVariance
        z = A'*Yt; z1 = A\Yt;
        model.sigmaSq = min((Yt'*Yt - z'*(R0\z))/(lambda*n), z1'*z1)/n;
        model.R = R\(R0\A')*(A/R');%
        
        model.sigmaSqE = n*model.lambda*model.sigmaSq;
    end
end