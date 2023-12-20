close all; clear

% Lets construct some fake EEG data, which really is (filtered) random
% noise

% It is put in the matrix "eeg" of size 
h = 0.01;
nrchannels = 8;
nchunk = 500; % (5 sec data)
nrdata = 200; % 

Ntot = nchunk*nrdata;  % total number of time points

timevec = h*(1:Ntot);

a1 = -0.99;
b1 = sqrt(1-a1^2);
X0 = randn(1,nrchannels);
u = randn(Ntot,nrchannels);
eeg = filter([0 b1],[1 a1],u,X0);



%%
% Now let assume each (1 sec) block of (nchunk) data points corresponds to either "class 0" or
% "class 1" and generate some random class output (that we will call y) to predict.
% Such a prediction should really be impossible, since the input "eeg" is purely random noise,
% independent of the random "output" y

nrclasses = 2;
labelvector = floor(nrclasses*rand(nrdata,1));
ytot = kron(labelvector,ones(nchunk,1));    % True label. Vector of size Ntot


%% View regressors and targets
figure(1)
subplot(211)
plot(timevec,eeg)
subplot(212)
plot(timevec,ytot)
ylim([-0.2,1.2])
drawnow

%%
% Now use a small time-chunk of data to train a knn-classifier
% Split data into train and test sets, just as one should
% The estimated resulting performance is very good. But is not for real. 
% What is wrong in our data handling procedure


tcvec = 1:100;
accuracy = zeros(1,length(tcvec));

for tc = tcvec; % Nr of time points to use in classification. Total time is T = h*nrt

    N = floor(Ntot/tc);   % Number of created data (train+test)
    P = nrchannels * tc;    % Length of each feature vector
    
    X = (reshape(eeg(1:N*tc,:)', P, N))'; % Put fake EEG-signal into the feature matrix of size N * P
    y = ytot(1:tc:end); % True labels. Vector of size N
    
    
    % Split into train and test sets
    cv = cvpartition(N,'HoldOut',0.5);
    idx = cv.test;
    Xtrain = X(~idx,:);
    ytrain = y(~idx);
    Xtest = X(idx,:);
    ytest = y(idx);


%%
% Fit a k-nearest neighbor classifier

    k = 1;
    
    Mdl = fitcknn(Xtrain,ytrain,'NumNeighbors',k);
    
    yhat = predict(Mdl,Xtest);

    acc = 1-mean(abs(yhat-ytest))
    accuracy(tc) = acc;
end
%%
%

figure(2)
plot(tcvec*h,accuracy,'-x')
xlabel('time length [seconds]')
ylabel('accuracy')
hold on
grid on




%%
% Analysing the covariance function of the EEG signal
% Read the documenation of the xcov function in matlab

figure(3)
eeg1 = eeg(:,1);
[cov_xx,lags] = xcov(eeg1,1000,'normalized');
stem(lags*h,cov_xx)
xlabel('tau [sec]')
ylabel('Correlation between x(t) and x(t+tau)');
grid on
fixfig

%max(cov_xx)
%sum((eeg1-mean(eeg1)).^2)

fixfig

