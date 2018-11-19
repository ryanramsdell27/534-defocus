function depthMap = segment(image,face)
image = imresize(image, [300 NaN]);

img = double(image);%rgb2lab(image);
% compute k-means segmentation on the image
k = 10;
img_y = size(img,1);
img_x = size(img,2);

x_val = ones(1,img_y)' .* (1:img_x);
y_val = ones(1,img_x) .* (1:img_y)';
img = cat(3,img, y_val);
img = cat(3,img, x_val);
img_z = size(img,3);

img_size = numel(img);
centroid_index = randperm(img_y*img_x, k);
centroids = zeros(img_z, k);
for z = 1:k
    [u,v,w] = ind2sub(size(img), centroid_index(z));
    center = img(u,v,:);
    center = squeeze(center);
    centroids(:,z) = center;
end
feature_dist = zeros(img_y, img_x,k);

for iter = 1:10
for y = 1:img_y
    for x = 1:img_x
        pt = img(y,x,:);
        pt = squeeze(pt);%reshape(pt,1,5);
        for z = 1:k
            center = centroids(:,z);
            feature_dist(y,x,z) = distance(pt, center);
        end
    end
end
[MinDist, Index] = min(feature_dist,[],3);
for z = 1:k
    [u,v] = find(Index==z);
    centroid = zeros(img_z,1);
    for i = 1:numel(u)
        centroid = centroid + squeeze(img(u(i),v(i),:));
    end
    centroid = centroid / numel(u);
    centroids(:,z) = centroid;    
end
end
[A,I] = min(feature_dist, [], 3);
depthMap = I;


% red = image(:,:,1);
% green = image(:,:,2);
% blue = image(:,:,3);
% depthMap = red;
%plot3(red, green,blue, '.b');
% for each pixel scan image to find any pixel within a distance d in the
% n-dimensional feature space, keeping a vector of dimension n that is
% just the sum of the value of the inliers and an integer that indicates
% the number of inliers. Once the scan is done compute the mean and repeat
% with this new feature vector as the input point until the distance
% between interations is less than some value epsilon
% epsilon = 2;
% d = 12;
% [img_x, img_y] = size(red);
% imshow(image);
% for x_comp = 1:img_x
%     for y_comp = 1:img_y
%         % looking at point x,y
%         pt_comp = uint16([x_comp, y_comp, red(x_comp,y_comp), green(x_comp, y_comp), blue(x_comp, y_comp)]);
%         % begin scan over whole image
%         feature_mean = uint16(zeros(1,5));
%         num_inliers = 0;
%         for x = 1:img_x
%             for y = 1:img_y
%                 pt = uint16([x,y,red(x,y), green(x,y), blue(x,y)]);
%                 if(distance(pt, pt_comp) <= d)
%                     feature_mean = feature_mean + pt;
%                     num_inliers = num_inliers + 1;
%                 end
%             end
%         end
%         feature_mean = feature_mean ./ num_inliers
%     end
% end

end

function dist = distance(x,y)
% Euclidian
% dist = sqrt(sum((x-y).^2));
% Taxicab/L1
% dist = sum(abs(x-y)); 

% British rail
epsilon = 0.1;
feat = x ./ y;
if(all(feat-feat(1) < epsilon))
    dist = sum(sqrt(x.^2 + y.^2));
else
    dist = sqrt(sum((x-y).^2));
end
end

