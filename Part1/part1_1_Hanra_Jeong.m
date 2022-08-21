% Assignment 1, 2.1
% Develop a basic algorithm that separates the foreground (i.e., you) from the uniform-colored background, 
% and generates a binary alpha map. Compose yourself with the scene photos.

% Hanra Jeong
% 301449735

clear;
clc;
image_list = {'1b.JPG', '2b.JPG','6b.JPG'};

bg_list = {'bg1.png', 'bg2.png', 'bg3.png'};
k=1;
for image = image_list
    % For calling the image by the name of the array above,
    % got the idea from https://www.mathworks.com/matlabcentral/answers/236725-i-want-to-display-image-from-cell-array
    image = cell2mat(image);
    img = imread(image);

    img = im2double(img);
    hsv = rgb2hsv(img);
    % The idea to separate h, s, v 
    % code information: https://www.mathworks.com/matlabcentral/answers/248090-how-can-i-split-an-hsv-image-into-separate-h-s-v-components
    % hsv information : https://bskyvision.com/46
    hsv_h = hsv(:,:,1); % hue

    % To make the binary mask
    % find the best range of hsv hue value for blue color background
    % usually the blue color hue value ranges 0.5 ~ 0.6667
    [a, b] = size(hsv_h);
    
    bg = imread('bb.JPG');
    bg = imresize(bg, [a b]);
    backColor = bg;
    bg = im2double(bg);
    bg_hsv = rgb2hsv(bg);
    bg_h = bg_hsv(:,:,1);

    % make the same size mask initialized with 0
    mask = zeros([a, b]);
    % iterate the hue value of image, and if it blue, change it 0 to 1
    for i = 1:a
        for j = 1:b
            if(abs((hsv_h(i,j)-bg_h(i,j))/bg_h(i,j)) < 0.03)
                mask(i,j) = 1;
            end
        end
    end
    
    % from here, it is for making the mask more reliable by image
    % morphology, the idea comes from the tutorial note

    % rather than using ones(), using 'disk' shape makes the image more
    % natural
    % The code idea comes from matlab library
    % "https://www.mathworks.com/help/images/ref/strel.html"
    kern = strel('disk', 1);

    % To delete the noise
    mask = imerode(mask,kern);
    % To feel the hole in order to delte the noise one more time
    mask = imfill(mask, 'holes'); 
    % make the mask opposite, to make the human remain
    mask = imcomplement(mask);

    boxkern = ones(16);
    boxkern = boxkern/sum(boxkern(:));
    mask = imfilter(mask, boxkern);


    for i = 1:a
        for j = 1:b
            if(mask(i,j)<0.1)
                mask(i,j) = 0;
            else
                mask(i,j) = 1;
            end
        end
    end

    
    % Make the mask to be same size with the image
    mask = repmat(mask, [1 1 3]);
    % Call the background image and converge it with the masked human image
    j=1;
    for back = bg_list
        back = cell2mat(back);
        bg = imread(back);
        bg = im2double(bg);
        % this resize for making the backgroun image to be same size with
        % the computed human image
        bg = imresize(bg, [a, b]);
        % the equation is from the lecture note
        overlayed = mask.* img + (1-mask) .* bg;
        % This is for saving the result image
        result = ([img,mask,bg,overlayed]);
        imwrite(result, strcat('binary',num2str(k),num2str(j),'.png'));
        j=j+1;
    end
    k=k+1;
end