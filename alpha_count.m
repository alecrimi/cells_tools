clear all;

strImPath='I:\KristinaAirich_384Well_Screen_Plate_4_0207182044_1';

% get all the tif file in the folder
cellFiles=dir(strImPath);
cellFiles={cellFiles.name}';
cellFiles(cellfun('isempty', strfind(cellFiles, 'tif')))=[];

 
matOutput=nan(numel(cellFiles)/2, 1);
outer_count = 1;
for i=1:2: numel(cellFiles)
    i
%     green_channel = imread('A - 05(fld 1 wv 473 - Green1).tif');
%     blue_channel = imread('A - 05(fld 1 wv 390 - Blue).tif');
    blue_channel =  imread(fullfile(strImPath, cellFiles{i}), 'tif');
    green_channel = imread(fullfile(strImPath, cellFiles{i+1}), 'tif');
   % blue_channel = adapthisteq(blue_channel);
   % figure; imagesc(blue_channel);
    % Possible parameter is the threshold: level
    level = graythresh(blue_channel);
    level = level + 0.03 ; %
    BW_blue = imbinarize(blue_channel,level);
    [L,n_blue] = bwlabel(BW_blue);
    
    
    %Watershed with maxima suppression
     bw2 = imfill(BW_blue,'holes');
     bw3 = imopen(bw2, ones(5,5));
     bw4 = bwareaopen(bw3, 20);
    % bw4_perim = bwperim(bw4);
     mask_em = imextendedmax(blue_channel, 30);
     mask_em = imclose(mask_em, ones(5,5));
     mask_em = imfill(mask_em, 'holes');
     mask_em = bwareaopen(mask_em, 20);
     blue_channel_c = imcomplement(blue_channel);
     I_mod = imimposemin(blue_channel_c, ~bw4 | mask_em);
     L2 = watershed(I_mod);
     n_ws = max(max(L2));
     

     min_area = 50;
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
          else
              
          % Expand cells    
          % Create a temporary mask
          mask = zeros(size(L));
 
          for jj = 1 : length(loc_r)
                  mask(loc_r(jj),loc_c(jj)) = 1;
          end
          expansion = 10;
          SE = strel('rectangle',[expansion expansion]); 
          expanded_mask = imdilate(mask,SE);
          
          %Use mask
          area_around = expanded_mask.* double(green_channel);
          %Find intensities
          [row,col]= find(area_around>0);
          temp = zeros(length(row),1);
          for mm = 1 : length(row)
              temp(mm) = area_around(row(mm),col(mm));
          end
          
          tot_intensities_around(count) = mean(temp);  
          count  = count +1; 
          end %End if
     end %end for
 
     indices = find(tot_intensities_around > std(tot_intensities_around)*2);
     
     cellcount = length(indices);
     matOutput(outer_count) = cellcount;
     cellcount
   % fprintf('%d/%d \n', (i+1)/2, numel(cellFiles)/2)
end

csvwrite('res.csv',matOutput);
