data=load('breast-cancer-wisconsin.data');
T1=data(1:size(data,1)/2,:);
T2=data((size(data,1)/2)+1:size(data,1),:);

a=T1(:,1:size(T1,2)-1);
b=T1(:,size(T1,2));
c=T2(:,1:size(T2,2)-1);
d=T2(:,size(T2,2));



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

m1ind = find(b==2);
m2ind = find(b==4);
M1 = mean(kernel_n(m1ind,:));
M2 = mean(kernel_n(m2ind,:));
N = kernel_n(m1ind,:)'*(eye(size(m1ind,1))-(1/size(m1ind,1)))*kernel_n(m1ind,:) + kernel_n(m2ind,:)'*(eye(size(m2ind,1))-(1/size(m2ind,1)))*kernel_n(m2ind,:);
N1 = N + 10000*eye(size(kernel_n,1));
N = N + 10000*eye(size(kernel_n,1));
train = kernel_n*inv(N)*(M1-M2)';
test = kernel_t*inv(N)*(M1-M2)';
train1 = kernel_n*inv(N1)*(M1-M2)';
test1 = kernel_t*inv(N1)*(M1-M2)';
trainmodel = svmtrain(train,b);
accuracy = size(find(svmclassify(trainmodel, test)==d),1)/size(c,1)*100;
trainmodel = svmtrain(train1,b,'kernel_function','rbf');
accuracy1 = size(find(svmclassify(trainmodel, test1)==d),1)/size(c,1)*100;
accuracy
accuracy1