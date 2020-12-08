function K = KernelFunc(kernel, kerpar, X1, X2, initializeParameters)
    
    if ~exist('initializeParameters', 'var')
        initializeParameters = 0;
    end
    
    if initializeParameters
        if strcmp(kernel, 'exponential') || strcmp(kernel, 'abel') || strcmp(kernel, 'gaussian')
            n = min(size(X1,1), 100);
            K = log(mean(sqrt(sum(X1(randperm(size(X1,1),n),:).^2,2))));
        elseif strcmp(kernel, 'multi-exponential') || strcmp(kernel, 'multi-abel') || strcmp(kernel, 'multi-gaussian')
            n = min(size(X1,1), 100);
            K = log(mean(sqrt(sum(X1(randperm(size(X1,1),n),:).^2,2))))*ones(size(X1,2),1);
        elseif strcmp(kernel, 'custom')
            n = min(size(X1,1), 100);
            log_sigma = log(mean(sqrt(sum(X1(randperm(size(X1,1),n),:).^2,2))));
            K = [log_sigma; log(0.5); log_sigma]; 
        end
        
    else
    
        if strcmp(kernel, 'abel');
            K = exp((-1.0/exp(kerpar))*sqrt(abs(SquareDistance(X1,X2))));
        elseif strcmp(kernel, 'multi-abel')
            S = diag(sparse(exp(-kerpar)));
            K =exp(-sqrt(abs(SquareDistance(X1*S,X2*S))));
        elseif strcmp(kernel, 'gaussian')
            K = exp((-0.5/exp(kerpar)^2)*SquareDistance(X1,X2));
        elseif strcmp(kernel, 'multi-gaussian')
            S = diag(sparse(exp(-kerpar)));
            K = exp(-0.5*SquareDistance(X1*S,X2*S));
        elseif strcmp(kernel, 'exponential')
            K = exp((-1/exp(kerpar))*L1Dist(X1,X2));
        elseif strcmp(kernel, 'multi-exponential')
            S = diag(sparse(exp(-kerpar)));
            K = exp(-1*L1Dist(X1*S,X2*S));
        elseif strcmp(kernel, 'custom')
            kerpar = exp(kerpar);
            K = exp((-1.0/kerpar(1))*sqrt(abs(SquareDistance(X1,X2)))) + (kerpar(2) + X1*X2'/kerpar(3)^2).^2;
        end
    
    end
end