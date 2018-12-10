function segMap = meanshift(image,face,bandwidth)
% bandwidth = 0.1; % make this a parameter
% img = rgb2lab(image);
img = im2double(image);
% Set up the feature space where each pixel has 5 values: r, g, b, x, and y
img_y = size(img,1);
img_x = size(img,2);
x_val = ones(1,img_y)' .* (1:img_x);
y_val = ones(1,img_x) .* (1:img_y)';
img = cat(3,img, y_val/img_y); % add y values and normalize to [0,1]
img = cat(3,img, x_val/img_x); % add x values and normalize to [0,1]
% img = cat(3, img, zeros(img_y, img_x));
img_z = size(img,3);

% Run mean-shift on data
num_clusters = 0;
clusters = []; % a list of the clusters
% First we set up a linear list of all the points in the image
numpts = img_y*img_x;
freepoints = ones(1,numpts);
num_cluster_updates = [];
feature_list = reshape(img, numpts,img_z);
votes = zeros(1, numpts, 'uint16');
notDone = true;
while notDone
    % Calculate the distance from a random mean center to rest of points
    index = find(freepoints == 1);
    center = feature_list(datasample(index, 1),:);
    in_cluster = [];
    cluster_votes = zeros(1, numpts, 'uint16');
    ancien_center = -1;
    while ~converged(center, ancien_center)
    
        dist = ones(numpts,img_z) .* center;
        dist = distance(dist', feature_list');
        neighbors = find(dist < bandwidth);
        cluster_votes(neighbors) = 1;
        freepoints(neighbors) = 0;
        
        ancien_center = center;
        center = mean(feature_list(neighbors,:),1);
        in_cluster = [in_cluster, neighbors];
    end
    
    cluster_match = num_clusters + 1;
    cluster_num = 1;
    while cluster_num < num_clusters
        if bandwidth/2 > distance(center, clusters(cluster_num,:))
            cluster_match = cluster_num;
            cluster_num = num_clusters;
        else
            cluster_num = cluster_num + 1;
        end
    end

    if cluster_match == num_clusters + 1
        num_clusters = num_clusters + 1;
        num_cluster_updates(cluster_match) = 1;
        clusters(num_clusters, :) = center;
        votes(cluster_match, :) = cluster_votes;
    else
        update_count = num_cluster_updates(cluster_match) + 1;
        num_cluster_updates(cluster_match) = update_count;
        clusters(cluster_match, :) = center/update_count + (update_count-1)*clusters(cluster_match,:)/update_count;%center; % might be helpful to keep list of how many times this has been updated to calculate average of all means added. Ie each entry in clusters has the mean (a 5 tuple) and a 6th element that is the running count x of how many times it has been merged. the merge is center/x + (x-1)*clusters(cluster_match,:)/x 
        votes(cluster_match, :) = votes(cluster_match,:) + cluster_votes;
    end

    notDone = sum(freepoints == 1);
end
[a,segMap]= max(votes,[],1);
segMap = reshape(segMap,img_y, img_x);
out = label2rgb(segMap);
imshow(out);
% sum(b)
end

function dist = distance(x,y)
weight = [4,3,3,1,1]';%[10,5,8,1,1]';
% x = x .* weight;
% y = y .* weight;
% Euclidian
dist = sqrt(sum((x-y).^2));
% Taxicab/L1
% dist = sum(abs(x-y)); 

% British rail
% epsilon = 0.1;
% feat = x ./ y;
% if(all(feat-feat(1) < epsilon))
%     dist = sum(sqrt(x.^2 + y.^2));
% else
%     dist = sqrt(sum((x-y).^2));
% end
end

function con = converged(x,y)
if y == -1
    con = 0;
else
    con = distance(x,y) < 0.0001;
end
end