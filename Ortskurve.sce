
// Ortskruve zeicnen
// Random werte für die Punkte definieren
P0x = 1;
P0y = 1;
Pkx = 3;
Pky = 3;
Punx = 4;// unendlich  = un
Puny = 2; 

// Punkte als matrix

P0 = [P0x, P0y];
Pk = [Pkx, Pky];
Pun = [Punx, Puny]; // Unendlichkeitspunkt

// Matrizen zum Lösen der Linearen Gleichung
MatrixA = [1, 2*P0x, 2*P0y; 1, 2*Pkx, 2*Pky; 1, 2*Punx, 2*Puny]
MatrixX = ones(3,1);
MatrixB = [P0x^2*P0y^2; Pkx^2*Pky^2; Punx^2*Puny^2];

MatrixX = inv(MatrixA)*MatrixB;

A = MatrixX(1,1);
B = MatrixX(2,1);
C = MatrixX(3,1);

radius = sqrt(MatrixX(1,1));
m1 = zeros(2,1);
m2 = zeros(2,1);

m1(1,1) = (-1+sqrt(1+4*-1*-2*P0x*B))/-2
m1(2,1) = (-1-sqrt(1+4*-1*-2*P0x*B))/-2

m2(1,1) = (-1+sqrt(1+4*-1*-2*P0y*C))/-2
m2(2,1) = (-1-sqrt(1+4*-1*-2*P0y*C))/-2

MittelpunktX = m1(2,1);
MittelpunktY = m2(2,1);
