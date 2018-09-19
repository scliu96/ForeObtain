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
disk1 = strel('disk', 5);
disk2 = strel('disk', 2);
threhold = 15;

mid_array = cell(50,1);
for k = 1:N
    mid_array{k} = medfilt2(input_array{k}, [5,5]);
end

bgmode = background;
for i = 1:row
    for j = 1:column
        pixs = linspace(0, 0, N);
        for k = 1:N
            pixs(k) = mid_array{k}(i, j);
        end
        bgmode(i, j) = mode(pixs);
    end
end
close_mode = imclose(bgmode, disk1);

for k = 1:N
    select_img = mid_array{k};
    close_img = imclose(select_img, disk1);
    judge = background;
    for i = 1:row
        for j = 1:column
            if abs(double(close_img(i, j)) - double(close_mode(i, j))) < threhold
                judge(i, j) = 255;
            else 
                judge(i, j) = 0;
            end
        end
    end
    judge = imclose(judge, disk2);      
    
    output_array{k} = input_array{k};
    for i = 1:row
        for j = 1:column
            if judge(i, j) == 255
                output_array{k}(i, j) = 0;
            end
        end
    end    
end

end

