function res = count_all_cells(fname)

%fname = '000000_-1122000_090000.tif';
info = imfinfo(fname);
num_images = numel(info);
num_images
temp = imread(fname);
[r,c] = size(temp);
A = zeros(r,c,num_images,'uint16');
% Load data
for k = 1:  num_images
    A(:,:,k) = imread(fname, k);
end

res = zeros(5,1);

layer1 = max(A(:,:,1:200),[],3);
res(1) = count_cell(layer1);
layer1 = max(A(:,:,200:400),[],3);
res(2) = count_cell(layer1);
layer1 = max(A(:,:,400:600),[],3);
res(3) = count_cell(layer1);
layer1 = max(A(:,:,600:800),[],3);
res(4) = count_cell(layer1);
layer1 = max(A(:,:,800:end),[],3);
res(5) = count_cell(layer1);

res

end 

function res = count_cell(layer)
        level= graythresh(layer);
        bw=imbinarize(layer,level);
        res = max(max(bwlabel(bw)));
end
