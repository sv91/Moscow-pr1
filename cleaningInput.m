clear all;

load('Moscow_regression')

x = X_train;
[~,N] = size(x);
for i = 1:N
    meanX = mean(x(:,i));
    x(:,i) = x(:,i) - meanX;
    stdX = std(x(:,i));
    x(:,i) = x(:,i)./stdX;
end