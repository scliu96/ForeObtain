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

deviation = background;
lowThreshold = background;
highThreshold = background;
foreground = background;

[row,column] = size(background);
% N = 10;
for i = 1:row
    for j = 1:column
        pixs = linspace(0, 0, N);
        for k = 1:N
            pixs(k) = input_array{k}(i, j);
        end
        background(i, j) = mean(pixs);
        
        devi = linspace(0, 0, N-1);
        for k = 1:N-1
            devi(k) = abs(int32(input_array{k+1}(i, j)) - int32(input_array{k}(i, j)));
        end
        deviation(i, j) = double(mean(devi));
        
        lowThreshold(i, j) = background(i, j) - (deviation(i, j) + 1) * 3.0;
        highThreshold(i, j) = background(i, j) + (deviation(i, j) + 1) * 4.0;
    end
end

f = input_array{1};
for i = 1:r
    for j = 1:c
        if (f(i, j) > lowThreshold(i, j))&&(f(i, j) < highThreshold(i, j))
            foreground(i, j) = 255;
        else
            foreground(i, j) = 0;
        end
    end
end

        
H = 1/2*[0 1/4 0;
    1/4 1 1/4;
    0 1/4 0]; 

in = foreground;
out = foreground;
% 中值滤波
for i = 2:r-1
    for j = 2:c-1
        temp = double(in(i-1:i+1, j-1:j+1));
        %f1(i, j) = sum( sum(H.*temp));
        temp = sort(temp(:));
        out(i, j) = temp(5);
    end
end

figure
    subplot(221),imshow(f),title('原图像');
    subplot(222),imhist(f),title('直方图');
    subplot(223),imshow(out),title('原图像');
    subplot(224),imhist(out),title('直方图');



% figure,imshow(input_array{1});

end

