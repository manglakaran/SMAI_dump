function [weightsij,weightsjk,t] = neuralnetworks()
data = readdata();
[data, classes, t] = preprocessdata(data);
%assumed the no of hidden layers to be 8
weightsij = -1 + 2*rand(8,65);
weightsjk = -1 + 2*rand(2,8);
weightsij = weightsij/sqrt(65);
weightsjk = weightsjk/sqrt(8);
l=0;
eeta = 0.0001;
[x,y] = size(data);
while(l<=1000)
    for i=1:x
        netj = weightsij*data(i,:)';
        fnetj = arrayfun(@(x) 1/(1+exp(-x)), netj);
        netk = weightsjk*fnetj;
        fnetk = arrayfun(@(x) 1/(1+exp(-x)), netk);
        dJ = t(:,i) - fnetk;
        %J = arrayfun(@(x) x^2,dJ)
        %J = 
        for m=1:2
            for n=1:8
                weightsjk(m,n) = weightsjk(m,n) + eeta*dJ(m)*(fnetk(m) - (fnetk(m)^2))*netj(n);
            end
        end
        for m=1:8
            for n=1:65
                weightsij(m,n) = weightsij(m,n) + eeta*calc(m,weightsjk,dJ,fnetk)*(fnetj(m) - (fnetj(m)^2))*data(i,n);
%             end
        end
    end
    l=l+1
end
for i=1:x
    netj = weightsij*data(i,:)';
    fnetj = arrayfun(@(x) 1/(1+exp(-x)), netj);
    netk = weightsjk*fnetj;
    fnetk = arrayfun(@(x) 1/(1+exp(-x)), netk);
    dJ = t(:,i) - fnetk
end
end

function [valu] = calc(m,weightsjk,dJ,fnetk)
valu = 0;
for i=1:2
    valu = valu + weightsjk(i,m)*dJ(i)*(fnetk(i) - (fnetk(i)^2));
end
end

function [data] = readdata()
fileID = fopen('optdigits.tra');
data = textscan(fileID,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
dataset = [];
for i = 1:65
    dataset = horzcat(dataset,data{i});
end
[x,y] = size(dataset);
data = [];
for i = 1:x
    numbervect = dataset(i,:);
    if numbervect(65) == 0 || numbervect(65) == 7
        data = vertcat(data,dataset(i,:));
    end
end
end

function [data, classes, t] = preprocessdata(data)
[x,y] = size(data)
classes = data(:,65);
if classes(1) == 0
    t = [0;1]
else
    t = [1;0]
end
for i=2:x
    if classes(i) == 0
        t = horzcat(t, [0;1]);
    else
        t = horzcat(t, [1;0]);
    end
end
data = data(:,1:64);
data = horzcat(ones(x,1), data);
end
