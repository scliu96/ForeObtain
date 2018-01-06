clc;
close all;

% create input array of images
input_array = cell(50,1);

% read all the images
for i=0:49
    input_array{i+1} = imread(['/Users/apple/Documents/Matlab/images/' num2str(i) '.jpg']);
end
output_array = bg_remove(input_array);
for i=1:5
    subplot(2,5,i);
    imshow(input_array{1+(i-1)*10});
end
for i=1:5
    subplot(2,5,5+i);
    imshow(output_array{1+(i-1)*10});
end