%%%% Red vs Green staining %%%%

function [n,mean_int,n_pixel,intensities] =  red_vs_green( red_file, green_file)

       % Common threshold for binarization
       bin_th = 0.1;

       % Load files
       red_c = imread(red_file);
       green_c = imread(green_file);

       % Automatic Contrast adjustment 
       red_adj =imadjust(red_c);       
       green_adj =imadjust(green_c);       

       % Binarize images and compute difference
       BW_red = imbinarize(red_adj,bin_th);
       BW_green = imbinarize(green_adj,bin_th);
       difference = BW_red - BW_green;
       dif = difference>0; %Discart negative values as these represent the difference green - red.
       
       % Perform morphological operators
       % The dilation is a bit bigger to avoid over partitioning of the
       % same cells
       SE_ero = strel('rectangle',[5 5]); 
       BW_erode = imerode(dif,SE_ero);  
       SE_dil = strel('rectangle',[6 6]); 
       BW_final = imdilate(BW_erode,SE_dil);
       figure;imshow(BW_final);
     
        
       % Label cells and count them
       [L,n] = bwlabel(BW_final);
       
       % Compute mean intensity within cells
       [r,c] = find(BW_final>0);
       selected_pixels_int = [] ;
       n_pixel = length(r);
       for kk = 1 : n_pixel
           selected_pixels_int(end+1) = red_adj(r(kk),c(kk));
       end
       
       mean_int = mean(selected_pixels_int);
       %{
       % Intracells intensities
       intensities = zeros(n,1);
       for ll = 1 : n
           [loc_r,loc_c] = find(L==ll);
           for jj = 1 : length(loc_r)
               temp_stack = red_adj(loc_r(jj),loc_c(jj));
           end
           
           intensities(ll) = mean(temp_stack);
       end
       %}
end