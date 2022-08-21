% Assignment 1, part 2,2.1, extra work

% Hanra Jeong
% 301449735

clear;
clc;

% To read the images , list of name
image_list = {'level12.png', 'level11.png', 'level22.png', 'level21.png', 'level31.png', 'level32.png'};
mask_list = {'mask1.png', 'mask2.png', 'mask3.png', 'mask4.png', 'mask6.png', 'mask5.png'};
mask_list2 = {'mask33.png', 'mask22.png', 'mask11.png'};
% binomial kernel is used, rather than a real Gaussian kernel as given in the class.
g = (1/16).*[1, 4, 6, 4, 1];
gauskern = g'*g;

for ii=1:3
    % Read the images from the files
    image_1 = image_list(2*ii-1);
    image_2 = image_list(2*ii);

    image_1 = cell2mat(image_1);
    image_2 = cell2mat(image_2);

    img_1 = imread(image_1);
    img_1 = im2double(img_1);

    img_2 = imread(image_2);
    img_2 = im2double(img_2);


    mask_img1 = mask_list(2*ii-1);
    mask_img2 = mask_list(2*ii);

    mask_img1 = cell2mat(mask_img1);
    mask_img2 = cell2mat(mask_img2);

    mask_img1 = imread(mask_img1);
    mask_img1 = im2double(mask_img1);

    mask_img2 = imread(mask_img2);
    mask_img2 = im2double(mask_img2);
    % Manually generated the mask for merging with the background using
    % powerpoint
    % loading the background image
    mask_bg = mask_list2(ii);
    mask_bg = cell2mat(mask_bg);
    mask_bg = imread(mask_bg);
    mask_bg = im2double(mask_bg);
    
    background = imread('background.png');
    background = im2double(background);

    % if the 2 input images don't have the same size, resize the images to
    % match the size
    [a, b, ~] = size(img_1);
    [a1, b1, ~] = size(img_2);
    if(a~=a1 || b~=b1)
        img_2 = imresize(img_2, [a b]);
    end

    % compute the number of levels, compute until min resolution reached,
    % by lecture note
    levels_1 = floor(log2(a/16));
    levels_2 = floor(log2(b/16));
    levels = min(levels_1, levels_2);

    % Resize the image to get the integer values for the size on each
    % levels
    as = ceil(a/2^levels);
    bs = ceil(b/2^levels);
    a1 = as * 2^levels;
    b1 = bs * 2^levels;
    
    % Since the images that I used have the similar size, I just used
    % imresize function. if the images have very different size, then the
    % code should be modified for this, or the input images can be also
    % modified
    img_1 = imresize(img_1, [a1, b1]);
    img_2 = imresize(img_2, [a1, b1]);

    mask_img1 = imresize(mask_img1, [a1, b1]);
    mask_img2 = imresize(mask_img2, [a1, b1]);

    background = imresize(background, [a1, b1]);
    mask_bg = imresize(mask_bg, [a1, b1]);


    bionomial_kernel = (1/16).*[1, 4, 6, 4, 1];
    kern = bionomial_kernel'*bionomial_kernel; 
    % Building Gauss pyramid for 2 imput images and masks
    Gauss_1 = Gauss_Pyramid(img_1, levels, kern);
    Gauss_2 = Gauss_Pyramid(img_2, levels, kern);
    Gauss_mask1 = Gauss_Pyramid(mask_img1, levels, kern);
    Gauss_mask2 = Gauss_Pyramid(mask_img2, levels, kern);
    % Building Laplacian pyramid for 2 input images
    Lap_1 = Laplacian_Pyramid(levels, Gauss_1, kern);
    Lap_2 = Laplacian_Pyramid(levels, Gauss_2, kern);
    % Then compute the result by using the images of Gaussian pyramid of
    % mask image and the images of Laplacian pyramid of 2 input images
    computed = cell(1, levels+1);
    for i = 1:levels+1
        % merge them with the two different mask and images from the
        % Laplacian pyramid
        computed{i} = Gauss_mask1{i}.*Lap_1{i} + (Gauss_mask2{i}).*Lap_2{i};
    end
    % With this computed mask image,
    % Build the final version of blended image
    for i = levels+1 : -1 : 2
        [a, b, ~] = size(computed{i});
        a = 2*a;
        b = 2*b;
        tmp = imresize(computed{i}, 2);
        tmp = imfilter(tmp, kern, 'conv', 'same');
        [a, b, ~] = size(computed{i-1});
        computed{i-1} = computed{i-1} + tmp;
    end
    result = computed{1};
    % This obtained result is only for the foreground featrues, so need to
    % merge with the loaded background image
    % the method for doing this is same with the part 1, quesition 1, using
    % the binary alpha map
    result_bg = (1-mask_bg).*background + mask_bg .* result;
    final_result = [img_1, mask_img1, img_2, mask_img2, background, result_bg];
    imwrite(final_result, strcat('blended_with_mask',num2str(ii),'.png'));
end

% This is to build the Guass_pyramid
function Gauss = Gauss_Pyramid(image, levels, kern)
    Gauss = cell(1, levels+1);
    Gauss{1} = image;
    temp = image;
    for i = 2:levels+1
        % As mentioned on the lecture not
        % filter
        temp = imfilter(temp, kern, 'conv', 'same');
        % subsample
        temp = imresize(temp, 0.5);
        Gauss{i} = temp;
    end
end

% This is to build the laplacian pyramid
function Lap = Laplacian_Pyramid(levels, Gauss, kern)
    Lap = cell(1, levels+1);
    for i = 1:levels
        % resize
        temp = imresize(Gauss{i+1}, 2);
        % filter
        temp = imfilter(temp, kern, 'conv', 'same');
        % subtraction
        Lap{i} = Gauss{i} - temp;
    end
    Lap{levels+1} = Gauss{levels+1};
end