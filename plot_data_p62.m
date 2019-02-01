function plot_data_p62(filename)
 
%data = csvread(filename);
fid = fopen(filename, 'rt');  %the 't' is important!
stream = textscan(fid,'%f%f','HeaderLines',0,'Delimiter',',','EndOfLine','\r\n','ReturnOnError',false);
fclose(fid); 
data_averaged = cell2mat(stream(:,1:2));

%{
% Average per well
data_averaged = zeros(length(data)/2,5);
result_count = 1;
for jj = 1 : 2:  length(data)
    data_averaged(result_count,:)  = mean( data(jj:jj+1,:)  );
    result_count = result_count +1;
end
%}
% The convetion is to have 
% in the first column Cell count
% in the second column Norm Cell Count
% in the thid column Mean intensity 
% in the fourth column Area
% in the fifth column Green Cell count
 
n_inclusions = data_averaged(:,1);
mean_int = data_averaged(:,2);
 
plot_heatmap(n_inclusions, 'Count of inclusions');
plot_heatmap(mean_int, 'Avg Intensity'); 
