function D = L1Dist(X1, X2)
    n = size(X1,1);
    d = size(X1,2);
    m = size(X2,1);
    D = zeros(n, m);
    
    for i=1:d
        D = D + abs(X1(:,i)*ones(1,m) - ones(n,1)*X2(:,i)');
    end
end