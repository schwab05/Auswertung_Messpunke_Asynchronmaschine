// Werte einlesen:
// Werte werden mittel Auswerteverhafren ausgeählt, wird sich also alles noch verändern
I = [10 ;4 ;2]; // In Ampere
U = [39; 80; 150]; // In Volt
Uw = [50; 100; 250]; // Spannungseinstellung des Wattmeters in Volt
Iw = [25; 5; 5]; // Stromeinstellung des Wattmeters in Ampere
alpha = [14; 14; 14]; // Zeigerausschlag des Wattmeters
skala = [100; 100; 100]; // Skala auf der der Zeigerausschlag gemessen wurde
// Ende Werte einlesen

// Hier wird die Ortskurve gezeichnet 
    //  Anfang Punkte für die Ortskurve ausrechnen

AnzahlWerte = size(I);
counterWerte = 1;
phi = zeros(AnzahlWerte(1,1),1);
I_komp = zeros(AnzahlWerte(1,1),1);

while counterWerte <= AnzahlWerte(1,1)
    phi(counterWerte,1) = acosd((Uw(counterWerte,1)*Iw(counterWerte,1)*alpha(counterWerte,1)/skala(counterWerte,1))/(U(counterWerte,1)*I(counterWerte,1))); // acosd Für den Winkel in grad
    I_komp(counterWerte,1) = I(counterWerte,1) * cosd(phi(counterWerte,1)) + %i * I(counterWerte,1) * sind(phi(counterWerte,1));
    counterWerte = counterWerte+1;
end

/*
phik = acosd((Uwk*Iwk*alphak/skalak)/(Uk*Ik)); // acosd Für den Winkel in grad
Ik_komp = Ik * cosd(phik) + %i * Ik * sind(phik);

phi2 = acosd((Uw2*Iw2*alpha2/skala2)/(U2*I2)); 
I2_komp = I2 * cosd(phi2) + %i * I2 * sind(phi2);

phi3 = acosd((Uw3*Iw3*alpha3/skala3)/(U3*I3)); 
I3_komp = I3 * cosd(phi3) + %i * I3 * sind(phi3);


Pkx = 1;
Pky = 1;
P2x = 3; // Die punkte müssen noch errechnet werden, derweil werden sie nur so geschrieben
P2y = 3;
P3x = 4;
P3y = 2;*/

counterWerte = 1;
Px = zeros(AnzahlWerte(1,1),1);
Py = zeros(AnzahlWerte(1,1),1);

while counterWerte <= AnzahlWerte(1,1)
    Px(counterWerte,1) = imag(I_komp(counterWerte,1));
    Py(counterWerte,1) = real(I_komp(counterWerte,1));
    counterWerte = counterWerte+1;
end

/*
Pkx = imag(Ik_komp);
Pky = real(Ik_komp);

P2x = imag(I2_komp); 
P2y = real(I2_komp);

P2x = imag(I2_komp);
P2y = real(I2_komp);*/


    // Ende Punkte für die Ortskurve ausrechnen

function[f] = F(x)
    f(1) = (Px(1,1)-x(1))^2+(Py(1,1)-x(2))^2-x(3)^2 // x(1) entspricht m1, X(2) entsprciht m2 und x(3) entspricht dem Radius
    f(2) = (Px(2,1)-x(1))^2+(Py(2,1)-x(2))^2-x(3)^2 // Mit der Formel (x-mx)^2+(y-my)^2-r^2 = 0 bekommt man mittelpunkt und radius
    f(3) = (Px(3,1)-x(1))^2+(Py(3,1)-x(2))^2-x(3)^2  // Die drei Punkte werden als x und y in die drei Formeln eingesetzt und mit fsolve wird der Mittelpunkt und radius errechnet.
endfunction

x = [30; 111; 13]; // Initial guess
[x,v,info]=fsolve(x,F);// Nichtlineare Gleichung muss mit fsolve gelöst werden
disp(x);
Mx = x(1,1); // Mittelpunkt X-Koordinate
My = x(2,1); // Mittelpunkt Y-Koordinate
r = x(3,1); // Radius

if r < 0 then   // Manchmal erhält man für den Radius einen Negativen Wert deshalb
    r = r *-1;
end

x = 0;
y = 0;
angle = linspace(0, 2*%pi, 360); // die Punkte x und y des Kreises defineren (360 Stück)
x = Mx + r *cos(angle);
y = My + r *sin(angle);

plot(x,y);


counterWerte = 1;
while counterWerte <= AnzahlWerte(1,1)
    plot(Px(counterWerte,1), Py(counterWerte,1),'+');
    counterWerte = counterWerte+1;
end

plot(Mx, My, '+');
// Hier endet das Zeichnen der Ortskurve

// Hier wird Zk berechnet

Pk = Uw(1,1)*Iw(1,1)*alpha(1,1)/skala(1,1); // Das ist die Scheinleistung was berechnet wird
Rk = Pk/real(I_komp(1,1));
Xs = (sqrt(U(1,1)*I(1,1)^2-Pk^2))/I(1,1)^2; // Passt noch nicht, weil es nicht sicher ist das der Erste messwert der Messwert im Kurzschlusspunkt ist

Zk = Rk + %i *Xs;

disp(Zk, "Zk=");
// Hier endet das Berechnen von Zk

// Anfang: Prüfen ob ein Punkt auf dem Kreis liegt
counter = 1;
while   counter < 360 // Passt noch nicht weil der Punkt (px) Variabl sein muss, sowie auch deie Abweichung (0,5)
    if Px(1,1) <= x(1,counter)+0.05 then
        if Px(1,1) >= x(1,counter)-0.05 then
            disp("Juhu");
            test = 3;
        end
    end
    counter = counter + 1;
end
// Ende: Prüfen ob ein Punkt auf dem Kreis liegt
