close all;
clc
clear
data = load('seeds_dataset.txt');
numf = size(data,2);
class_labels = data(:,numf);  % Last column is 'class labels'. 'data' is nxd matrix now
data = data(:, 1:numf-1);

% Perform PCA to reduce to 2d data (for visualisation purposes)
coeff = princomp(data); % coeff is dxd matrix
eig_vec = coeff(:,1:2);
data = data*eig_vec;
means=rand(3,2);
new_mean=zeros(3,2);
m=2;
a=zeros(size(data,1),3);
while(1)
    new_mean=zeros(3,2);
    for i=1:3
        mean=means(i,:);
        for j=1:size(data,1)
            din=((norm(data(j,:)-mean))/(norm(data(j,:)-means(1,:))))^(2/(m-1))+((norm(data(j,:)-mean))/(norm(data(j,:)-means(2,:))))^(2/(m-1))+((norm(data(j,:)-mean))/(norm(data(j,:)-means(3,:))))^(2/(m-1));
            a(j,i)=(1/din);
            new_mean(i,:)=new_mean(i,:)+a(j,i)*data(j,:);
        end
    end
    summ=sum(a);
    for i=1:3
        new_mean(i,:)=new_mean(i,:)/summ(i);
    end
    if norm(means-new_mean)<=0.000001
        break;
    end
    means=new_mean;
end
class_labels1 = zeros(size(data,1));
for i=1:size(data,1)
    [M,I] = max(a(i,:));
    class_labels1(i) = I;
end
y1=find(class_labels==1);
y2=find(class_labels==2);
y3=find(class_labels==3);
x1=find(class_labels1==1);
x2=find(class_labels1==2);
x3=find(class_labels1==3);
figure,
subplot(1,2,1);
plot(data(y1,1),data(y1,2),'.r','MarkerSize',20);
hold on
plot(data(y2,1),data(y2,2),'.g','MarkerSize',20);
hold on
plot(data(y3,1),data(y3,2),'.b','MarkerSize',20);
subplot(1,2,2);
plot(data(x1,1),data(x1,2),'.r','MarkerSize',20);
hold on
plot(data(x2,1),data(x2,2),'.g','MarkerSize',20);
hold on
plot(data(x3,1),data(x3,2),'.b','MarkerSize',20);
