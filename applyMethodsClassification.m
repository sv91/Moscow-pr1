
clear all;

% anonymous functions 
%RMSE = @(yReal, yPred) sqrt(sum((yReal - yPred) .^ 2) / length(yReal));


RMSE = @(yN, p) sqrt(sum((yN - p) .^ 2) / length(yN));

logLoss = @(yN, p) -sum(yN*log(p)+(1-yN)*log(1-p))/length(yN);

%loss = @(yN, yHat) sum(ident(yN, yHat))/length(yN);



% regression dataset
load('Moscow_classification');
[NTr,DTr] = size(X_train);
[NTe,DTe] = size(X_test);

for i = 1:DTr
    meanX = mean(X_train(:,i));
    X_train(:,i) = X_train(:,i) - meanX;
    stdX = std(X_train(:,i));
    X_train(:,i) = X_train(:,i)./stdX;
end

% variables
yRegTr = y_train;
X_train(:,28) = [];
X_train(:,25) = [];
X_train(:,23) = [];
X_train(:,15) = [];
X_train(:,10) = [];
X_train(:,6) = [];
X_train(:,4) = [];
X_train(:,1) = [];
X_test(:,28) = [];
X_test(:,25) = [];
X_test(:,23) = [];
X_test(:,15) = [];
X_test(:,10) = [];
X_test(:,6) = [];
X_test(:,4) = [];
X_test(:,1) = [];
tXRegTr = [ones(NTr, 1) X_train ]; %to be determined
tXRegTe = [ones(NTe, 1) X_test ];

% tests for methods
%alpha = 0:0.005:1
leastSquares(yRegTr, tXRegTr);
leastSquaresGD(yRegTr, tXRegTr, 0.1);
betaTest = ridgeRegression(yRegTr, tXRegTr, 0.001);


onesMat = (tXRegTr * betaTest) > 0;
minOnesMat = ((tXRegTr * betaTest) <= 0) .* -1;
res = onesMat + minOnesMat;
loss(yRegTr, res)


%logisticRegression(yRegTr, tXRegTr, 0.000001)
%penLogisticRegression(y_reg_train, tX_reg_train, 0.000001, 50)

% get alpha_star 
AA = [];
alphas = 0:0.005:2; % 0.1 seems good, 0.1353

for alpha = alphas;
    beta = ridgeRegression(yRegTr, tXRegTr, alpha);
    %beta = leastSquaresGD(yRegTr, tXRegTr, alpha);
    
    onesMat = (tXRegTr * beta) > 0;
    minOnesMat = ((tXRegTr * beta) <= 0) .* -1;
    res = onesMat + minOnesMat;
    

    rm = loss(yRegTr, res);
    AA = [AA ; rm];
end
plot(alphas, AA)
alphaStar = 0.1;

% get beta_star and predictions
% dimensions: beta= Dx1, tX = NxD, tXxbeta=Nx1
betaStar = ridgeRegression(yRegTr, tXRegTr, alphaStar);

onesMat = (tXRegTe * betaStar) > 0;
minOnesMat = ((tXRegTe * betaStar) <= 0) .* -1;
yStar = onesMat + minOnesMat;
lossy = loss(yRegTr, res)

    
%yStar = tXRegTe * betaStar;

% rmse, we to on train and test with real
%RMSE(yRegTr, tXRegTr * betaStar);
csvwrite('predictions_classification.csv', yStar);
csvwrite('test_errors_lassification.csv', ['01loss', '0.1367']);


% ---Kfold testing

% % split data in k-fold
setSeed(1);
K = 5;
idx = randperm(NTr);
NTrk = floor(NTr/K);
for k = 1:K
	idxCV(k,:) = idx(1+(k-1)*NTrk:k*NTrk);
end

% lambda values
lambda = logspace(-10,0,100); %% to be played with
allVarMseTr = [];
allVarMseTe = [];
    
% K-fold cross validation
for i = 1:length(lambda)
    for k = 1:K
        % get k'th subgroup in test, others in train
        XRegTr = tXRegTr(:,2:end);
        idxTe = idxCV(k,:);
        idxTr = idxCV([1:k-1 k+1:end],:);
        idxTr = idxTr(:);
        yTe = yRegTr(idxTe);
        XTe = XRegTr(idxTe,:);
        yTr = yRegTr(idxTr);
        XTr = XRegTr(idxTr,:);

        % form tX (INSERT CODE)
        tXTr = [ones(length(yTr), 1) XTr];
        tXTe = [ones(length(yTe), 1) XTe];

        % least squares (INSERT CODE)
        [beta] = ridgeRegression(yTr, tXTr, lambda(i));
        onesMatTr = (tXTr * beta) > 0;
        minOnesMatTr = ((tXTr * beta) <= 0) .* -1;
        resTr = onesMatTr + minOnesMatTr;

        onesMatTe = (tXTe * beta) > 0;
        minOnesMatTe = ((tXTe * beta) <= 0) .* -1;
        resTe = onesMatTe + minOnesMatTe;

        % training and test MSE(INSERT CODE)
        mseTrSub(k) = loss(yTr, resTr);

        % testing MSE using least squares
        mseTeSub(k) = loss(yTe, resTe);

    end
    mseTr(i) = mean(mseTrSub);
    mseTe(i) = mean(mseTeSub);
    varMseTr(i) = var(mseTrSub);
    varMseTe(i) = var(mseTeSub);
end


allVarMseTr = [allVarMseTr ; varMseTr];
allVarMseTe = [allVarMseTe ; varMseTe];

% plot
figure;
semilogx(lambda(1:5:end), mseTr(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);
hold on;
semilogx(lambda(1:5:end), mseTe(1:5:end), '-o', 'MarkerFaceColor', 'white', 'LineWidth', 2);

grid on;
%ylim([0 0.05]);
%xlim([10^-4 10^2]);
legend('mseTr', 'mseTe');




