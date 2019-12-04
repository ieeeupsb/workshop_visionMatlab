close all; clear; clc;

%Aquisição de imagem em formato double
im=im2double(imread('C:\Users\toze6\Google Drive\MIEEC\MIEEC - 4º Ano\SBVI\Projeto Final\DataSet1\2_2.png'));
figure(1)
imshow(im)
%-----

%Separação em planos RGB com ajuste das intensidades de interesse
redPlane=im(:, :, 1);
eqRed = adapthisteq(redPlane);
greenPlane=im(:,:,2);
eqGreen = adapthisteq(greenPlane);
bluePlane=im(:,:,3);
figure(21)
imshow(redPlane)
figure(23)
imshow(eqRed)
%-----

%Remoção da cor branca e elementos referentes a outros planos
normRedSub = imsubtract(redPlane,0.7*greenPlane);
normRedSub(normRedSub<0)=0;
figure(22)
imshow(normRedSub)

normRedSub1 = imsubtract(redPlane,0.7*eqGreen);
normRedSub1(normRedSub<0)=0;
figure(24)
imshow(normRedSub1)

normBlueSub = imsubtract(bluePlane,0.65*greenPlane);
normBlueSub(normBlueSub<0)=0;
%-----

%Binarização dos planos de interesse e tratamento
redBinary=imbinarize(normRedSub,0.385);
figure(25)
imshow(redBinary)
redBinary=imopen(redBinary,strel('square',2));
redBinary=imclose(redBinary,strel('square',2));

redBinary1=imbinarize(normRedSub1,0.385);
figure(27)
imshow(redBinary1)
redBinary=imopen(redBinary,strel('square',2));
redBinary=imclose(redBinary,strel('square',2));

blueBinary=imbinarize(normBlueSub,0.38);
blueBinary=imopen(blueBinary,strel('square',2));
blueBinary=imclose(blueBinary,strel('square',2));
%-----

%Remoção de elementos de área reduzida
redBinary=bwareaopen(redBinary,120);
figure(26)
imshow(redBinary)
blueBinary=bwareaopen(blueBinary,100);
%-----

%Segmentação dos planos binarizados e labeling
redLabel=bwlabel(redBinary);
blueLabel=bwlabel(blueBinary);

figure(3)
imshow(redLabel)
figure(4)
imshow(blueLabel)
%----- 

redStats=regionprops(redLabel,'BoundingBox','Area','EulerNumber','Solidity');
blueStats=regionprops(blueLabel,'BoundingBox','Area','EulerNumber','Solidity');

n=size(redStats,1);
c=size(redLabel,2);
l=size(redLabel,1);

j=1;
k=1;
i=1;


for i=1:n
  if ~(isStop(redStats(i).BoundingBox(3),redStats(i).BoundingBox(4), redStats(i).EulerNumber, redStats(i).Solidity) || isProhibition(redStats(i).BoundingBox(3),redStats(i).BoundingBox(4), redStats(i).EulerNumber, redStats(i).Solidity))
       for j=1:c
           for k=1:l
               if(redLabel(k,j)==i)
                   redLabel(k,j)=0;
               end
           end
       end
       redStats(i).Area=0;
       redStats(i).EulerNumber=0;
       redStats(i).BoundingBox=0;
   end
end

figure(5)
imshow(redLabel)

n=size(blueStats,1);
c=size(blueLabel,2);
l=size(blueLabel,1);

j=1;
k=1;
i=1;

for i=1:n
   if ~(isMandatory(blueStats(i).BoundingBox(3), blueStats(i).BoundingBox(4), blueStats(i).EulerNumber, blueStats(i).Solidity))
       for j=1:c
           for k=1:l
               if(blueLabel(k,j)==i)
                   blueLabel(k,j)=0;
               end
           end
       end
       blueStats(i).Area=0;
       blueStats(i).EulerNumber=0;
       blueStats(i).BoundingBox=0;
   end
end

figure(6)
imshow(redLabel)

imLabel=imadd(redLabel,blueLabel);
imLabel(imLabel>1)=1;
imLabel=bwlabel(imLabel);

figure(7)
imshow(imLabel)

function [out] = isStop(width,height,eulerNumber,solidity)
    if (width*0.8 <= height && height <= width*1.2 && eulerNumber < -2 && eulerNumber > -5 && 0.68 <= solidity && solidity <= 0.8)
        out=true;
    else
        out=false;
    end 
end

function [out] = isProhibition(width,height,eulerNumber,solidity)
    if (width*0.8 <= height && height <= width*1.2 && eulerNumber >= 0 && 0.2 <= solidity && solidity <= 0.58)
        out=true;
    else
        out=false;
    end 
end

function [out] = isMandatory(width,height,eulerNumber,solidity)
    if (width*0.8 <= height && height <= width*1.2 && eulerNumber >= -1 && eulerNumber <= 1 && 0.61 <= solidity && solidity <= 0.85)
        out=true;
    else
        out=false;
    end 
end

function [out] = isPriority(width,height,eulerNumber,solidity)
    if (width*0.94 <= height && height <= width*1.06 && eulerNumber == 1 && 0.85 <= solidity && solidity <= 1)
        out=true;
    else
        out=false;
    end 
end

