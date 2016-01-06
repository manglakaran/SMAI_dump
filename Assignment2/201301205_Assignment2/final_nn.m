function [] = final_nn() 

[training , output] = readdata();
[x y] = size(training);
training = training(:, 1:y-1);
training = [ones(x, 1) training];

features = 65;
hidden_units = 73;
output_units = 2;
eta = 1;
theta = 0.001;

wij = rand(features, hidden_units)*2/(sqrt(features)) - 1/(sqrt(features));
wjk = rand(hidden_units, output_units)*2/(sqrt(hidden_units)) - 1/(sqrt(hidden_units));

%wij = -1 + 2*rand(features,hidden_units);
%wjk = -1 + 2*rand(hidden_units, output_units);

%disp(wjk)

elem_n = 1;

count = 0;
while elem_n <= x
    data = training(elem_n, :);
    
    netj = data*wij;
    y = (sigmf(netj,[1 0]));
    netk = y*wjk;
    
    z = (sigmf(netk,[1 0]));
    %disp(z)
    
    dK = (output(elem_n, :)-z).*(1 - sigmf(netk,[1 0])).*(sigmf(netk,[1 0]));
    
    dJ = dK*wjk'.*(sigmf(netj,[1 0]).*(1 - sigmf(netj,[1 0])));
    %disp(dJ)
    repeat1 = repmat(dK, hidden_units, 1);
    repeat2 = repmat(data', 1, hidden_units);
    %disp(repeat1)
    wjk = wjk + eta*repeat1.*[y; y]';
    wij = wij + eta*repeat2.*repmat(dJ, features, 1);
    
    if norm(output(elem_n, :)-z) < theta
        break
    end
    count = count+1;
    elem_n = elem_n+1;
end

[test ,class] = testdata();
count = 0;
correct = 0;
for cnt=1:size(test, 1)
    count = count+1;
    data = test(cnt, :);
    
    netj = data*wij;
    y = (sigmf(netj,[1 0]));
    netk = y*wjk;
    z = round(sigmf(netk,[1 0]));
    
    if z(1) == 1 && class(cnt) == 0
        correct = correct + 1;
    elseif z(1) == 0 && class(cnt) == 7
        correct = correct + 1;
    end
end

accuracy = 100*correct/count;
accuracy

end

function[test ,class] = testdata()
test = csvread('test.txt');
[x y] = size(test);
class = test(:, y);
test = test(:, 1:y-1);
test = [ones(x, 1) test];
end

function[training , output] = readdata()
training = csvread('train.txt');
[x y] = size(training);
class = training(:, y);
output = zeros(x, 2);
rep_7 = [0 1];
rep_0 = [1 0];
for i=1:x
    if class(i) == 7
        output(i, :) = rep_7;
    else
        output(i, :) = rep_0;
    end
end
end