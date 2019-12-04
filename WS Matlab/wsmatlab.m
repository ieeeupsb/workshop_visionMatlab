close all; clear; clc;

im = im2double(imread('C:\Users\toze6\Desktop\WS Matlab\circles.png'));
figure(1)
imshow(im)

red = im(:,:,1);
green = im(:,:,2);
blue = im(:,:,3);

figure(2)
subplot(2,2,1)
imshow(im)
subplot(2,2,2)
imshow(red)
subplot(2,2,3)
imshow(green)
subplot(2,2,4)
imshow(blue)

test = green-red;

test = imbinarize(test, 0.4);
figure(3)
imshow(test)

test=imopen(test,strel('square',2));
figure(4)
imshow(test)

label=bwlabel(test);

R=regionprops(label,'Area');

size(R,1)

