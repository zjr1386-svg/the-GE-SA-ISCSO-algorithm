function cost = LSTM_MIN(x,P_train,P_test,T_train,T_test)
numHiddenUnits = round(x(1));  
options.InitialLearnRate= abs(x(2));
options.MaxEpochs = round(x(3)); 
train_x=P_train;
train_y=T_train;
test_x=P_test;
test_y=T_test;
method=@mapminmax;
[train_x,train_ps]=method(train_x);
test_x=method('apply',test_x,train_ps);
[train_y,output_ps]=method(train_y);
test_y=method('apply',test_y,output_ps);
XTrain = double(train_x) ;
XTest  = double(test_x) ;
YTrain = double(train_y);
YTest  = double(test_y);
numFeatures = size(XTrain,1); 
numResponses =  size(YTrain,1);
numHiddenUnits =abs(round(x(1)));
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',round(x(3)), ...
    'MiniBatchSize',16, ... 
    'InitialLearnRate',abs(x(2)), ...
    'GradientThreshold',1, ...
    'Verbose',0);
net = trainNetwork(XTrain,YTrain,layers,options);
numTimeStepsTest = size(XTest,2);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end
predict_value=method('reverse',YPred,output_ps);
predict_value=double(predict_value);
true_value=method('reverse',YTest,output_ps);
true_value=double(true_value);
rmse=sqrt(mean((true_value(1,:)-predict_value(1,:)).^2));
cost = rmse ;
end



