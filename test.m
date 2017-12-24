clc;
close all;

% create input array of images
input_array = cell(50,1);

% read all the images
for i=0:49
    input_array{i+1} = imread(['/Users/apple/Documents/Matlab/images/' num2str(i) '.jpg']);
end

%output_array = bg_remove(input_array);
output_array = GMM(input_array);