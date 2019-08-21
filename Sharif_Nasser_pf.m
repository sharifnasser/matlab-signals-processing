% Autor: Sharif Nasser Kadamani
% Matricula: A00820367  Carrera: ISD  Semestre: 2
% Fecha: 1 / Oct / 2017

% Descripcion: Este programa utiliza como entrada una imagen
% (preferiblemente de 8 bits), la redimensiona para manejarla con
% facilidad, analiza cada uno de los pixeles de la imagen reducida y de
% acuerdo al valor del color dominante en cada pixel genera una onda
% senoidal con la frecuencia de la nota musical (Do, Re, Mi, Fa...) que le
% he asignado. En pocas palabras, el programa genera m�sica a partir de una
% imagen. Adem�s, al mismo tiempo que se definen las frecuencias para cada
% pixel, se va construyendo una nueva imagen con valores aleatorios para el
% color dominante en el pixel que tiene la misma ubicaci�n en la imagen
% original, obteniendo al final una im�gen un poco abstracta que se parece
% a la original. Es as� que a esta nueva imagen se le asigna un valor aleatorio 
% a una sola de las tres capas de colores por cada pixel. Finalmente,
% tambi�n se presenta an�lisis de las ondas generadas de: Amplitud
% vs. Tiempo, Magnitud vs. Frecuencia con la Transformada R�pida de
% Fourier, Potencia vs. Frecuencia con la Densidad Espectral de Potencia de
% Welch y de Frecuencia, Tiempo y Amplitud en una reprensentaci�n en 3D. Y
% tambi�n se aplica el filtro de Laplace para visualizar si logra mejorar
% la imagen final en escala de grises
%
% NOTAS IMPORTANTE: 
% Se recomienda utilizar imagenes de calidad de 8 bits, el archivo en que
    % se adjunta el programa incluye varias im�genes de ejemplo, que se
    % eligieron de acuerdo a la variaci�n de los colores en la imagen y,
    % por tanto, de las notas musicales generadas.
% Las frecuencias empleadas para las notas musicales pertenecen a la 
    % Octava 3, se pueden cambiar si se desea en la variables que est�n a
    % pocas l�neas debajo de esto.
% Gran parte del c�digo est� comentado, esto se debe a que ejecutarlo en
    % su totalidad podr�a ocupar mucha memoria RAM y, por tanto, realentizar
    % la computadora. Recomiendo ir descomentando los segmentos de c�digo
    % en etapas para ir visualizando las diferentes gr�ficas que ofrece el
    % programa.
% Es posible variar el valor de la frecuencia de muestreo para escuchar los
    % distintos sonidos que se obtienen para cada nota musical


clc, clear, close all;

I = imread('eye.jpg');  % Se carga la imagen a una variable
figure
imshow(I);  % Despliega la imagen original
title('Imagen original');

% Frecuencias de las notas musicales en la 3era Octava
DoFq = 261.63; %Hz
ReFq = 293.66; %Hz
MiFq = 329.63; %Hz
FaFq = 349.23; %Hz
SolFq = 392.00; %Hz
LaFq = 440.00; %Hz
SiFq = 493.88; %Hz

scale = 1/10;   % Factor de escala para reducci�n del tama�o de la imagen original

Is = imresize(I,scale); % Reduccion de imagen de acuerdo al factor de escala
% Separaci�n de las tres capas de color de la imagen en matrices
R = Is(:,:,1); 
G = Is(:,:,2);
B = Is(:,:,3);
Ig = rgb2gray(Is);  % Conversi�n de imagen a escala de grises
figure(2)
imshow(Is); % Despliega imagen a color reducida
title('Imagen reducida');
[Row, Col] = size(Ig); % Obtencion del nuevo tama�o de la imagen

% Declaracion de la nueva matriz
newIs = uint8(zeros(size(Is))); % Se asigna la imagen original para obtener una matriz de iguales dimensiones

