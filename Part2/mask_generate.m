clc;
clear;

% This code is generally for the extra work, to combine the part 1 and part
% 2. All the ideas come from part 1, generate the mask and then manipulate
% it to be adopted for part 2, by power point.
image_list = {'5.png','6.png','3.png','4.png','1.png','2.png'};
original_image = {'level1_1.png', 'level1_2.png','level2_2.png', 'level2_1.png', 'level3_1.png','level3_1.png'};
size_list = [0,0,0,0,0,0];

i= 1;

% Read the images from the file
% this image already doesn't have the background
% I cut it off by the outer software, https://www.remove.bg
for original = original_image
    original = cell2mat(original);
    ori = imread(original);
    ori = im2double(ori);
    [a, b, ~] = size(ori);
    size_list(i) = a;
    size_list(i+1) =b;
    i=i+2;
end
j=1;
aa=1;
for image = image_list
    image = cell2mat(image);
    img = imread(image);
    
    n = size_list(j);
    m = size_list(j+1);
    img = imresize(img, [n,m]);
    % making the mask
    mask = zeros([n, m]);
    % and then if the input image doesn't have the value (meaning, since
    % this image is already cut with it's background), if it is cut part,
    % make the mask for it
    j=j+2;
    for p = 1:n
        for q = 1:m
            if(img(p, q)==0)
                mask(p, q) = 1;
            end
        end
    end
    
    kern = strel('disk', 1);
    % To delete the noise
    mask = imerode(mask,kern);
    % To feel the hole in order to delte the noise one more time
    mask = imfill(mask, 'holes'); 
    % make the mask opposite, to make the human remain
    mask = imcomplement(mask);
    % Save the computed mask
    imwrite(mask, strcat('mask',num2str(aa),'.png'));
    aa = aa+1;
end