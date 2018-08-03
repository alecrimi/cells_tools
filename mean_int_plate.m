function mean_int_plate(strImPath,use_abs_path)

% 0 means "no", 1 means "yes"
if ( nargin==2)
    use_abs_path = 1;
else
    use_abs_path = 0; 
    strImPath='.';
end 
%delete(gcp('nocreate'))
%parpool('local',4);
% get all the tif file in the folder
if(use_abs_path)
   %strImPath=  'E:\KristinaAirich_384Well_Screen_Plate_4_0207182044_1\';
   cellFiles = dir(strcat(strImPath, '/*.tif'));
   cellFiles={cellFiles.name};
else
   cellFiles = dir(['*.tif']);
   cellFiles={cellFiles.name};
end

mean_int_values= zeros(numel(cellFiles),1);  %This is the variable with the intensities
area_values = zeros(numel(cellFiles),1);  %This is the variable with the intensities
 
for i = 1 :  numel(cellFiles)
    i
    if(use_abs_path)
        %fullfile(strImPath, cellFiles{i})
        channel = imread(fullfile(strImPath, cellFiles{i}), 'tif');
    else
        channel = imread(  cellFiles{i} , 'tif');
    end

        level = graythresh(channel);
        BW = imbinarize(channel,level);
 
        mean_int_values(i) = mean(mean(double(channel).*BW));
     %   mean_int_values(i) = mean(mean(double(channel)));
        mean_area(i) = sum( sum(BW) );
end
%delete(gcp('nocreate'))
only_blue = mean_int_values(1:2:end);
only_green = mean_int_values(2:2:end);
only_blue_area = mean_area(1:2:end);
%only_green_area = mean_area(2:2:end);



counter_channel = 1;

for kk = 1 : 4: length(only_blue)
  
    val_blue(counter_channel) = mean(only_blue(kk:kk+3));
    val_green(counter_channel) = mean(only_green(kk:kk+3));
    val_blue_area(counter_channel) = mean(only_blue_area(kk:kk+3));
    counter_channel = counter_channel +1;
  
end

 ratio = val_green./val_blue;
 ratio_intensity_arae = val_green./val_blue_area *100;
 heatmap = reshape(val_green,24,16);
 figure; imagesc(heatmap');
 yticklabels={'B','D','F','H','J','L','N','P'};
 set(gca,'ytick',[2     4     6     8    10    12    14    16],'yticklabel',yticklabels);
 colorbar;
 title(['Green Mean Intensity Plate ' strImPath], 'Interpreter', 'none');
 saveas( gcf, strImPath, 'png' );
 xlswrite(strcat(strImPath, '/values.xls'),[val_green' , val_blue' , ratio' , val_blue_area' ,ratio_intensity_arae' ]);
 save(strImPath);
