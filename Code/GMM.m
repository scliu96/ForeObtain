function [ output_array ] = GMM( input_array )
%GMM Summary of this function goes here
%   Detailed explanation goes here

N = length(input_array);
output_array = cell(N, 1);
I = input_array{1};
[row, column] = size(I);

foreground = zeros(row, column);
background = zeros(row, column);

C = 3;
M = 5;
D = 2.5;
alpha = 0.01;
thresh = 0.25;
sd_init = 15;
w = zeros(row, column, C);
mean = zeros(row, column, C);
sd = zeros(row, column, C);
u_diff = zeros(row, column, C);
p = alpha / (1/C);
rank = zeros(1, C);

pixel_depth = 8;
pixel_range = 2^pixel_depth - 1;
for i = 1:row
    for j = 1:column
        for k = 1:C
            mean(i, j, k) = rand * pixel_range;
            w(i, j, k) = 1/C;
            sd(i, j, k) = sd_init;
        end
    end
end

for n = 1:N
    I = input_array{n};
    for m = 1:C
        u_diff(:, :, m) = abs(double(I(:, :))-double(mean(:, :, m)));
    end
    for i = 1:row
        for j = 1:column
            match = 0;
            for k = 1:C
                if(abs(u_diff(i, j, k)) <= D * sd(i, j, k))
                    match = 1;
                    w(i, j, k) = (1 - alpha) * w(i, j, k) + alpha;
                    p = alpha / w(i, j, k);
                    mean(i, j, k) = (1 - p) * mean(i, j, k) + p * double(I(i, j));
                    sd(i, j, k) = sqrt((1 - p)*(sd(i, j, k)^2)) + p * ((double(I(i, j)) - mean(i, j, k)))^2;
                else
                    w(i, j, k) = (1 - alpha) * w(i, j, k);
                end
            end
            background(i, j) = 0;
            for k = 1:C
                background(i, j) = background(i, j) + mean(i, j, k)*w(i, j, k);
            end
            if(match == 0)
                [min_w, min_w_index] = min(w(i, j, :));
                mean(i, j, min_w_index) = double(I(i, j));
                sd(i, j, min_w_index) = sd_init;
            end
            rank = w(i, j, :) ./ sd(i, j, :);
            rank_ind = [1:1:C];
            foreground(i, j) = 0;
            while ((match == 0)&&(k <= C))
                if(abs(u_diff(i, j, rank_ind(k))) <= D*sd(i, j, rank_ind(k)))
                    foreground(i, j) = 0;
                else 
                    foreground(i, j) = 255;
                end
                k = k + 1;
            end
        end
    end
    figure(n)
        subplot(1,3,1),imshow(foreground);
        subplot(1,3,2),imshow(background);
        disk = strel('disk', 1);
        disk1 = strel('disk', 4);
        subplot(1,3,3),imshow(imdilate(imerode(foreground,disk),disk1));
    

end

