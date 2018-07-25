clear all;

use_abs_path = 0; % 0 means "no", 1 means "yes"
%delete(gcp('nocreate'))
%parpool('local',4);
% get all the tif file in the folder
if(use_abs_path)
   strImPath=  'E:\KristinaAirich_384Well_Screen_Plate_4_0207182044_1\';
   cellFiles = dir([strImPath '/*.tif']);
else
   cellFiles = dir(['*.tif']);
   cellFiles={cellFiles.name};
end
 
only_blue = zeros(numel(cellFiles)/2, 1);
outer_count = 1;
for i= 1: 2 :  numel(cellFiles)
    i
    blue_channel =  imread(fullfile(strImPath, cellFiles{i}), 'tif');
 %   green_channel = imread(fullfile(strImPath, cellFiles{i+1}), 'tif');
   % blue_channel = adapthisteq(blue_channel);
   % figure; imagesc(blue_channel);
    % Possible parameter is the threshold: level
    level = graythresh(blue_channel);
    level = level - 0.03 ; %
    BW_blue = imbinarize(blue_channel,level);
    [L,n_blue] = bwlabel(BW_blue);
    
    %Watershed with maxima suppression
    bw2 = imfill(BW_blue,'holes');
    bw3 = imopen(bw2, ones(5,5)); 
    bw4 = bwareaopen(bw3, 15); %Level of segmentation in the watershed
    % bw4_perim = bwperim(bw4);
    mask_em = imextendedmax(blue_channel, 30);
    mask_em = imclose(mask_em, ones(5,5));
    mask_em = imfill(mask_em, 'holes');
    mask_em = bwareaopen(mask_em, 15); %Level of segmentation in the watershed
    blue_channel_c = imcomplement(blue_channel);
    I_mod = imimposemin(blue_channel_c, ~bw4 | mask_em);
    L2 = watershed(I_mod);
    n_ws = max(max(L2));
     
    % Remove cells smaller than the min area
    min_area = 700; 
    list_canc = [];
    count = 1;
    for ll = 1 : n_ws
         %ll
          [loc_r,loc_c] = find(L2==ll);

          %Remove spots smaller than an area
          if length(loc_r) < min_area
              for jj = 1 : length(loc_r)
                  L2(loc_r(jj),loc_c(jj)) = 0;
              end
          end
     end %end for

     only_blue(outer_count) = length(unique(L2))-1;
     outer_count = outer_count +1 ;
end

val_blue = zeros(numel(cellFiles)/4, 1);
counter_channel = 1;
for kk = 1 : 4: length(only_blue)
 
    val_blue(counter_channel) = mean(only_blue(kk:kk+3));
    counter_channel = counter_channel +1;
   
end

heatmap = reshape(val_blue,24,16);
figure; imagesc(heatmap');

yticklabels={'B','D','F','H','J','L','N','P'};
set(gca,'ytick',[2     4     6     8    10    12    14    16],'yticklabel',yticklabels);
colorbar;
title('Plate X');
save('')
%csvwrite('res.csv',val_blue);
