
%Implementing Gaussian Bayes Classifier
function [accuracy] = gaussian_naive_bayes( traindata, train_labels, test, test_labels )
    
    nofeat = size(traindata,2);
    error = 0;
    
    %Declaring mean and var 
    mean_c1 = zeros(1, nofeat);
    mean_c2 = zeros(1, nofeat);
    var_c1 = zeros(1, nofeat);
    var_c2 = zeros(1, nofeat);
    %train_labels(find(train_labels == -1)) = 2;     
        
    %Class 1 indices of train
    trainA = traindata( find(train_labels == 1), : );
    
    %Class 2 indices of train
    trainB = traindata( find(train_labels == -1), : );
    
    %Class 1 & 2 indices of test
    %test_c1 = test( find(test_labels == 1), : );
    %test_c2 = test( find(test_labels == 2), : );
    
    num_test = size(test,1);
        
    %Calc mean & Variance of each feature of each class
    for i = 1:nofeat
        X = trainA(:,i);
        mean_c1(i) = mean(X);
        var_c1(i) = var(X);
        
        X = trainB(:,i);
        mean_c2(i) = mean(X);
        var_c2(i) = var(X);
    end
    
    %Prior Prob
    priorA = log(size(trainA,1) / size(traindata,1));
    priorB = log(size(trainB,1) / size(traindata,1));
       
    for i = 1:num_test
        
        dp = test(i,:);
        likeA = 0;
        likeB = 0;
        
        for j = 1:nofeat
            v = dp(1,j);
            
            %Likelihood - Gaussian
            likeA = likeA - 0.5*( log(2*pi*var_c1(j)) + (((v-mean_c1(j))^2) / var_c1(j)) );
            likeB = likeB - 0.5*( log(2*pi*var_c2(j)) + (((v-mean_c2(j))^2) / var_c2(j)) );
        end
        
        %Posterior Prob
        posteriorA = priorA + likeA;
        posteriorB = priorB + likeB;
        
        %Accuracy Calc
        
        if(posteriorA>=posteriorB)
            calc_label = 1;
        
        else
            calc_label = -1;
        end

        if(calc_label ~= test_labels(i))
             error = error + 1;         
        end

    end
    accuracy = ((num_test-error)*100) / (num_test);     
end

