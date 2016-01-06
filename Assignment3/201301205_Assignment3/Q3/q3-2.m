%load eig.mat;
%Reading the training data
traindata = dlmread('arcene_train.data');
trainlabels = dlmread('arcene_train.labels');

%Reading the validation data
validdata = dlmread('arcene_valid.data');
validlabels = dlmread('arcene_valid.labels.txt');

train_data_normalized = zeros(size(traindata));
test_data_normalized = zeros(size(validdata));

k = 50; % 10,99 works perfectly
    
%Calculating PCA 
m = mean(traindata,2);                      % Mean of the data
newtrain = traindata - repmat(m,1,10000);   % X-M
%S = newtrain'*newtrain;                     %Scatter Matrix = Sigma (xk-m)*(xk-m)'
S = 99*cov(newtrain);
[V, D] = eig(S);                            %Eigen Vector V & Eigen Value D of Scatter Matrix

x = diag(D);
[~,ind] = sort(x,'descend');    %[val, loc] = max(max(D));
                                %ei = V(:,loc-999:loc);
ind = ind(1:k);                 %Selecting the eigen vectors that have the max eigenvalues
effecter = zeros(size(D,1),k);

for i=1:k
    effecter(:,i) = V(:,ind(i));
end

ei = effecter;

m = mean(validdata,2);                      % Mean of the data
newtest = validdata - repmat(m,1,10000);   % X-M

%Final Equation PCA
result_PCA = newtrain*ei;
test_PCA = newtest*ei;                                           
%result_PCA = result_PCA';
%test_PCA = test_PCA';

%Calculate Accuracy of PCA
accuracy = gaussian_naive_bayes( result_PCA, trainlabels, test_PCA, validlabels );
disp('PCA Accuracy');
disp(accuracy)

%Calculating FDA
class_1 = find(trainlabels == 1);
class_2 = find(trainlabels == -1);

m1 = mean(result_PCA(class_1,:),1);
m2 = mean(result_PCA(class_2,:),1);

new = result_PCA(class_1,:)-repmat(m1,size(class_1,1),1);  %X-M1
S1 = new'*new;  %S1 Matrix

new = result_PCA(class_2,:)-repmat(m2,size(class_2,1),1); %X-M2
S2 = new'*new;  %S2 Matrix

SW = S1 + S2;   %Within class scatter
%SW = SW/size(SW,1);
w = (SW)\(m1-m2)';  %Line to project on

Y1 = w'*result_PCA(class_1,:)';    %Final 1D LDF
Y2 = w'*result_PCA(class_2,:)';
Y = [Y1';Y2'];                      %100x1

Z1 = w'*test_PCA(class_1,:)';    %Final 1D LDF
Z2 = w'*test_PCA(class_2,:)';
Z = [Z1';Z2'];

%Accuracy of FDA/LDF
accuracy = gaussian_naive_bayes( Y, trainlabels, Z, validlabels );
disp('LDF Accuracy');
disp(accuracy)
%end