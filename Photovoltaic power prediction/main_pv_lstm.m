clear 
close all
clc
rng(9); 
P_train = xlsread('Data.xlsx','rain','A2:H476')';
T_train = xlsread('Data.xlsx','rain','I2:I476')';
P_test = xlsread('Data.xlsx','rain','A477:H525')';
T_test = xlsread('Data.xlsx','rain','I477:I525')';
SearchAgents =8; 
Function_name='LSTM_MIN'; 
Max_iterations =20; 
lowerbound = [50 0.001 50 ];
upperbound = [100 0.01 100 ];
dimension = 3;
fitness = @(x)LSTM_MIN(x,P_train,P_test,T_train,T_test);
[Best_score,Best_pos,Convergence_curve]=GE_SA_ISCSO(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,fitness);
Tuna1(1,1)=floor(Best_pos(1,1));
Tuna1(1,3)=floor(Best_pos(1,3));
numHiddenUnits=round(Tuna1(1,1));
MaxEpochs=abs(Tuna1(1,3));
InitialLearnRate=abs(Best_pos(1,2));
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
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(Tuna1(1,1))
    fullyConnectedLayer(numResponses)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',Tuna1(1,3), ...
    'MiniBatchSize',16, ...
    'InitialLearnRate',Best_pos(1,2), ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);
numTimeStepsTrain = size(XTrain,2);
for i = 1:numTimeStepsTrain
    [net,XPred(:,i)] = predictAndUpdateState(net,XTrain(:,i),'ExecutionEnvironment','cpu');
end
numTimeStepsTest = size(XTest,2);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end
predict_value1=method('reverse',XPred,output_ps);
T_sim1 =double(predict_value1);
predict_value2=method('reverse',YPred,output_ps);
T_sim2 =double(predict_value2);
M = size(P_train, 2);
N = size(P_test, 2);
T_test = T_test(:);
T_sim2 = T_sim2(:);
N = length(T_test);
MAE2 = mean(abs(T_test - T_sim2));
mse2 = mean((T_test - T_sim2).^2);
rmse2 = sqrt(mse2);
MAPE2 = mean(abs((T_test - T_sim2) ./ (T_test + eps))) * 100; 
mean_actual = mean(T_test);
RRMSE = (rmse2 / mean_actual) * 100; 
numerator = sum((T_test - T_sim2).^2);         
denominator = sum((T_test - mean(T_test)).^2); 
NSE = 1 - (numerator / denominator);
disp('Evaluation Results (Test Set):')
disp(['Mean Absolute Error (MAE):               ', num2str(MAE2)])
disp(['Mean Squared Error (MSE):                ', num2str(mse2)])
disp(['Root Mean Squared Error (RMSE):          ', num2str(rmse2)])
disp(['Nash-Sutcliffe Efficiency (NSE):         ', num2str(NSE)])
disp(['Mean Absolute Percentage Error (MAPE):     ', num2str(MAPE2), '%'])
disp(['Relative Root Mean Squared Error (RRMSE):  ', num2str(RRMSE), '%'])
disp(['Optimal Hidden Units (numHiddenUnits):           ', num2str(numHiddenUnits)])
disp(['Optimal Initial Learn Rate (InitialLearnRate):   ', num2str(InitialLearnRate)])
disp(['Optimal Max Epochs (MaxEpochs):                  ', num2str(MaxEpochs)])
save('GE-SA ISCSO-LSTM.mat', 'Convergence_curve', 'T_sim2', 'T_test');