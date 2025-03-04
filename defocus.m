function img_out = defocus(img,img_depth, max_blur, focal_plane)
%Defocus an image
%   Uses depth map to calculate amount of defocus. Assumes an 8bit depth
%   map.

fg = min(min(img_depth));
bg = max(max(img_depth));
img_out = uint16(zeros(size(img)));
for depth = bg:-1:fg
    mask = double(img_depth == depth);%(img_depth<depth)-(img_depth>=depth-32));
    mask = imgaussfilt(mask, max_blur);
%     imshow(mask);
    composite_layer = im2uint8(im2double(img).*mask);
    sigma = distance(focal_plane, depth, bg, max_blur);
    blurred_layer = disk_blur(composite_layer, depth, focal_plane, max_blur);
%     blurred_layer = imgaussfilt(composite_layer, sigma); % implement a distance function from plane of focus
    %img_out = uint16(1-mask).*(uint16(blurred_layer) + img_out) + uint16(composite_layer);
    img_out = uint16(blurred_layer) + img_out;
end
max_val = max(max(img_out));
img_out = 255*img_out/max_val;
%img_out = imgaussfilt(uint8(img_out));
img_out = uint8(img_out);
% imshow(img_out);
end

function sigma = distance(focal_plane, depth, max_depth, max_blur)
sigma = max_blur*abs(focal_plane - double(depth))/double(max_depth) + 0.1;
end

function out = disk_blur(composite_layer, depth, focal_plane, max_blur)
diameter = abs(double(focal_plane) - double(depth))*5*max_blur/255;
kern = gen_kern(diameter);
out = conv2(composite_layer, kern, 'same');
end