 multiplier = 5000; 
 background_red = imopen(A,strel('disk',15));
 A_c = A ./ background_red*multiplier;
 % A_c = medfilt2(A_c);
 A_cc = imadjust(A_c);
 level = graythresh(A_cc);
 A_bin = imbinarize(A_cc,level);
 figure; imagesc(A_bin); 


blue_channel = imread('A - 01(fld 1 wv 390 - Blue).tif');
level = graythresh(blue_channel);
BW_blue = imbinarize(blue_channel,level);
D = -bwdist(~BW_blue);
Ld = watershed(D);
bw2 = BW_blue;
bw2(Ld==0) = 0;
mask = imextendedmin(D,2);
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = BW_blue;
bw3(Ld2==0) = 0;
bw4 = imopen(bw3, ones(5,5)); 
%bw5 = imclose(bw4, ones(5,5)); 
figure; imagesc(bw4);
labeled = bwlabel(bw4);
max(max(labeled))
