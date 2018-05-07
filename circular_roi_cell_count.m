function counts = circular_roi_cell_count(im)

imag = imread(im);
imshow(imag);

% Select ROI0
h =  imellipse;
% Mask data
BW = createMask(h);
imag = rgb2gray(imag);
sel = imag .* uint8(BW);

[r,c] = find(sel);

start_y = min(r);
end_y = max(r);
start_x = min(c);
end_x = max(c);

ROI = imag(start_y:end_y,start_x:end_x);

level = graythresh(ROI);

BW = imbinarize(ROI,level);
[L,counts] = bwlabel(BW)
