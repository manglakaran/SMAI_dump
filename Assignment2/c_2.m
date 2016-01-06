w1 = [1 1 7;1 6 3;1 7 8;1 8 9;1 4 5;1 7 5];
w1 = w1';
w2 = [1 3 1;1 4 3;1 2 4;1 7 1;1 1 3;1 4 2];
w2 = -w2;
w2 = w2';
w3 = [w1 w2];
a1 = [-1;-1;-1];
[x y] = size(w3);
b = .1;
a2 = a1;
a3 = a1;
a4=a1;
cnt =0;
while 1
    k=0;
    for i=1:y
        c = w3(:,i);
        p = a3'*c;
        if a3'*c <= b - 0.0000001
            a3 = a3 + ((b-a3'*c)/(norm(c))^2)*c;
            k = 1;
            cnt= cnt +1;
        end
    end
    if k==0
        break
    end
end
disp(cnt)
w2 = -w2;
figure;
x = w2(2,:);
y = w2(3,:);
plot(x,y,'r.','markersize',20); hold all;
plot(w1(2,:),w1(3,:),'g.','markersize',20); hold all;

plot([-a3(1,:)/a3(2,:) 0],[0 -a3(1,:)/a3(3,:)]);hold all;