% RG_all

list = dir('*.tif');

results = zeros(length(list)/2,5);
result_count = 1;
 
for kk = 1 : 2:  length(list)
    
    % [n, mean_int, n_pixel, intensities] = 
    [n, n_norm, mean_int, n_pixel, intensities] =  red_vs_green( list(kk+1).name, list(kk).name);
    
    results(result_count,1)  = n;
    results(result_count,2)  = n_norm;
    results(result_count,3)  = mean_int;
    results(result_count,4)  = n_pixel;
    results(result_count,5)  = n_green;
    results(result_count,6)  = intensities;
    
    result_count = result_count +1
    
end

% Save the original features
csvwrite('results_feautes.csv',results);
  
% Average per well field
results_averaged = zeros(length(list)/4,5);
result_count = 1;
for jj = 1 : 2:  length(list)/2
    results_averaged(result_count,:)  = mean( results(jj:jj+1,:)  );
    result_count = result_count +1;
end

count_letters = 0;
plate_list = strings(24*16,1);
for array = char(double('A'):double('P')) % create character array from 'A' to 'Z'
    for num = 1 : 24
        plate_list(count_letters+num) =  strcat(array,num2str(num)); 
    end
    count_letters = count_letters +24;
end 
 
results_averaged = num2cell(results_averaged);
tot_feat = [ results_averaged plate_list];

% Save the average features
%csvwrite('avg_results_features.csv',results_averaged);
fid = fopen('avg_results_features.csv','wt');
if fid>0
     fprintf(fid,'CellCount,NormCellCount,MeanInt,Area,GreenCellCount,Well\n');
     for k=1:size(tot_feat,1)
         fprintf(fid,'%s,%s,%s,%s,%s,%s\n',tot_feat{k,:}); %%
     end
     fclose(fid);
end

% Plot and save averaged heatmaps
plot_data('avg_results_features.csv')

%{
% Compute data per well
tot_untreated = [];% zeros(192,5);
tot_siRNAGFP = [];% zeros(96,5);
tot_siRNALV = [];% zeros(96,5);
for ll = 1 : 24 : length(results_averaged)
  
    % Compute mean untreated
    untreated = [ results_averaged( ll: ll+10 -1,:) ; results_averaged(ll+23-1:ll+24-1,:)  ] ;
    
    % Compute siRNA GFP
    siRNAGFP = results_averaged(ll+11-1:ll+16-1,:) ;     
    
    % Compute siRNA live dead
    siRNALV = results_averaged(ll+17-1:ll+22-1,:);     
    
    % Pack results
    tot_untreated(end+1:end+12,: )  = untreated;
    tot_siRNAGFP( end+1:end+6,:)  = siRNAGFP;
    tot_siRNALV( end+1:end+6,:)  = siRNALV;
end
labels =  [ zeros(length(tot_untreated(:,1)), 1); ones(length(tot_siRNAGFP(:,1)), 1); 2*ones(length(tot_siRNALV(:,1)), 1)] ;
for ff = 1 : 4
    figure; boxplot([tot_untreated(:,ff) ;  tot_siRNAGFP(:,ff) ;  tot_siRNALV(:,ff)],labels );
    xticklabels({'Untreated' , 'siRNA-GFP' , 'siRNA-LV'})
    
    hold on
       [n1,~]=size(tot_untreated(:,ff));
       plot(ones(n1,1),tot_untreated(:,ff),'r*')
       [n1,~]=size( tot_siRNAGFP(:,ff));
       plot(2*ones(n1,1), tot_siRNAGFP(:,ff),'r*')
       [n1,~]=size( tot_siRNALV(:,ff));
       plot(3*ones(n1,1), tot_siRNALV(:,ff),'r*')
       
       
    hold off
    
    
end
%}
