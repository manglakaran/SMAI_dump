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
cluster_arr=1:size(data,1);
while(1)
    cluster=unique(cluster_arr);
%     clust
    if(size(cluster,2)==3)
        break;
    end
    min_dist=Inf;
    for i=1:size(cluster,2)-1
        for j=i+1:size(cluster,2)
            C1=data(find(cluster_arr==cluster(i)),1:2);
            C2=data(find(cluster_arr==cluster(j)),1:2);
            %calc dist 
            
%             dist_mat=pdist2(C1,C2);
%             D=min(dist_mat(:));
            D=pdist2([mean(C1(:,1)) mean(C1(:,2))],[mean(C2(:,1)) mean(C2(:,2))]);
            if(D<min_dist)
                ai=i;
                aj=j;
                min_dist=D;
            end
        end
    end
     disp(ai);
     disp('asd');
     disp(aj);
     disp(size(cluster,2));
    cluster_arr(find(cluster_arr==cluster(aj)))=cluster(ai);
end
y1=find(class_labels==1);
y2=find(class_labels==2);
y3=find(class_labels==3);
x1=find(cluster_arr==cluster(1));
x2=find(cluster_arr==cluster(2));
x3=find(cluster_arr==cluster(3));
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

                