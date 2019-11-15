// P0 wird ganz zum schluss anderes berechnet also ist der RFE berechenbar


// Punkte am Kreis nicht mit der While schleife berechnen sondern mit der Kreisgleichung !!

// Werte werden mittel Auswerteverhafren ausgeählt, wird sich also alles noch verändern
I = [35; 0.909; 36.621; 10 ;4 ;2 ]; // In AmpereI = [0.22; 0.255; 0.289; 0.37; 0.5; 0.78];
U = [380; 246.8; 304.1; 39; 80; 150]; // In Volt
phi = [69.8; 3.2; 79.126; 63; 77; 54];
nN = 1400; // Werte sind aus der Laborübung
nsyn = 1500;
m1 = 3;
U1str = 380/sqrt(3);
// Ende Werte einlesen




// Eingabe von Strangzahl und Leerlaufdrehzahl benötigt, eventuell auch Strangspannung


// Anfang Verschiedene Zeichenfenster
schlupfgerade = 1;
kennlinien = 2;
xgrid(1);
// Ende Verschieden Zeichenfenster



fehler = 1; // Von einem Fehler ausgehen, dass man in die While schleife kommt
fehlercounter =1; // Wie oft neue Punkte genommen werden und die Ortskurve neu berechnet wird

Punkte = 3;
BenoetigtePunkte = 0; // drei, Weil wir drei Werte zum ausrechnen des Kreises benötigen
WerteCounter = 1;
AnzahlPunkte = size(I);
AnzahlPunkte = AnzahlPunkte(1,1);
I_komp = zeros(Punkte,1);
Kreis_Punkte = 360;

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
        x_Kreis = 0;
        y_Kreis = 0;
        angle = linspace(0, 2*%pi, Kreis_Punkte); // die Punkte x und y des Kreises defineren (360 Stück)
        x_Kreis = Mx + r *cos(angle);
        y_Kreis = My + r *sin(angle);
        
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
        while counter <= Kreis_Punkte
            if x_Kreis(1, counter) <= 0 then
                disp("Ortskurve liegt im 2.Quadranten, Falsch");
                fehler = 1;
                break;
            end
            counter = counter +1;
        end
        
        // Schauen ob Kreis die x-Achse schneidet
        
        // Ende Lage des Kreises Überprüfen
        counter = 1;
        fehler = 1;
        while counter <= Kreis_Punkte
            if y_Kreis(1, counter) <= 0 then
                fehler = 0;
                break;
            end
            counter = counter +1;
        end
        
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
plot(x_Kreis,y_Kreis);
plot(Mx, My, '+');
// Ende Punkte rechnen




// Anfang Genaugikeit 

genauigkeitX = x_Kreis(1,90) - x_Kreis(1,91); // Bei 90, 91 ist der gröste abstand bei den X-werten
genauigkeitY = y_Kreis(1,2) - y_Kreis(1,1); // Bei 1, 2 ist der größte Abstand bei den Y-werten

// Ende Genauigkeit




// Anfang einzeichnen von P0 und Punend

    //Anfang P0
Punkt_0 = ones(1,2);
Punkt_unend = ones(1,2);
counter = 1;
stelle_P0 = 0;

while counter <= Kreis_Punkte
    if y_Kreis(1, counter) <= genauigkeitY then
        if y_Kreis(1,counter) >= -genauigkeitY then
            if x_Kreis(1, counter) < Mx then // Diese Abfrage ist dafür da, das nur der ganz linke 0 Wert genommen wird
                stelle_P0 = counter;
                Punkt_0(1,1) = x_Kreis(1, stelle_P0);
                Punkt_0(1,2) = y_Kreis(1,stelle_P0);
                break
            end;
        end
    end
    counter = counter +1;
end
plot(Punkt_0(1,1),Punkt_0(1,2), '+red');


// Kruzschlusspunkt

Ik = I(1,1) * cosd(phi(1,1)) + %i*I(1,1)*sind(phi(1,1));
Punkt_k = ones(1,2);
Punkt_k(1,1) = imag(Ik); // x wert
Punkt_k(1,2) = real(Ik); // y-wert 

//Der richtige Kurzschlusspunkt wird später nochmal ausgerechnet


    // Punend
// es sind x Anzahl an xWerten zwischen der x-Achse und dem Pk die Hälfte der Anzahl an Punkten was dazwischen liegen entspricht meinem Punend

