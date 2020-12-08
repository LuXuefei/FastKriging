function K = SquareDistance(X1,X2)
    sqx = sum(X1.*X1, 2);
    sqy = sum(X2.*X2, 2);
    K = sqx*ones(1, size(sqy,1)) + ones(size(sqx,1), 1)*sqy' - 2 * X1*X2';
end