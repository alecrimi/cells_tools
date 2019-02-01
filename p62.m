%%%% p62 inlcusions %%%%

function [n_inclusions,mean_int] =  p62( blue_file, green_file)

       % Common threshold for binarization
       %bin_th = 0.1; 
       multiplier = 5000; 

       % Load files
       blue = imread(blue_file);
       green = imread(green_file);
   
       background_green = imopen(green,strel('disk',15));
       green_c = green ./ background_green*multiplier;
       % A_c = medfilt2(A_c);
       green_cc = imadjust(green_c);
       level = graythresh(green_cc);
       green_bin = imbinarize(green_cc,level);
       % figure; imagesc(A_bin); 
       L = bwlabel(green_bin);
       n_inclusions = max(max(L));
       mean_int = mean(mean(green));
       %{
       % Think about something for the BG subtraction
       level = graythresh(blue);
       BW_blue = imbinarize(blue,level);
       D = -bwdist(~BW_blue);
     %  Ld = watershed(D);
  %     bw2 = BW_blue;
  %     bw2(Ld==0) = 0;
       mask = imextendedmin(D,2);
       D2 = imimposemin(D,mask);
       Ld2 = watershed(D2);
       bw3 = BW_blue;
       bw3(Ld2==0) = 0;
       bw4 = imopen(bw3, ones(5,5)); 
       %bw5 = imclose(bw4, ones(5,5)); 
     %   figure; imagesc(bw4);
       labeled = bwlabel(bw4);
       number_nuclei = max(max(labeled));
       
       n_inclusions = n_inclusions / number_nuclei;
       mean_int = mean_int / number_nuclei;
    %}   
       %{
       threshold_artFX = 150000;
     %  if (maxvalue < threshold_artFX)
        if (1)
           difference = BW_red - BW_green;
           dif = difference>0; %Discart negative values as these represent the difference green - red.
 %          figure; imagesc(dif)

           % Perform morphological operators
           % The dilation is a bit bigger to avoid over partitioning of the
           % same cells
           SE_ero = strel('rectangle',[1 1]); 
           BW_erode = imerode(dif,SE_ero);  
           SE_dil = strel('rectangle',[1 1]); 
           BW_final = imdilate(BW_erode,SE_dil);
       %    figure;imagesc(BW_final);

           % Label cells and count them
           [L,n] = bwlabel(BW_final);
   %       figure;imagesc(L);

           % Compute mean intensity within cells
           [r,c] = find(BW_final>0);

           % If no pixels left set every features to zero
           if r >0 
                    selected_pixels_int = [] ;
                    n_pixel = length(r);
                    % Normalize the total count of pixels 
                    n_pixel =  n_pixel / n;

                    for kk = 1 : n_pixel
                        selected_pixels_int(end+1) = red_adj(r(kk),c(kk));
                    end
                    mean_int = mean(selected_pixels_int);

                    % Intracells intensities
                    intensities = 0;
           %{
           intensities = zeros(n,1);
           for ll = 1 : n
               [loc_r,loc_c] = find(L==ll);
               for jj = 1 : length(loc_r)
                   temp_stack = red_adj(loc_r(jj),loc_c(jj));
               end
               intensities(ll) = mean(temp_stack);
           end
           %}

                   % Normalize the number of detected cells over the number of cells in
                   % the Green Channel
                   [L_green,n_green] = bwlabel(BW_green);
                   n_norm = n / n_green;
           else
                n = 0;
                mean_int = 0;
                n_pixel = 0;
                n_norm = 0;
                n_green = 0;
                intensities = 0;
           end
       else
           disp('Warning, artefact present')
           n  = NaN ;
           n_norm  = NaN ;
           mean_int  = NaN ;
           n_pixel = NaN ;
           n_green = NaN ;
           intensities = NaN ;
       end
       %}
end