counterPk = 1;
while counterPk <= Kreis_Punkte
    if y_Kreis(1, counterPk) >= Punkt_k(1,2) - genauigkeitY then
        if y_Kreis(1,counterPk) <= Punkt_k(1,2) + genauigkeitY then
            if x_Kreis(1, counterPk) >= Punkt_k(1,1) - genauigkeitX then
                if x_Kreis(1,counterPk) <= Punkt_k(1,1) + genauigkeitX then
                    stelle_Pk = counterPk;
                    break;
                end
            end
        end
    end
    counterPk = counterPk +1;
end



// Hier wird der Kurzschlusspunkt ausgebessert
Punkt_k(1,1) = x_Kreis(1, stelle_Pk);
Punkt_k(1,2) = y_Kreis(1, stelle_Pk);

plot(Punkt_k(1,1), Punkt_k(1,2), '+red');



// Ausrechnen an wievlieter stellte die x achse und der Kreis schneiden (rechts)

counter = 1;
stelle_XAchse_rechts = 1;
while counter <= Kreis_Punkte
    if y_Kreis(1, counter) <= genauigkeitY then 
        if y_Kreis(1,counter) >= -genauigkeitY then
            stelle_XAchse_rechts = counter;
        end
    end
    counter = counter +1;
end

AnzahlPunkteAbstand = 0;
if Punkt_k(1,2) < My then
    AnzahlPunkteAbstand = Kreis_Punkte - (stelle_Pk-stelle_XAchse_rechts);
end

if Punkt_k(1,2) >= My then
    AnzahlPunkteAbstand = Kreis_Punkte- (stelle_XAchse_rechts-stelle_Pk);
end

stelle_Punend = stelle_XAchse_rechts + (AnzahlPunkteAbstand/2); // noch eine Abfrage fals der Wert nicht ganzzahlig ist
if pmodulo(stelle_Punend ,2) > 0 then // mit Pmodulo schaut man wie viel rest bei der Division bleibt
    stelle_Punend = stelle_Punend +0.5;
end

if stelle_Punend > Kreis_Punkte then // Wenn P0 über dem Mittelpunkt ist
     stelle_Punend = stelle_Punend - Kreis_Punkte;
end

Punkt_unend = ones(1,2);
Punkt_unend(1,1) = x_Kreis(1, stelle_Punend) // X wert
Punkt_unend(1,2) = y_Kreis(1, stelle_Punend) // Y-wert

plot(Punkt_unend(1,1), Punkt_unend(1,2), '+red');
// Ende einzeichnen von P0 und Punend




// Hier wird Zk berechnet 
Ik = I(1,1) * cosd(phi(1,1)) + %i*I(1,1)*sind(phi(1,1));
Uk = U(1,1);

Rk = Uk/real(Ik);
Xs = Uk/imag(Ik);

Zk = Rk + %i*Xs;
// Hier endet das Berechnen von Zk



// Anfang ersatzschaltbild
    // Rfe
    // Annahme: Der letzte wert der Spannung ist U0
U0 = U(AnzahlPunkte, 1);
I0 = Punkt_0(1,1) + %i*Punkt_0(1,2);

Rfe = U0/real(I0);
Xh = U0/imag(I0);   // Rk und Xs sind bei Zk ausgerechnet worden
// Ende Ersatzschaltbild



// Momenten und Leistungskennlinie mit Geradengleichung
x_MomentLinie = [Punkt_0(1,1), Punkt_unend(1,1)];  
y_MomentLinie = [Punkt_0(1,2), Punkt_unend(1,2)];

k_ML = (y_MomentLinie(1,2)-y_MomentLinie(1,1))/(x_MomentLinie(1,2)-x_MomentLinie(1,1));
d_ML = y_MomentLinie(1,1) - k_ML * x_MomentLinie(1,1);

plot(x_MomentLinie , y_MomentLinie, 'b');

x_LeistungsLinie = [Punkt_0(1,1), Punkt_k(1,1)];
y_LeistungsLinie = [Punkt_0(1,2), Punkt_k(1,2)];

k_LL = (y_LeistungsLinie(1,2)-y_LeistungsLinie(1,1))/(x_LeistungsLinie(1,2)-x_LeistungsLinie(1,1));
d_LL = y_LeistungsLinie(1,1) - k_LL * x_LeistungsLinie(1,1);

plot(x_LeistungsLinie, y_LeistungsLinie, 'g');
// Ende Momenten und Leistungskennlinie mit Geradengleichung




