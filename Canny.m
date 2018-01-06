function [ output ] = Canny( input )
%CANNY Summary of this function goes here
%   Detailed explanation goes here

img=input;
imshow(img);
[m,n]=size(img);
img=double(img);

%%canny边缘检测的前两步相对不复杂，所以我就直接调用系统函数了
%%高斯滤波
w=fspecial('gaussian',[5 5]);
img=imfilter(img,w,'replicate');
figure;
imshow(uint8(img))

%%sobel边缘检测
w=fspecial('sobel');
img_w=imfilter(img,w,'replicate');      %求横边缘
w=w';
img_h=imfilter(img,w,'replicate');      %求竖边缘
img=sqrt(img_w.^2+img_h.^2);        %注意这里不是简单的求平均，而是平方和在开方。我曾经好长一段时间都搞错了
figure;
imshow(uint8(img))

%%下面是非极大抑制
new_edge=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        Mx=img_w(i,j);
        My=img_h(i,j);
        
        if My~=0
            o=atan(Mx/My);      %边缘的法线弧度
        elseif My==0 && Mx>0
            o=pi/2;
        else
            o=-pi/2;            
        end
        
        %Mx处用My和img进行插值
        adds=get_coords(o);      %边缘像素法线一侧求得的两点坐标，插值需要       
        M1=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3));   %插值后得到的像素，用此像素和当前像素比较 
        adds=get_coords(o+pi);%边缘法线另一侧求得的两点坐标，插值需要
        M2=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3));   %另一侧插值得到的像素，同样和当前像素比较
        
        isbigger=(Mx*img(i,j)>M1)*(Mx*img(i,j)>=M2)+(Mx*img(i,j)<M1)*(Mx*img(i,j)<=M2); %如果当前点比两边点都大置1
        
        if isbigger
           new_edge(i,j)=img(i,j); 
        end        
    end
end
figure;
imshow(uint8(new_edge))

%%下面是滞后阈值处理
up=120;     %上阈值
low=100;    %下阈值
set(0,'RecursionLimit',10000);  %设置最大递归深度
for i=1:m
    for j=1:n
      if new_edge(i,j)>up &&new_edge(i,j)~=255  %判断上阈值
            new_edge(i,j)=255;
            new_edge=connect(new_edge,i,j,low);
      end
    end
end
figure;
imshow(new_edge==255)

end

function re=get_coords(angle)       %angle是边缘法线角度，返回法线前后两点
    sigma=0.000000001;
    x1=ceil(cos(angle+pi/8)*sqrt(2)-0.5-sigma);
    y1=ceil(-sin(angle-pi/8)*sqrt(2)-0.5-sigma);
    x2=ceil(cos(angle-pi/8)*sqrt(2)-0.5-sigma);
    y2=ceil(-sin(angle-pi/8)*sqrt(2)-0.5-sigma);
    re=[x1 y1 x2 y2];

end

function nedge=connect(nedge,y,x,low)       %种子定位后的连通分析
    neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %八连通搜寻
    [m n]=size(nedge);
    for k=1:8
        yy=y+neighbour(k,1);
        xx=x+neighbour(k,2);
        if yy>=1 &&yy<=m &&xx>=1 && xx<=n  
            if nedge(yy,xx)>=low && nedge(yy,xx)~=255   %判断下阈值
                nedge(yy,xx)=255;
                nedge=connect(nedge,yy,xx,low);
            end
        end        
    end 

end