% Determinacion de las frecuencias de onda para cada rango de valores del
% color dominante en los pixeles de la imagen y asignacion de valores
% aleatorio a la nueva matriz
for r=1:Row
    for c=1:Col
        % Si el rojo es el color dominante
        if (R(r,c) >= G(r,c) && R(r,c) >= B(r,c))
            if(R(r,c) <= 85)
                freq = DoFq;
                note = 'Do';
                newIs(r,c,1) = round(255*rand);
            elseif(R(r,c) > 85 && R(r,c) <= 170)
                freq = ReFq;
                note = 'Re';
                newIs(r,c,1) = round(84*rand+86);
            else
                freq = MiFq;
                note = 'Mi';
                newIs(r,c,1) = round(84*rand+171);
            end
        % Si el verde es el color dominante
        elseif (G(r,c) >= R(r,c) && G(r,c) >= B(r,c))
            if (G(r,c) <= 127)
                freq = FaFq;
                note = 'Fa';
                newIs(r,c,2) = round(127*rand);
            else
                freq = SolFq;
                note = 'Sol';
                newIs(r,c,2) = round(127*rand+128);
            end
        % Si el azul es el color dominante
        elseif (B(r,c) >= R(r,c) && B(r,c) >= G(r,c))
            if(B(r,c) <= 127)
                freq = LaFq;
                note = 'La';
                newIs(r,c,3) = round(127*rand);
            else
                freq = SiFq;
                note = 'Si';
                newIs(r,c,3) = round(127*rand+128);
            end
        end
        
        fs = 8000; % Frecuencia de muestreo
        tf = 0.5; % Tiempo
        t=0:1/fs:tf; % Vector de tiempo
        y=zeros(1, numel(t));
        y=sin(2*pi*freq*t); % Onda senoidal
        
        % Grafica Amplitud vs. Tiempo
        figure(3)
        plot(t,y);
        axis([0 tf -1.1 1.1])
        title(strcat(note , ': Onda senoidal'));
        xlabel('Tiempo (seg)');
        ylabel('Amplitud');
        
        % Descomentar esta secci�n para visualizaci�n de las otras gr�ficas
%         % Analisis de magnitud con Fourier
%         Y = fft(y);
%         L = numel(y);
%         P2 = abs(Y/L);
%         P1 = P2(1:L/2+1);
%         P1(2:end-1) = 2*P1(2:end-1);
%         f = fs*(0:(L/2))/L;
%         figure(4)
%         semilogy(f, P1);
%         title('An�lisis de evolucion de la onda con Fourier: Magnitud vs. Frecuencia');
%         ylabel('Magnitud');
%         xlabel('Frecuencia (Hz)');
%         axis([0 1000 0 1.2]);
%         grid on;
% 
%         % Densidad Espectral de Potencia de Welch
%         figure(5)
%         [pxx, f] = pwelch(y, 256, 50, round(freq), fs);
%         plot(f,10*log10(pxx));
%         title(strcat('Densidad Espectral de Potencia de Welch'));
%         ylabel('Potencia (dB)');
%         xlabel('Frecuencia (Hz)');
%         axis([0 500 -100 0]);
% 
%         % Espectrograma
%         figure(6)
%         [S,F,T,P] = spectrogram(y, 8, 7, round(freq),fs);
%         surf(T,F,P,'edgecolor','none'); axis tight; 
%         xlabel('Tiempo (seg)'); ylabel('Frecuencia (Hz)');
%         title('Espectrograma: Analisis de la evoluci�n de la onda');

        sound(y); % Reproduce la onda de sonido
        pause(0.5); % Realiza una pausa por un tiempo determinado
        
        % Despliega la frecuencia de la onda y la ubicacion en la matriz
        % del valor utilizado
        disp(strcat('freq: ', num2str(freq), ' row: ', num2str(r), ' column:', num2str(c)));
    end
end

figure(7)
imshow(newIs); % Despliega la nueva imagen en peque�a escala
newIs=imresize(newIs, 1/scale); % Aumenta el tama�o de la matriz al mismo de la imagen original
title('Nueva imagen reducida');
figure(8)
imshow(newIs); % Despliega la nueva imagen final
title('Nueva imagen');
figure(9)
newIs = rgb2gray(newIs);
imshow(newIs); % Despliega la nueva imagen en escala de grises
title('Imagen en escala de grises');

% Aplicaci�n de Filtro de Laplace
k_factor = 1;
Im = newIs;
[m, n] = size(Im); 
Im = double(Im); 
L = zeros(size(Im));
for k = 2 : (m - 1)
    for r = 2 : (n - 1)
        %segunda opcion
        L(k, r) = Im(k - 1, r - 1) + Im(k - 1, r) + Im(k - 1,r + 1) + ...
                  Im(k, r - 1) - ( 8 * Im(k, r) ) + Im(k, r + 1) + ...
                  Im(k - 1, r - 1) + Im(k - 1, r) + Im(k - 1, r + 1);
    end
end
Im_nit = Im - (k_factor) * L; 
Valor_min = min (min (Im_nit) ); % valor minimo de toda la imagen
L_offset = Im_nit - Valor_min; % con el valor minimo se desplaza para evitar negativos
Valor_max = max (max(L_offset) ); % se obtiene el valor maximo para normalizacion
Im_nit_norm = (L_offset / Valor_max) * 255;
Im_sharp = uint8 (Im_nit_norm); % se convierte la imagen en formato para el despliegue
figure(10)
imshow (Im_sharp);
title ('Nueva Imagen con Filtro de Laplace');