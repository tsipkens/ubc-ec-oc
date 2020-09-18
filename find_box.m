

% FIND_BOX  Find the outlier of the template
% Author:   Timothy Sipkens
% Data:     September 30, 2019
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

