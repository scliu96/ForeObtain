function [ output_array ] = bg_remove( input_array )
% input_array is a cell array containing a sequence of input images, the
% ith image can be visited through input_array{i}
% output_array should also be a cell array containing a sequence of processed images

% get the number of input images
N = length(input_array);

% create output_array, the ith ouput image should be stored by
% output_array{i} = ...
output_array = cell(N, 1);

%% do not modify any code above, write your code below
background = input_array{1};
background = imsubtract(background, background);
[row,column] = size(background);

disk = strel('disk', 3);


f = input_array{10};
for i = 1:row
    for j = 1:column
        if (abs(f(i, j) - background(i, j)) < 20)
            foreground(i, j) = 0;
        else
            foreground(i, j) = 255;
        end
    end
end  

figure
    subplot(221),imshow(f),title('Ô­Í¼Ïñ');
    subplot(222),imshow(foreground),title('fore');
    subplot(223),imshow(f1),title('imrode');
    subplot(224),imshow(imclose(foreground, disk)),title('imdilate');
    
    

%{
H = 1/2*[0 1/4 0;
    1/4 1 1/4;
    0 1/4 0]; 

in = foreground;
out = foreground;
% ÖÐÖµÂË²¨
for i = 2:r-1
    for j = 2:c-1
        temp = double(in(i-1:i+1, j-1:j+1));
        %f1(i, j) = sum( sum(H.*temp));
        temp = sort(temp(:));
        out(i, j) = temp(5);
    end
end
    
% figure,imshow(input_array{1});
%}
end

