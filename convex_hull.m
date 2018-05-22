close all
I = imread('001.tif');
I = imgaussfilt(I,5);
I = imadjust(I);
%I = medfilt2(I);

figure; imagesc(I);
mask = zeros(size(I));
mask(150:end-150,150:end-150) = 1;
%figure;imagesc(mask)
bw = activecontour(I,mask,700);
figure;imagesc(bw)
