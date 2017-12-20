% create input array of images
%{
input_array = cell(50,1);

% read all the images
for i=0:49
    input_array{i+1} = imread(['xxx/images/' num2str(i) '.jpg']);
end

output_array = bg_remove(input_array);

% select several frame to compare, for example, 1,11,21,31,41
for i=1:5
    subplot(2,5,i);
    imshow(input_array{1+(i-1)*10});
end
for i=1:5
    subplot(2,5,5+i);
    imshow(output_array{1+(i-1)*10});
end
%}
%iptsetpref('ImshowBorder', 'tight');
f = imread('/Users/apple/Documents/Matlab/images/0.jpg');
img = imcomplement(f);
limg = log(1+abs(double(f)));
figure
subplot(221),imshow(f),title('原图像');
subplot(222),imshow(img),title('灰度翻转');
subplot(223),imshow(f, []),title('对比度伸展');
subplot(224),imshow(limg, []),title('对数变换');

gl = histeq(f);
figure
subplot(221),imshow(f),title('原图像');
subplot(222),imhist(f),title('灰度直方图');
subplot(223),imshow(gl),title('直方图均衡化');
subplot(224),imhist(gl),title('均衡化直方图');
