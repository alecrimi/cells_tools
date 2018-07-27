
% Assume starting from current directory
files = dir;   
filenames = {files.name};
subdirs = filenames([files.isdir]);
subdirs(1:2) =  [];


% Iterate for each folder
for kk = 1 : length(subdirs)
    
    current_folder = string(subdirs(kk))
    
    mean_int_plate(current_folder,1);
    
end
