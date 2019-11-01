// Werte einlesen:
// Werte werden mittel Auswerteverhafren ausgeählt, wird sich also alles noch verändern
Ik = 10; // In Ampere
Uk = 39; // In Volt
Uwk = 50; // Spannungseinstellung des Wattmeters in Volt
Iwk = 25; // Stromeinstellung des Wattmeters in Ampere
alphak = 14; // Zeigerausschlag des Wattmeters
skalak = 100; // Skala auf der der Zeigerausschlag gemessen wurde

I2 = 4;
U2 = 80;
Uw2 = 100;
Iw2 = 5;
alpha2 = 14;
skala2 = 100;

I3 = 2;
U3 = 150;
Uw3 = 250;
Iw3 = 5;
alpha3 = 14;
skala3 = 100;
// Ende Werte einlesen

// Hier wird die Ortskurve gezeichnet 
    //  Anfang Punkte für die Ortskurve ausrechnen
phik = acosd((Uwk*Iwk*alphak/skalak)/(Uk*Ik)); // acosd Für den Winkel in grad
Ik_komp = Ik * cosd(phik) + %i * Ik * sind(phik);

phi2 = acosd((Uw2*Iw2*alpha2/skala2)/(U2*I2)); 
I2_komp = I2 * cosd(phi2) + %i * I2 * sind(phi2);

phi3 = acosd((Uw3*Iw3*alpha3/skala3)/(U3*I3)); 
I3_komp = I3 * cosd(phi3) + %i * I3 * sind(phi3);

/*
Pkx = 1;
Pky = 1;
P2x = 3; // Die punkte müssen noch errechnet werden, derweil werden sie nur so geschrieben
P2y = 3;
P3x = 4;
P3y = 2;*/

Pkx = imag(Ik_komp);
Pky = real(Ik_komp);

P2x = imag(I2_komp); 
P2y = real(I2_komp);

P3x = imag(I3_komp);
P3y = real(I3_komp);
    // Ende Punkte für die Ortskurve ausrechnen

function[f] = F(x)
    f(1) = (Pkx-x(1))^2+(Pky-x(2))^2-x(3)^2 // x(1) entspricht m1, X(2) entsprciht m2 und x(3) entspricht dem Radius
    f(2) = (P2x-x(1))^2+(P2y-x(2))^2-x(3)^2 // Mit der Formel (x-mx)^2+(y-my)^2-r^2 = 0 bekommt man mittelpunkt und radius
    f(3) = (P3x-x(1))^2+(P3y-x(2))^2-x(3)^2  // Die drei Punkte werden als x und y in die drei Formeln eingesetzt und mit fsolve wird der Mittelpunkt und radius errechnet.
endfunction
x = [3; 11; 1]; // Initial guess
[x,v,info]=fsolve(x,F);// Nichtlineare Gleichung muss mit fsolve gelöst werden

Mx = x(1,1); // Mittelpunkt X-Koordinate
My = x(2,1); // Mittelpunkt Y-Koordinate
r = x(3,1); // Radius

if r < 0 then   // Manchmal erhält man für den Radius einen Negativen Wert deshalb
    r = r *-1;
end

angle = linspace(0, 2*%pi, 360); // die Punkte x und y des Kreises defineren (360 Stück)
x = Mx + r *cos(angle);
y = My + r *sin(angle);

plot(x,y);
plot(Pkx, Pky,'+');
plot(P2x, P2y, '+');
plot(P3x, P3y, '+');
plot(Mx, My, '+');

// Hier endet das Zeichnen der Ortskurve

// Hier wird Zk berechnet

Pk = Uwk*Iwk*alphak/skalak; // Das ist die Scheinleistung was berechnet wird
Rk = Pk/real(Ik_komp);
Xs = (sqrt((Uk*Ik)^2-Pk^2))/Ik^2;

Zk = Rk + %i *Xs;

disp(Zk, "Zk=");
// Hier endet das Berechnen von Zk
