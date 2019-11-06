/*
I = [10 ;4 ;2; 0.37; 0.5; 0.78]; // In AmpereI = [0.22; 0.255; 0.289; 0.37; 0.5; 0.78];
U = [39; 80; 150; 189.8; 246.8; 304.1]; // In Volt
phi = [63; 77; 54; 58.7; 80; 71.5];
*/
// Nur Betrag und Phase von Spannung und Strom
// Werte einlesen:
// Werte werden mittel Auswerteverhafren ausgeählt, wird sich also alles noch verändern
I = [0.37; 0.5; 0.78; 10 ;4 ;2 ]; // In AmpereI = [0.22; 0.255; 0.289; 0.37; 0.5; 0.78];
U = [ 189.8; 246.8; 304.1; 39; 80; 150]; // In Volt
phi = [58.7; 80; 71.5; 63; 77; 54];
/*Uw = [50; 100; 250]; // Spannungseinstellung des Wattmeters in Volt
Iw = [25; 5; 5]; // Stromeinstellung des Wattmeters in Ampere
alpha = [14; 14; 14]; // Zeigerausschlag des Wattmeters
skala = [100; 100; 100]; // Skala auf der der Zeigerausschlag gemessen wurde*/
// Ende Werte einlesen

fehler = 1; // Von einem Fehler ausgehen, dass man in die While schleife kommt
fehlercounter =1; // Wie oft neue Punkte genommen werden und die Ortskurve neu berechnet wird

Punkte = 3;
BenoetigtePunkte = 0; // drei, Weil wir drei Werte zum ausrechnen des Kreises benötigen
WerteCounter = 1;
AnzahlPunkte = size(I);
AnzahlPunkte = AnzahlPunkte(1,1);
I_komp = zeros(Punkte,1)

while fehler == 1 // Achtung noch in der Schleife das nicht immer die gleichen Werte verwendet werden
    fehler = 0;
    while fehlercounter <= AnzahlPunkte/3
        // Hier wird die Ortskurve gezeichnet 
            //  Anfang Punkte für die Ortskurve ausrechnen
        BenoetigtePunkte = BenoetigtePunkte + Punkte;
        counter = 1;
        while WerteCounter <= BenoetigtePunkte
            I_komp(counter,1) = I(WerteCounter,1) * cosd(phi(WerteCounter,1)) + %i * I(WerteCounter,1) * sind(phi(WerteCounter,1));
            WerteCounter = WerteCounter+1;
            counter = counter +1;
        end
        
        counter = 1;
        Px = zeros(BenoetigtePunkte,1);
        Py = zeros(BenoetigtePunkte,1);
        
        while counter <= Punkte
            Px(counter,1) = imag(I_komp(counter,1));
            Py(counter,1) = real(I_komp(counter,1));
            counter = counter+1;
        end
            // Ende Punkte für die Ortskurve ausrechnen
            
            
            // Anfang Mittelpunkt und Radius ausrechnen
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
            // Ende Mittelpunkt und Radius ausrechnen
        
            // Anfang Ortskurve zeichnen
        x = 0;
        y = 0;
        angle = linspace(0, 2*%pi, 360); // die Punkte x und y des Kreises defineren (360 Stück)
        x = Mx + r *cos(angle);
        y = My + r *sin(angle);
        
            // Ende Ortskurve zeichnen
        // Anfang Lage des Kreises Überprüfen
            // Schauen ob der Mittelpunkt im 1. Quadranten liegt
        if (Mx<0) then
            disp("Ortskurven Mittelpunkt liegt im Falschen Quadranten");
            fehler = 1;
        end
        if (My<0) then
            disp("Ortskurven Mittelpunkt liegt im Falschen Quadranten");
            fehler = 1;
        end
            // Schauen ob Kreis die y-Achse schneidet
        counter = 1;
        while counter <= 360
            if x(1, counter) <= 0 then
                disp("Ortskurve liegt im 2.Quadranten, Falsch");
                fehler = 1;
                break;
            end
            counter = counter +1;
        end
        // Ende Lage des Kreises Überprüfen

        
        if fehler == 0 then 
            fehlercounter = 5;
        end
        fehlercounter = fehlercounter +1
    end
end
    // Anfang Punkte zeichnen
counter = 1;
while counter <= Punkte
    plot(Px(counter,1), Py(counter,1),'+');
    counter = counter+1;
end
    // Ende Punkte zeichnen

plot(x,y);
plot(Mx, My, '+');

// Hier endet das Zeichnen der Ortskurve


// Hier wird Zk berechnet 
/*
Pk = Uw(1,1)*Iw(1,1)*alpha(1,1)/skala(1,1); // Das ist die Scheinleistung was berechnet wird
Rk = Pk/real(I_komp(1,1));
Xs = (sqrt(U(1,1)*I(1,1)^2-Pk^2))/I(1,1)^2; // Passt noch nicht, weil es nicht sicher ist das der Erste messwert der Messwert im
 Kurzschlusspunkt ist

Zk = Rk + %i *Xs; // Passt noch nicht so

disp(Zk, "Zk=");*/
// Hier endet das Berechnen von Zk

/*
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
*/
