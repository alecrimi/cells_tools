 multiplier = 5000; 
 background_red = imopen(A,strel('disk',15));
 A_c = A ./ background_red*multiplier;
 % A_c = medfilt2(A_c);
 A_cc = imadjust(A_c);
 level = graythresh(A_cc);
 A_bin = imbinarize(A_cc,level);
 figure; imagesc(A_bin); 
