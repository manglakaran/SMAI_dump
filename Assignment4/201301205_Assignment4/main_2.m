a = importdata('arcene_train.data');
b = importdata('arcene_train.labels');
c = importdata('arcene_valid.data');
d = importdata('arcene_valid.labels');
sigma = 10000;
[x1 y1] = size(a);
[x2 y2] = size(c);
kernel = zeros(x1,x1);
for i=1:x1
    for j=1:x1
        kernel(i,j) = exp(-norm(a(i,:)-a(j,:))^2/sigma^2);
    end
end

temp = ones(x1,x1)/x1;
kernel_n = kernel - temp*kernel - kernel*temp + temp*kernel*temp;

kernel_t = zeros(x2,x1);
for i=1:x2
    for j=1:x1
        kernel_t(i,j) = exp(-norm(c(i,:)-a(j,:))^2/sigma^2);
    end
end

m1ind = find(b==1);
m2ind = find(b==-1);
M1 = mean(kernel_n(m1ind,:));
M2 = mean(kernel_n(m2ind,:));
N = kernel_n(m1ind,:)'*(eye(size(m1ind,1))-(1/size(m1ind,1)))*kernel_n(m1ind,:) + kernel_n(m2ind,:)'*(eye(size(m2ind,1))-(1/size(m2ind,1)))*kernel_n(m2ind,:);
N1 = N + 644*eye(size(kernel_n,1));
N = N + 8000*eye(size(kernel_n,1));
train = kernel_n*inv(N)*(M1-M2)';
test = kernel_t*inv(N)*(M1-M2)';
train1 = kernel_n*inv(N1)*(M1-M2)';
test1 = kernel_t*inv(N1)*(M1-M2)';
trainmodel = svmtrain(train,b);
accuracy = size(find(svmclassify(trainmodel, test)==d),1);
trainmodel = svmtrain(train1,b,'kernel_function','rbf');
accuracy1 = size(find(svmclassify(trainmodel, test1)==d),1);
accuracy
accuracy1