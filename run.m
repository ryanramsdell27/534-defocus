%% Clear workspace 
fprintf('Clearing workspace\n');
clear
clc
%% Set parameters
fprintf('Setting paramters\n');
max_blur = 10;
max_width = 1000;
depth_map_sigma = 20;
ms_bandwidth = 0.2;
img_path = 'pics/3.jpg';
focal_plane = 0;
% 5.jpg : max_blur = 10; max_width = 1000; depth_map_sigma=20; ms_bandwidth=0.3; img_path = 'pics/5.jpg';
%% Load image
fprintf('Loading image\n');
img = imread(img_path);
ratio = max_width/size(img,1);
[x,y,z] = size(img);
img = imresize(img, [x,y]*ratio );

%% Find face features
fprintf('Finding face features\n');
face = [265,435];%5.jpg:[308,332];
leye = [1 1];% 5.jpg:[300,302];
reye = [1 1];% 5.jpg:[356,301];
% [face,eyepos] = detectFace(img)
%% Segment
fprintf('Segmenting image\n');
img_seg = meanshift(img, face,ms_bandwidth); % segmented image
img_lab = label2rgb(img_seg); % rgb labeled imaged for debugging
img_seg = uint8(img_seg / max(max(img_seg)) * 255); % map to uint8
se = offsetstrel('ball',2,2); % structuring element used in image erosion
img_seg = imerode(img_seg,se);

%% Generate Depth Map
fprintf('Generating depth map\n');
img_depth = generateDepth(img_seg, face, leye, reye);
img_depth = imgaussfilt(img_depth, depth_map_sigma);
% imshow(img_depth);

%% Blur
fprintf('Blurring image\n');

imgr = img(:,:,1);
imgg = img(:,:,2);
imgb = img(:,:,3);

outr = defocus(imgr, img_depth, max_blur, focal_plane);
outg = defocus(imgg, img_depth, max_blur, focal_plane);
outb = defocus(imgb, img_depth, max_blur, focal_plane);

out = im2uint8(zeros(size(img)));
out(:,:,1) = outr;
out(:,:,2) = outg;
out(:,:,3) = outb;

out = out+20;
img_d = cat(3, img_depth, img_depth, img_depth);
composite = [img, img_lab,img_d, out];
imshow(composite);
%% Clean
clear imgb imgg imgr se x y z outb outg outr ratio img_d depth_map_sigma max_blur max_width ms_bandwidth

% imwrite(out, 'render2.png');