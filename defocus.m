function img_out = defocus(img,img_depth)
%Defocus an image
%   Uses depth map to calculate amount of defocus. Assumes an 8bit depth
%   map.
%fg = min(min(img_depth));
%bg = max(max(img_depth))
%img_depth = floor(double(img_depth-fg)*255.0/double(bg));
%imshow(img_depth);
fg = min(min(img_depth));
bg = max(max(img_depth));
max_blur = 10;
img_out = uint16(zeros(size(img)));
for depth = bg:-1:fg
    mask = uint8(img_depth == depth);%(img_depth<depth)-(img_depth>=depth-32));
    composite_layer = img.*mask;
    focal_plane = 0;
    sigma = distance(focal_plane, depth, bg, max_blur);
    %blurred_layer = disk_blur(composite_layer, depth, focal_plane);
    blurred_layer = imgaussfilt(composite_layer, sigma); % implement a distance function from plane of focus
    %imshow(blurred_layer);
    %img_out = uint16(1-mask).*(uint16(blurred_layer) + img_out) + uint16(composite_layer);
    img_out = uint16(blurred_layer) + img_out;
end
max_val = max(max(img_out));
img_out = 255*img_out/max_val;
%img_out = imgaussfilt(uint8(img_out));
img_out = uint8(img_out);
end

function sigma = distance(focal_plane, depth, max_depth, max_blur)
sigma = max_blur*abs(focal_plane - double(depth))/double(max_depth) + 0.1;
end

function out = disk_blur(composite_layer, depth, focal_plane)
diameter = abs(double(focal_plane) - double(depth))*50/255;
% [diameter, double(depth)];
%kern = [0 0 1 1 0 0; 0 1 1 1 1 0; 1 1 1 1 1 1; 1 1 1 1 1 1; 0 1 1 1 1 0; 0 0 1 1 0 0];
kern = gen_kern(diameter);
out = conv2(composite_layer, kern, 'same');
imshow(out);
end

function out = disk_blur2(composite_layer, depth, focal_plane)
diameter = abs(double(focal_plane) - double(depth))*50/255; % need to come up with a better mapping function
kern = gen_kern(diameter);
[img_x, img_y] = size(composite_layer);
img_x = img_x + diameter;
img_y = img_y + diameter;
out = zeros(img_y, img_x);
[x_vals,y_vals] = find(composite_layer > 0);
for i = 1:size(x_vals,1)
    x = x_vals(i);
    y = y_vals(i);
    % pad the kernel with zeros
end
end