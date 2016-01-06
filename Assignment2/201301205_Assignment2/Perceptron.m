w1 = [1 1 7;1 6 3;1 7 8;1 8 9;1 4 5;1 7 5];
w1 = w1';
w2 = [1 3 1;1 4 3;1 2 4;1 7 1;1 1 3;1 4 2];
w2 = -w2;
w2 = w2';
w3 = [w1 w2];
a1 =  [-1;-1;-1];
[x y] = size(w3);
b = 100;
a2 = a1;
a3 = a1;
a4=a1;
cnt = 0;
while 1
    excp=0;
    for i=1:y
        c = w3(:,i);
        p = a1'*c;
        if a1'*c < 0
            a1 = a1 + c;
            excp = 1;
            cnt = cnt +1;
        end
    end
    if excp==0
        break
    end
end
disp(cnt)
cnt=0;
while 1
    excp=0;
    for i=1:y
        c = w3(:,i);
        p = a2'*c;
        if a2'*c < b
            a2 = a2 + c;
            excp = 1;
            cnt=cnt+1;
        end
    end
    if excp==0
        break
    end
end
disp(cnt)
cnt=0;
while 1
    excp=0;
    for i=1:y
        c = w3(:,i);
        p = a3'*c;
        if a3'*c <= b - 0.0000001
            a3 = a3 + ((b-a3'*c)/(norm(c))^2)*c;
            excp = 1;
            cnt = cnt +1;
        end
    end
    if excp==0
        break
    end
end
disp(cnt)

minn=200;
excp=1;
flag = 0;
cnt =0;
while 1
    for i=1:y
        c = w3(:,i);
        a4 = a4 + ((b-a4'*c)/(2*excp))*c;
        excp = excp+1;
        flag =0;
        cnt=cnt+1;
        %minn=min(minn,norm(((b-a4'*c)/(2*k))*c))
        if norm(((b-a4'*c)/(2*excp))*c) <  0.14
            flag = 1;
            break
        end    
        
    end
    if norm(((b-a4'*c)/(2*excp))*c) <=  0.14
        break
    end
%     if flag == 1
%         break
%     end
end
%disp(a2)
%disp(a1)
%disp(a3)
disp(cnt)
w2 = -w2;
figure;
x = w2(2,:);
y = w2(3,:);
plot(x,y,'r.','markersize',20); hold all;
plot(w1(2,:),w1(3,:),'g.','markersize',20); hold all;

plot([-a1(1,:)/a1(2,:) 0],[0 -a1(1,:)/a1(3,:)]);hold all;
plot([-a2(1,:)/a2(2,:) 0],[0 -a2(1,:)/a2(3,:)]);hold all;
plot([-a3(1,:)/a3(2,:) 0],[0 -a3(1,:)/a3(3,:)]);hold all;
plot([-a4(1,:)/a4(2,:) 0],[0 -a4(1,:)/a4(3,:)]);hold all;
legend('Class A', 'Class B', 'Single Sample Perceptron','With Margin', 'With Relaxation', 'Widrow-Hoff');