// Anfang Abstand von Mk ausrechnen
counterMk = stelle_Punend;
x_ML = 0;
y_ML = 0;
x_Mk = 0;
y_Mk = 0;
stelle_Mk = 0;
Abstand_Mk_Neu = 0; // wird in cm ( oder welcher abstand da auch herscht) ausgerechnet, deswegen Abstand
Abstand_Mk = 0;

while counterMk <= stelle_P0
    x_ML = x_Kreis(1, counterMk);
    y_ML = k_ML * x_ML + d_ML;
    
    Abstand_Mk_Neu = y_Kreis(1, counterMk) - y_ML;
    
    if Abstand_Mk_Neu > Abstand_Mk then
        Abstand_Mk = Abstand_Mk_Neu;
        x_Mk = x_ML;
        y_Mk = y_ML;
        stelle_Mk = counterMk;
    end
    
    counterMk = counterMk + 1;
end

Punkt_Mk = [x_Kreis(1, stelle_Mk), y_Kreis(1, stelle_Mk)]

x_Mk = [x_Mk, Punkt_Mk(1,1)];
y_Mk = [y_Mk, Punkt_Mk(1,2)];

plot(Punkt_Mk(1,1), Punkt_Mk(1,2), '+black');
plot(x_Mk, y_Mk);
// Ende Abstand von Mk ausrechnen



// Anfang AnlaufMoment
stelle_MA = stelle_Pk;

x_MA = x_Kreis(1, stelle_MA);
y_MA = k_ML * x_MA + d_ML;

Abstand_MA = y_Kreis(1, stelle_MA) - y_MA

x_MA = [x_MA, x_Kreis(1, stelle_MA)];
y_MA = [y_MA, y_Kreis(1, stelle_MA)];

plot(x_MA, y_MA);
// Ende AnlaufMoment




// Anfang Kipp und Anlauf- momente Auslesen
mI = 0.015; // in A/m gerechnet, in Mathcad einmal ausgerechnet, um aufs richtige Mk zu kommen
// Weis nicht ob das passt bei anderen Ortskurven
mp = m1 * U1str * mI;
mM = 9.55 * mp/(nN / 60);

Mk = mM * Abstand_Mk;
MA = mM * Abstand_MA;
disp(Mk);
disp(MA);
// Ende Kipp und Anlauf- momente Auslesen





// GANZ WICHTIG 
// AB HIER DARF NUR MEHR IN DEM SCHLUPGERADENFENSTERGEZEICHNET WERDEN!!!!!!!!!!!



// Anfang Ortskurve in neuem Fenster Zeichnen
show_window(schlupfgerade);
plot(x_Kreis, y_Kreis),
plot(Mx, My, '+');
counter = 1;
while counter <= Punkte
    plot(Px(counter,1), Py(counter,1),'+');
    counter = counter+1;
end
plot(Punkt_0(1, 1), Punkt_0(1, 2), '+red');
plot(Punkt_unend(1, 1), Punkt_unend(1, 2), '+red');
plot(Punkt_k(1, 1), Punkt_k(1, 2), '+red');
// Ende Ortskurve in neuem Fenster Zeichnen




// Anfang Schlupfgerade zeichnen

// Anfang Punkt B bestimmen
stelle_PunktB = stelle_XAchse_rechts - stelle_Punend;
Punkt_B = [x_Kreis(1, stelle_PunktB), y_Kreis(1, stelle_PunktB)];
plot(Punkt_B(1,1), Punkt_B(1,2), '+green')
// Ende Punkt B bestimmen

// Hilfslinien für die Konstruktin der Schlupfgerade:
x_Linie_Pb_Punend = [Punkt_B(1, 1), Punkt_unend(1, 1)];
y_Linie_Pb_Punend = [Punkt_B(1, 2), Punkt_unend(1, 2)];

k_Linie_Pb_Punend = (y_Linie_Pb_Punend(1,2)-y_Linie_Pb_Punend(1,1))/(x_Linie_Pb_Punend(1,2)-x_Linie_Pb_Punend(1,1));
d_Linie_Pb_Punend = y_Linie_Pb_Punend(1,1) - k_Linie_Pb_Punend * x_Linie_Pb_Punend(1,1);

