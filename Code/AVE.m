function [ output_array ] = AVE( input_array )
%AVE Summary of this function goes here
%   Detailed explanation goes here
N = length(input_array);
output_array = cell(N, 1);

background = input_array{1};
background = imsubtract(background, background);
[row,column] = size(background);

for i = 1:row
    for j = 1:column
        pixs = linspace(0, 0, N);
        for k = 1:N
            pixs(k) = input_array{k}(i, j);
        end
        background(i, j) = mean(pixs);
    end
end

f = input_array{1};

figure
    subplot(121),imshow(f),title('');
    subplot(122),imshow(background),title('');
end

