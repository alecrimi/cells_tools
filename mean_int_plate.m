clear all;

strImPath=  'I:\KristinaAirich_384Well_Screen_Plate_4_0207182044_1';
 
% get all the tif file in the folder
cellFiles = dir([strImPath '/*.tif']);
cellFiles={cellFiles.name};
 
mean_int_values= zeros(numel(cellFiles),1);  %This is the variable with the intensities

for i = 1 : 2 : numel(cellFiles)
    i
      
        blue_channel =  imread(fullfile(strImPath, cellFiles{i}), 'tif');
        green_channel = imread(fullfile(strImPath, cellFiles{i+1}), 'tif');
    
        mean_int_b = mean(mean(blue_channel));
        mean_int_g = mean(mean(green_channel));
        
        mean_int_values(i) = mean_int_b;
        mean_int_values(i+1) = mean_int_g;
        
end

only_blue = mean_int_values(1:2:end);
only_green = mean_int_values(2:2:end);

counter_channel = 1;
for kk = 1 : 4: length(only_blue)
   
    val_blue(counter_channel) = mean(blue(kk:kk+3));
    val_green(counter_channel) = mean(green(kk:kk+3));
    counter_channel = counter_channel +1;
   
end
 ratio = val_green./val_blue;
 
 heatmap = reshape(ratio,24,16);
 figure; imagesc(heatmap');
 
 yticklabels={'B','D','F','H','J','L','N','P'};
 set(gca,'ytick',[2     4     6     8    10    12    14    16],'yticklabel',yticklabels);
 colorbar;
 title('Plate X');
 save('')
