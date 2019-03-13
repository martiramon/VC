im1 = imread('F1011flb.bmp'); % Llegim la imatge
im1 = imcrop(im1); % Retallem la imatge manualment


%% Part 2, binaritzat a partir de llindar preprogramat
% La nostra idea ha estat fer sempre dos binaritzats, un primer binaritzat
% que ens digui quines parts de la imatge son fons i quines son part de la
% carn. A partir d'aqui fem un segon binaritzat amb el threshold de la
% carn i calculem el nivell de greix restant el fons.

carn = 0;
greix = 0;

bgMask = imbinarize(im1, 0.3);
greixMask = imbinarize(im1, 0.7);

figure, imshow(bgMask);
figure, imshow(greixMask);

[x, y] = size(im1);

%Calcular el percentatge de greix
for i = 1:x
    for j = 1:y
        if bgMask(i, j) == 1
            carn = carn + 1;
            if greixMask(i, j) == 1
                greix = greix + 1;
            end
        end
    end
end

percentatgeGreix = greix / carn * 100;

close all
%% Part 3, binaritzat a partir de llindar a ull del histograma
h = histogram(im1);
[t1, k] = ginput(2) % t1 value determines the threshold values

bgMask = imbinarize(im1, t1(1)/255);
greixMask = imbinarize(im1, t1(2)/255);

figure, imshow(bgMask);
figure, imshow(greixMask);

[x, y] = size(im1);

%Calcular el percentatge de greix
for i = 1:x
    for j = 1:y
        if bgMask(i, j) == 1
            carn = carn + 1;
            if greixMask(i, j) == 1
                greix = greix + 1;
            end
        end
    end
end

percentatgeGreix = greix / carn * 100

close all

%% Part 4, trobar llindars de forma automatica
level = graythresh(im1)
bgMask = imbinarize(im1, level);
bgMask = cast(bgMask, 'like', im1);
imNoBG = im1.*bgMask; % fons completament negre (0)

fons = 0; %contem els pixels de fons per poder calcular el percentatge de greix restant el fons

for i = 1:x
    for j = 1:y
        if imNoBG(i, j) == 0
            imNoBG(i, j) = 255;
            fons = fons + 1;
        end
    end
end

level2 = graythresh(imNoBG); %threshold for the meat part
greixMask = imbinarize(imNoBG, level2); % els pixels negres corresponen a carn

carn = 0;

for i = 1:x
    for j = 1:y
        if greixMask(i, j) == 0
            carn = carn + 1;
        end
    end
end

percentatgeGreix = (x*y - carn - fons) * 100/carn 

%% Part 5, utilitzacio d'altres metodes

% P-Tile thresholding

% 