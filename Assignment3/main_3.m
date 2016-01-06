%Assignment 3 SMAI 
clear all;
clc;
%Reading the training data
traindata = importdata('arcene_train.data');
trainlabels = importdata('arcene_train.labels');

%Reading the validation data
Validdata = importdata('arcene_valid.data');
Validlabels = importdata('arcene_valid.labels');
traindata = [traindata;Validdata];

%Calculating PCA
mew = mean(traindata);          % Mean of the data
temp = traindata-repmat(mew,size(traindata,1),1);   % X-M
S = temp'*temp;         %Scatter Matrix = Sigma (xk-m)*(xk-m)'
S = S/size(traindata,1);        

%[V D]=eig(S);          %Eigen Vector V & Eigen Value D of Scatter Matrix
V = load('eien_values.mat');
d = load('eigen_vectors.mat');

dl = flipud(D);
vl = fliplr(V);
k=10;
vl1 = vl(:,1:k);
new_mat = traindata*vl1;
train_d = new_mat(1:100,:);
testing_d = new_mat(101:200,:);

%check labels
class1 = [];
class2 = [];
for i=1:100
    if trainlabels(i) == -1
        class1 = [class1;train_d(i,:)];
    else
        class2 = [class2;train_d(i,:)];
    end
end
mu1 = mean(class1);
cov1 = cov(class1);
pw1 = size(class1,1)/size(train_d,1);
mu2 = mean(class2);
cov2 = cov(class2);
pw2 = size(class2,1)/size(train_d,1);
count = 0;
for i=1:100
    p1 = -0.5*log(det(cov1)) - 0.5*((testing_d(i,:)-mu1) * inv(cov1) * (testing_d(i,:)-mu1)') + log(pw1);
    p2 = -0.5*log(det(cov2)) - 0.5*((testing_d(i,:)-mu2) * inv(cov2) * (testing_d(i,:)-mu2)') + log(pw2);
    if p1 > p2
        if Validlabels(i) ~= -1
            count = count + 1;
        end
    end
    if p2 > p1
        if Validlabels(i) ~= 1
            count = count + 1;
        end
    end
end
count


%Computing LDA

vl2 = mu1-mu2;
new_mat1 = new_mat*vl2';
train_d = new_mat1(1:100,:);
testing_d = new_mat1(101:200,:);
class1 = [];
class2 = [];
count = 0;
for i=1:100
    if b(i) == -1
        class1 = [class1;train_d(i,:)];
    else
        class2 = [class2;train_d(i,:)];
    end
end
mu1 = mean(class1);
cov1 = std(class1);
pw1 = size(class1,1)/size(train_d,1);
mu2 = mean(class2);
cov2 = std(class2);
pw2 = size(class2,1)/size(train_d,1);
for i=1:100
    p1 = -1*log(cov1) - 0.5*(((testing_d(i)-mu1)/cov1)^2) + log(pw1);
    p2 = -1*log(cov2) - 0.5*(((testing_d(i)-mu2)/cov2)^2) + log(pw2);
    if p1 > p2
        if d(i) ~= -1
            count = count + 1;
        end
    end
    if p2 > p1
        if d(i) ~= 1
            count = count + 1;
        end
    end
end
count
