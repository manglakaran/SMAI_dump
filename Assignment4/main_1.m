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
kernel_new = kernel - temp*kernel - kernel*temp + temp*kernel*temp;
[eigenvectors1 eigenvalues1] = eig(kernel_new);
eigenvalues1 = diag(eigenvalues1);

%eigenvalues1 = eigenvalues1(end:-1:1);
%eigenvectors1 = fliplr(eigenvectors1);

kernel_t = zeros(x2,x1);
for i=1:x2
    for j=1:x1
        kernel_t(i,j) = exp(-norm(c(i,:)-a(j,:))^2/sigma^2);
    end
end

for i=1:x1
    eigenvectors1(:,i) = eigenvectors1(:,i)/eigenvalues1(i);
end

for t=1:2
    v1 = eigenvectors1(:,1:10^t);
    train1 = kernel_new*v1;
    test1 = kernel_t*v1;
    trainmodel1 = svmtrain(train1,b);
    acc_linear=100*(size(find(svmclassify(trainmodel1,test1)==d),1)/size(train1,1));
    disp(acc_linear);
    trainmodel1 = svmtrain(train1,b,'kernel_function','rbf','rbf_sigma',5);
    acc_rbf=100*(size(find(svmclassify(trainmodel1,test1)==d),1)/size(train1,1));
    disp(acc_rbf);
end