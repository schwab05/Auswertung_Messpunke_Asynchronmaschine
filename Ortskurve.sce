
P0 = [1,2]; // Leerlauf punkt
Pk = [3,4]; // zuerst X , dann Y koordinate
Punend = [4,2]; // mit der formel (x-m1)^2 + (y-m2)^2 = r^2 kann man sich mittelpunkt und Radius mittels der drei Punkte berechnen

function[f] = F(x)
    f(1) = (1-x(1))^2+(2-x(2))-x(3)^2
    f(2) = (3-x(1))^2+(4-x(2))-x(3)^2
    f(3) = (4-x(1))^2+(2-x(2))-x(3)^2
endfunction

x = [2; 111; 19];
//y = fsolve(x,F);

function[g] = G(x)
    g(1) = x(1)^2+x(2)^2+x(3)^2-3;
    g(2) = x(1)*x(2)*x(3)-1;
    g(3) = x(1)^3+x(2)^2 -2*x(3)^2;
endfunction

function[j] = jacob(x)
    j(1,1) = 2*x(1); j(1,2) = 2*x(2);j(1,3) = 2*x(3);
    j(2,1) = x(2)*x(3); j(2,2) = x(1)*x(3);j(2,3) = x(1)*x(2);
    j(3,1) = 3*x(1)^2; j(3,2) = 2*x(2);j(3,3) = -4*x(3);
endfunction

[x,v,info]=fsolve(x,G,jacob);
disp(x)
disp(y);
