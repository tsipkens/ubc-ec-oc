
% DETECT  Detect components of an image with the established UBC template.
% Author: Timothy Sipkens, October 1, 2019
%=========================================================================%

function [rho] = detect(files)

f1 = figure;

rho = zeros(length(files), 3); % initialize RGB

for ii=1:length(files)
    img = imread([files(ii).folder, filesep, ...
        files(ii).name]);
    
    % Crop template from the background
    img_new = find_box(img);
    
    % Find squares on the paper
    [bb2,id,rgb_sq] = find_squares(img_new);
    
    % Find center circle and filter
    [centers, radii, radii2, rgb] = ...
        find_circles(img_new);
    
    % Calbiration results
    rho(ii,:) = calibrate(rgb_sq, id, rgb);
    
    % Show image with annotations
    plot_annotations(img_new, rgb_sq, id, bb2, rho, ...
        centers, radii, radii2);
    drawnow;
end

close(f1);

end





% CALIBRATE  Use known reflections in template to calibrate measurements
% Author: Timothy Sipkens, October 1, 2019
%=========================================================================%
function [rho] = calibrate(rgb_sq, id, rgb)

[id_int1,id_int2] = intersect(id,3:13);
reflect = 255/100.*[0,0,100,8.9,4.2,3.4,11,20.2,36.8,3.4,44.3,70.0,100,0,0];

Ar = [ones(size(rgb_sq(id_int2,1))),rgb_sq(id_int2,1),(rgb_sq(id_int2,1).^2)];
Ag = [ones(size(rgb_sq(id_int2,2))),rgb_sq(id_int2,2),(rgb_sq(id_int2,2).^2)];
Ab = [ones(size(rgb_sq(id_int2,3))),rgb_sq(id_int2,3),(rgb_sq(id_int2,3).^2)];

xr = (Ar'*Ar) \ (Ar'*reflect(id_int1)');
xg = (Ag'*Ag) \ (Ag'*reflect(id_int1)');
xb = (Ab'*Ab) \ (Ab'*reflect(id_int1)');

rho = [[1,rgb(1),rgb(1)^2]*xr,...
    [1,rgb(2),rgb(2)^2]*xg,...
    [1,rgb(3),rgb(3)^2]*xb];

end





% FIND_CIRCLES  Find the squares in the template
% Author: Timothy Sipkens, October 1, 2019
%=========================================================================%
function [centers,radii,radii2,rgb_circle] = find_circles(img)

img_size = length(img(:,1,1));
max_circle = round(img_size/4);
min_circle = round(img_size/5.8);

[centers,radii] = ...
    imfindcircles(img,[min_circle,max_circle],...
    'Sensitivity',0.982);


%-- Find new center circle and average colour ----------------%
radii2 = radii/4;

[grid_x,grid_y] = meshgrid(1:size(img,2),1:size(img,1));
dist_x = grid_x-centers(1);
dist_y = grid_y-centers(2);
in_circle = sqrt(dist_x.^2+dist_y.^2)<radii2;

img_circle = [];
for ii=3:-1:1
    t0 = img(:,:,ii);
    img_circle(:,ii) = t0(in_circle);
end
rgb_circle = mode(img_circle);


end






% FIND_BOX  Find the outlier of the template
% Author: Timothy Sipkens, September 30, 2019
%=========================================================================%
function [img_new] = find_box(img)

img_gr = rgb2gray(img); % work on gray image


%-- Find outer box on the paper -----------------------------%
img_bw = ~imbinarize(img_gr,graythresh(img));
img_fill = imfill(img_bw,'holes');
img_area = bwareaopen(img_fill,10000); % remove small objects
img_final = logical(img_area);
stat = regionprops(img_final,'boundingbox');

areas = [stat.BoundingBox]; % find item with largest area
areas = areas(3:4:end).*areas(4:4:end);
[~,ind_areas] = max(areas);

bb = stat(ind_areas).BoundingBox;
bb = round(bb);

img_new = img(bb(2):(bb(2)+bb(4)),bb(1):(bb(1)+bb(3)),:);
shrink = 20;
img_new = img_new(shrink:end-shrink,shrink:end-shrink,:);


end




% FIND_SQUARES  Find the squares in the template
% Author: Timothy Sipkens, October 1, 2019
%=========================================================================%
function [bb2,id,rgb_sq] = find_squares(img)

img_gr = rgb2gray(img);
expected_size = numel(img_gr);
expected_size = round(expected_size/770);

img_bw = ~imbinarize(img_gr,graythresh(img_gr)+0.05);
img_fill = imfill(img_bw,'holes');
img_area = bwareaopen(img_fill,expected_size);
img_final = logical(img_area);
stat = regionprops(img_final,'boundingbox');
bb = [];

for ii=length(stat):-1:1
    bb(ii,:) = round(stat(ii).BoundingBox);
end

ind_remove = and(or(isoutlier(bb(:,3)),isoutlier(bb(:,4))),...
    or(bb(:,3)>mean(bb(:,3)),bb(:,4)>mean(bb(:,4))));
bb(ind_remove,:) = []; % remove outliers with area larger than mean


%-- Sort and label squares -----------------------------%
[id_c,cent_c] = kmeans(bb(:,1),7);
[~,idx_c] = sortrows(cent_c);
[~,idx_c] = sortrows(idx_c);
id_c2 = idx_c(id_c);

[id_r,cent_r] = kmeans(bb(:,2),6);
[~,idx_r] = sortrows(cent_r);
[~,idx_r] = sortrows(idx_r);
id_r2 = idx_r(id_r);

col = [1,1,2,2,2,2,3,4,5,6,6,6,6,7,7];
row = [1,6,2,3,4,5,2,2,2,2,3,4,5,1,6];

id = zeros(size(id_c2));
for ii=1:length(id)
    t0 = find(and(id_c2(ii)==col,id_r2(ii)==row));
    if ~isempty(t0)
        id(ii) = t0;
    end
end


%-- Shrink shapes and average colour --------------------------%
shrink = 16;
bb2(:,3:4) = bb(:,3:4)-shrink;
bb2(:,1:2) = bb(:,1:2)+shrink/2;
hold on;
rgb_sq = [];
for ii=length(bb2):-1:1
    img_sq = double(img(bb2(ii,2):(bb2(ii,2)+bb2(ii,4)),...
        bb2(ii,1):(bb2(ii,1)+bb2(ii,3)),:));
    rgb_sq(ii,:) = mode(reshape(double(img_sq),...
        [size(img_sq,1)*size(img_sq,2),3]));
end
hold off;

bb2 = abs(bb2);

end



