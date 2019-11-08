

// Ganz wichtig !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// für die genauigkeit (macag numbers in den while schleifen) muss eine Bessere Lösung gefunden werden, je nach kreis größe ist sie unterschiedlich







// Werte werden mittel Auswerteverhafren ausgeählt, wird sich also alles noch verändern
I = [35; 0.909; 36.621; 10 ;4 ;2 ]; // In AmpereI = [0.22; 0.255; 0.289; 0.37; 0.5; 0.78];
U = [380; 246.8; 304.1; 39; 80; 150]; // In Volt
phi = [69.8; 3.2; 79.126; 63; 77; 54];
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



    // Anfang Punkte rechnen
counter = 1;
while counter <= Punkte
    plot(Px(counter,1), Py(counter,1),'+');
    counter = counter+1;
end

plot(x,y);
plot(Mx, My, '+');

// Ende Punkte rechnen


disp(imag(Ik_komp));


// Anfang Genaugikeit 

genauigkeitX = x(1,90) - x(1,91); // Bei 90, 91 ist der gröste abstand bei den X-werten
genauigkeitY = y(1,2) - y(1,1); // Bei 1, 2 ist der größte Abstand bei den Y-werten

// Ende Genauigkeit




// Anfang einzeichnen von P0 und Punend

    //Anfang P0
P0 = ones(1,2);
Punend = ones(1,2);
counter = 1;
while counter <= 360
    if y(1, counter) <= genauigkeitY then
        if y(1,counter) >= -genauigkeitY then
            if x(1, counter) < Mx then // Diese Abfrage ist dafür da, das nur der ganz linke 0 Wert genommen wird
                P0(1,1) = x(1, counter);
                P0(1,2) = y(1,counter);
                break
            end;
        end
    end
    counter = counter +1;
end
plot(P0(1,1),P0(1,2), '+red');

    // Punend
// es sind x Anzahl an xWerten zwischen der x-Achse und dem Pk die Hälfte der Anzahl an Punkten was dazwischen liegen entspricht meinem Punend
Ik_komp = I(1,1) * cosd(phi(1,1)) + %i*I(1,1)*sind(phi(1,1));
Pk = ones(1,2);
Pk(1,1) = imag(Ik_komp); // x wert
Pk(1,2) = real(Ik_komp); // y-wert
plot(Pk(1,1), Pk(1,2), '+red')

counterPk = 1;
while counterPk <= 360
    if y(1, counterPk) >= Pk(1,2) - genauigkeitY then
        if y(1,counterPk) <= Pk(1,2) + genauigkeitY then
            if x(1, counterPk) >= Pk(1,1) - genauigkeitX then
                if x(1,counterPk) <= Pk(1,1) + genauigkeitX then
                    break;
                end
            end
        end
    end
    counterPk = counterPk +1;
end

// Ausrechnen an wievlieter stellte die x achse und der Kreis schneiden (rechts)
kreisstellen = size(x);

counter = 1;
counterAchse = 1;
while counter <= 360
    if y(1, counter) <= genauigkeitY then // Genauigkeit muss bei jedem mal umgestellt werden -> bessere Lösung
        if y(1,counter) >= -genauigkeitY then
            counterAchse = counter;
        end
    end
    counter = counter +1;
end

AnzahlPunkteAbstand = 0;
if Pk(1,2) < My then
    AnzahlPunkteAbstand = kreisstellen(1,2) - (counterPk-counterAchse);
end

if Pk(1,2) >= My then
    AnzahlPunkteAbstand = kreisstellen(1,2)- (counterAchse-counterPk);
end

stelle = counterAchse + (AnzahlPunkteAbstand/2); // noch eine Abfrage fals der Wert nicht ganzzahlig ist
if pmodulo(stelle ,2) > 0 then // mit Pmodulo schaut man wie viel rest bei der Division bleibt
    stelle = stelle +0.5;
end

if stelle > kreisstellen(1,2) then // Wenn P0 über dem Mittelpunkt ist
     stelle = stelle - kreisstellen(1,2);
end

Punend = ones(1,2);
Punend(1,1) = x(1, stelle) // X wert
Punend(1,2) = y(1, stelle) // Y-wert

plot(Punend(1,1), Punend(1,2), '+red')
// Ende einzeichnen von P0 und Punend




// Hier wird Zk berechnet 
Ik_komp = I(1,1) * cosd(phi(1,1)) + %i*I(1,1)*sind(phi(1,1));
Rk = (real(Ik_komp))/U(1,1);

Sk = I(1,1) * U(1,1);
Qk = imag(Ik_komp) * U(1,1);
Xs = Qk/(I(1,1)^2);

Zk = Rk + %i*Xs;
// Hier endet das Berechnen von Zk
