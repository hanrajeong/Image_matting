This is done for the assignment of CMPT361 course in SFU by Kangkang Yin Professor.  

It consits 2 parts implemented in Matlab:  
Part1: Green screen matting for Virtual Tourism  
Part 2: Image Blending  

For the part 1:  
1. Binary matting. 
<img width="1012" alt="binary" src="https://user-images.githubusercontent.com/87463803/185773063-abc81467-7e23-4975-b4a8-d49b34251bb8.png">

2. Non-binary matting. 
<img width="1160" alt="non-binary" src="https://user-images.githubusercontent.com/87463803/185773074-0dbb0426-8f84-4825-881b-80e510a93303.png">

For the part 2:
Blended image 1.  
![blended1](https://user-images.githubusercontent.com/87463803/185773082-55b30d2c-fe69-4e60-912e-b224071f19b7.png)
Blended image 2.  
<img width="677" alt="blended2" src="https://user-images.githubusercontent.com/87463803/185773094-5bd04fd4-2255-4edd-8469-a107f3b1fa02.png">

About the input files for each Matlab:  

For part 1.
input images
-> myself
- level 1b.png
- level 1g.png
- level 2b.png
- level 2g.png
- level 6b.png
- level 6g.png

-> background images without foreground
- bb.JPG
- gg.JPG

-> Background images to merge : castle
- bg1.PNG
- bg2.PNG
- bg3.PNG

matlab file
-> for binary map
- part1_1_Hanra_Jeong.m
-> for non-binary map
- part1_2_Hanra_Jeong.m

For part 2.

input images
- level 11.png
- level 12.png
- level 21.png
- level 22.png
- level 31.png
- level 32.png

Used mask
- mask.png

Matlab file
- part2.m

Computed result
- blended1.png
- blended2.png
- blended3.png

For part 2, extra - As the report shows, I merged part 1 and part 2, so used binary alpha map to change the background of merged images of part 2

input images
- level 11.png
- level 12.png
- level 21.png
- level 22.png
- level 31.png
- level 32.png

images used to generate the mask
: in order to improve the quality of mask, I used the outer software to get the foreground part and then converted it with the matlab code that I made : mask_generate.m
After that, I used powerpoint to generate the mask

- 1.png
- 2.png
- 3.png
- 4.png
- 5.png
- 6.png

Used mask
- mask1.png
- mask2.png
- mask3.png
- mask4.png
- mask5.png
- mask6.png
- mask11.png
- mask22.png
- mask33.png

Matlab file
- Blend_with_bg.m
- mask_generate.m

Computed result
- blended_with_mask1.png
- blended_with_mask2.png
- blended_with_mask3.png

