% Assignment 1, 2.2
% Develop a basic algorithm that separates the foreground (i.e., you) from the uniform-colored background, 
% and generates a binary alpha map. Compose yourself with the scene photos.

% Hanra Jeong
% 301449735

clear;
clc;

% import the images
list1 = {'1b.JPG', '2b.JPG', '6b.JPG'};

list2 = {'1g.JPG','2g.JPG', '6g.JPG'};

bg_list = {'bg1.png', 'bg2.png', 'bg3.png'};

for i = 1:3
    % For calling the image by the name of the array above,
    % got the idea from https://www.mathworks.com/matlabcentral/answers/236725-i-want-to-display-image-from-cell-array
    image_1 = list1(i);
    image_2 = list2(i);

    image_1 = cell2mat(image_1);
    image_2 = cell2mat(image_2);

    img_1 = imread(image_1);
    img_1 = im2double(img_1);

    img_2 = imread(image_2);
    img_2 = im2double(img_2);

    [a, b, ~] = size(img_1);
    img_2 = imresize(img_2, [a b]);

    % To get the RGB values of the chosen(input) images
    Rimg_R = img_1(:,:,1);
    Rimg_G = img_1(:,:,2);
    Rimg_B = img_1(:,:,3);

    Bimg_R = img_2(:,:,1);
    Bimg_G = img_2(:,:,2);
    Bimg_B = img_2(:,:,3);
    

    % To get the RGB values of the background images for each inputs
    Bbg = imread('gg.JPG');
    Bbg = imresize(Bbg, [a b]);
    Bbg = im2double(Bbg);
    Bbg_R = Bbg(:,:,1);
    Bbg_G = Bbg(:,:,2);
    Bbg_B = Bbg(:,:,3);

    Rbg = imread('bb.JPG');
    Rbg = imresize(Rbg, [a b]);
    Rbg = im2double(Rbg);
    Rbg_R = Rbg(:,:,1);
    Rbg_G = Rbg(:,:,2);
    Rbg_B = Rbg(:,:,3);


    j = 1;
    % merging the chosen background with the computed images
    for back = bg_list
        back = cell2mat(back);
        background = imread(back);
        background = imresize(background, [a b]);
        background = im2double(background);
        % compute the image by triangularity
        % The idea comes from the below
        % Smith, A. R., & Blinn, J. F. (1996). Blue screen matting. Proceedings of the 23rd Annual Conference on Computer Graphics and Interactive Techniques - SIGGRAPH ’96. https://doi.org/10.1145/237170.237263
        alpha = ((Rimg_R - Bimg_R).*(Rbg_R - Bbg_R) + (Rimg_G - Bimg_G).*(Rbg_G - Bbg_G) + (Rimg_B - Bimg_B).*(Rbg_B - Bbg_B))./((Rbg_R - Bbg_R).^2 + (Rbg_G - Bbg_G).^2 + (Rbg_B - Bbg_B).^2);
        [n, m] = size(alpha);

        % the foreground image can also have the similar RGB values with the background images, and on the other hand, 
        % since this generates non-binary alpha map, it caused transparency of foreground image, lowering its image resolution. 
        % To minimize this, the following code is used which emphasize the alpha value of pixel if it has the value that is larger than 0.8.

        for p = 1:n
            for q = 1:m
                if(1-alpha(p,q)>0.8)
                    alpha(p,q) = 0.6 * alpha(p,q);
                end
            end
        end

        mask = repmat(alpha, [1 1 3]);

        % generating the merged image with the background
        overlayed = (1-alpha).*img_1 + alpha.*background;

        result = ([img_1,img_2,mask,background,overlayed]);

        % https://www.mathworks.com/matlabcentral/answers/115539-how-to-save-write-images-using-for-loop
        % store the information
        imwrite(result, strcat('non_binary_',num2str(i),num2str(j),'.png'));
        j=j+1;
    end
end