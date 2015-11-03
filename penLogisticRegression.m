function beta = penLogisticRegression(y,tX,alpha,lambda)
    
    beta = logisticRegression(y, tX, alpha);
    reg_term = lambda * sum(beta .^2);
    beta = beta + reg_term;
end