function hist_cell_count

%Load file
[FileNames,PathName] = uigetfile('*.csv','Select the stack you want to process','MultiSelect','on');

% Check if the selected files are more than 1
if (iscell(FileNames))
    n_files = length(FileNames);
else
    n_files = 1 ;
end

barr_data = zeros(n_files,10);

for ff = 1 : n_files
    % Select initial point for ROI    
    if (n_files > 1)
        data_exp = csvread([PathName cell2mat(FileNames(ff))]);
    else
        data_exp = csvread(FileNames);
    end
    [count, centers] = hist(data_exp(:,1));
    barr_data(ff,:) = count;
end

boxplot(barr_data);
xlabel('Interval Depth in \mum') % x-axis label
ylabel('Number of cells') % y-axis label