/*  // Pb zu Pk wird nicht benötigt
x_Linie_Pb_Pk = [Punkt_B(1, 1), Punkt_k(1, 1)];
y_Linie_Pb_Pk = [Punkt_B(1, 2), Punkt_k(1, 2)];

k_Linie_Pb_Pk = (y_Linie_Pb_Pk(1,2)-y_Linie_Pb_Pk(1,1))/(x_Linie_Pb_Pk(1,2)-x_Linie_Pb_Pk(1,1));
d_Linie_Pb_Pk = y_Linie_Pb_Pk(1,1) - k_Linie_Pb_Pk * x_Linie_Pb_Pk(1,1);
*/

x_Linie_Pb_P0 = [Punkt_B(1, 1), Punkt_0(1, 1)];
y_Linie_Pb_P0 = [Punkt_B(1, 2), Punkt_0(1, 2)];

k_Linie_Pb_P0 = (y_Linie_Pb_P0(1,2)-y_Linie_Pb_P0(1,1))/(x_Linie_Pb_P0(1,2)-x_Linie_Pb_P0(1,1));
d_Linie_Pb_P0 = y_Linie_Pb_P0(1,1) - k_Linie_Pb_P0 * x_Linie_Pb_P0(1,1);



// Schlupfgerade
x_Schlupfgerade(1, 1) = Punkt_k(1, 1);
y_Schlupfgerade(1, 1) = Punkt_k(1, 2);
k_Schlupfgerade = k_Linie_Pb_Punend;

d_Schlupfgerade = y_Schlupfgerade(1, 1) - k_Schlupfgerade * x_Schlupfgerade(1, 1);

x_Schlupfgerade(1, 2) = (d_Linie_Pb_P0- d_Schlupfgerade)/(k_Schlupfgerade - k_Linie_Pb_P0);
y_Schlupfgerade(1, 2) = k_Schlupfgerade * x_Schlupfgerade(1, 2) + d_Schlupfgerade;

laenge_Schlupfgerade = y_Schlupfgerade(1,1) - y_Schlupfgerade(1,2);

plot(x_Linie_Pb_Punend, y_Linie_Pb_Punend);
//plot(x_Linie_Pb_Pk, y_Linie_Pb_Pk);
plot(x_Linie_Pb_P0, y_Linie_Pb_P0);
plot(x_Schlupfgerade, y_Schlupfgerade, 'c')
xgrid();
// Ende Schlupfgerade zeichen




// Anfang Drehzahl Momentenverlauf

// Anfang Moment
counterM = 0;
x_ML = 0;
y_ML = 0;
Abstand_M = zeros(1, stelle_P0 - stelle_Pk);
M = zeros(1, stelle_P0 - stelle_Pk);

while counterM <= (stelle_P0 - stelle_Pk)
    x_ML = x_Kreis(1, (counterM+stelle_Pk));
    y_ML = k_ML * x_ML + d_ML;
    
    Abstand_M(1, counterM+1) = y_Kreis(1, (counterM+stelle_Pk)) - y_ML // Ohne counter +1 wäre der Matrix Index null, erhöht man den counter vorher
    
    counterM = counterM + 1;
    M(1, counterM) = mM * Abstand_M(1, counterM)
end
// ENDe Moment


// Anfang Drehzahl
counterS = 0;
n = zeros(1, stelle_P0 - stelle_Pk); 
while counterS <= stelle_P0 - stelle_Pk
    x_S_Auslesen = [Punkt_B(1,1), x_Kreis(1, counterS + stelle_Pk)];
    y_S_Auslesen = [Punkt_B(1,2), y_Kreis(1, counterS + stelle_Pk)];
    
    
    k_S_Auslesen = (y_S_Auslesen(1,2)-y_S_Auslesen(1,1))/(x_S_Auslesen(1,2)-x_S_Auslesen(1,1));
    d_S_Auslesen = y_S_Auslesen(1,1) - k_S_Auslesen * x_S_Auslesen(1,1);
    
    x_S_schneiden = (d_Schlupfgerade - d_S_Auslesen)/(k_S_Auslesen- k_Schlupfgerade );
    y_S_schneiden = k_S_Auslesen * x_S_schneiden + d_S_Auslesen;
    
    
    counterS = counterS + 1;
    
    Abstand_S = y_S_schneiden - y_Schlupfgerade(1, 2);
    Schlupf(1, counterS) = Abstand_S/laenge_Schlupfgerade;
    n(1, counterS) = nsyn * (1-Schlupf(1, counterS));
    
end
// Ende Drehzahl
// Ende Drehzahl Momentenverlauf
show_window(kennlinien);

plot(n ,M);
xgrid(1);
