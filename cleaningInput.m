clear all;

load('Moscow_regression')

x_reg_train = X_train;
y_reg_train = y_train;
x_reg_test = X_test;
[~,D] = size(x_reg_train);
for i = 1:D
    meanX = mean(x_reg_train(:,i));
    x_reg_train(:,i) = x_reg_train(:,i) - meanX;
    stdX = std(x_reg_train(:,i));
    x_reg_train(:,i) = x_reg_train(:,i)./stdX;
    
    %figure(i);
    %plot(x_reg_train(:,i),y_reg_train,'.');
    %hold on
    
    meanX_test = mean(x_reg_test(:,i));
    x_reg_test(:,i) = x_reg_test(:,i) - meanX_test;
    stdX_test = std(x_reg_test(:,i));
    x_reg_test(:,i) = x_reg_test(:,i)./stdX_test;
end
%hold off;
figure(1);
plot(x_reg_train(:,11)+x_reg_train(:,56),y_reg_train,'.');

% plot of X data
%boxplot(X_train)
%%
% plot of X data centered
X_train_centered = X_train;
for i = 1:D
    meanX = mean(X_train_centered(:,i));
    X_train_centered(:,i) = X_train_centered(:,i) - meanX;
end
boxplot(X_train_centered)
hist(y_train)


%hist(X_train)
unique(X_train(:,3)) %4
unique(X_train(:,14)) % 2
unique(X_train(:,20)) % 3
unique(X_train(:,26)) % 2
unique(X_train(:,32)) % 4
unique(X_train(:,34)) % 3
unique(X_train(:,45)) % 4
unique(X_train(:,49)) % 2
unique(X_train(:,64)) % 2
unique(X_train(:,65)) % 2
% regression: 5x2, 2x3, 3x4

%---
load('Moscow_classification')

x_cl_train = X_train;
y_cl_train = y_train;
x_cl_test = X_test;
[~,D] = size(x_cl_train);
for i = 1:D
    meanX = mean(x_cl_train(:,i));
    x_cl_train(:,i) = x_cl_train(:,i) - meanX;
    stdX = std(x_cl_train(:,i));
    x_cl_train(:,i) = x_cl_train(:,i)./stdX;
    
    meanX_test = mean(x_cl_test(:,i));
    x_cl_test(:,i) = x_cl_test(:,i) - meanX_test;
    stdX_test = std(x_cl_test(:,i));
    x_cl_test(:,i) = x_cl_test(:,i)./stdX_test;
end

%hist(X_train)
% unique(X_train(:,3)) %4
% unique(X_train(:,14)) % 2
% unique(X_train(:,20)) % 3
% unique(X_train(:,26)) % 2
% unique(X_train(:,32)) % 4
% unique(X_train(:,34)) % 3
% unique(X_train(:,45)) % 4
% unique(X_train(:,49)) % 2
% unique(X_train(:,64)) % 2
% unique(X_train(:,65)) % 2
% regression: 5x2, 2x3, 3x4