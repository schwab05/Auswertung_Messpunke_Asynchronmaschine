// Punkte und formel bite
P1x = 1;
P1y = 1;
Pkx = 3;
Pky = 3;
P3x = 4;
P3y = 2;
// Mit der Formel (x-mx)^2+(y-my)^2-r^2 = 0 bekommt man mittelpunkt und radius
// Die drei Punkte werden als x und y in die drei Formeln eingesetzt und mit fsolve wird der Mittelpunkt und radius errechnet.
function[f] = F(x)
    f(1) = (P1x-x(1))^2+(P1y-x(2))^2-x(3)^2 // x(1) entspricht m1, X(2) entsprciht m2 und x(3) entspricht dem Radius
    f(2) = (Pkx-x(1))^2+(Pky-x(2))^2-x(3)^2
    f(3) = (P3x-x(1))^2+(P3y-x(2))^2-x(3)^2 
endfunction
// Initial guess
x = [3; 11; 1];
// Nichtlineare Gleichung muss mit fsolve gelöst werden
[x,v,info]=fsolve(x,F);
disp(x);

Mx = x(1,1); // Mittelpunkt X-Koordinate
My = x(2,1); // Mittelpunkt Y-Koordinate
r = x(3,1); // Radius

if r < 0 then   // Manchmal erhält man für den Radius einen Negativen Wert deshalb
    r = r *-1;
end

// die Punkte x und y des Kreises defineren (360 Stück)
angle = linspace(0, 2*%pi, 360);
x = Mx + r *cos(angle);
y = My + r *sin(angle);

plot(x,y);
plot(P1x, P1y,'+');
plot(Pkx, Pky, '+');
plot(P3x, P3y, '+');
plot(Mx, My, '+');

