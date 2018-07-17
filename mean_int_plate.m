clear all;

strImPath=  'I:\KristinaAirich_384Well_Screen_Plate_4_0207182044_1';
 
% get all the tif file in the folder
cellFiles = dir([strImPath '/*.tif']);
cellFiles={cellFiles.name};
 
mean_int_values= zeros(numel(cellFiles));  %This is the variable with the intensities

for i = 1 : 2 : numel(cellFiles)
    i
      
        blue_channel =  imread(fullfile(strImPath, cellFiles{i}), 'tif');
        green_channel = imread(fullfile(strImPath, cellFiles{i+1}), 'tif');
    
        mean_int_b = mean(mean(blue_channel))
        mean_int_g = mean(mean(green_channel))
        
        mean_int_values(i) = mean_int_b;
        mean_int_values(i+1) = mean_int_g;
        
end

for kk = 1 : 4: length()
   
    val_blue = mean(blue(kk:kk+3));
    
    val_green = mean(green(kk:kk+3));
    
    ratio = val_green/val_blue;
end
