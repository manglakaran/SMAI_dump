w1 = [1 1 7;1 6 3;1 7 8;1 8 9;1 4 5;1 7 5];
w1 = w1';
w2 = [1 3 1;1 4 3;1 2 4;1 7 1;1 1 3;1 4 2];
w2 = -w2;
w2 = w2';
w3 = [w1 w2];
a1 = [2;1;1];
[x y] = size(w3);
b = 100;
a2 = a1;
a3 = a1;
a4=a1;

while 1
    k=0;
    for i=1:y
        c = w3(:,i);
        p = a1'*c;
        if a1'*c < 0
            a1 = a1 + c;
            k = 1;
        end
    end
    if k==0
        break
    end
end

w2 = -w2;
figure;
x = w2(2,:);
y = w2(3,:);
plot(x,y,'r.','markersize',20); hold all;
plot(w1(2,:),w1(3,:),'g.','markersize',20); hold all;

plot([-a1(1,:)/a1(2,:) 0],[0 -a1(1,:)/a1(3,:)]);hold all;