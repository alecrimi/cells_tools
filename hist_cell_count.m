%function hist_cell_count

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

figure;
A = [100: 165:1650];
boxplot(barr_data,A);
hold on
[n1 n2]=size(barr_data);
plot(ones(n1,1)*[1:length(barr_data)],barr_data,'r*')
hold off
xlabel('Interval Depth in \mum') % x-axis label
ylabel('Number of cells') % y-axis label
