
% RGB2XYZ Convert RGB colors to XYZformat
% Author: Timothy Sipkens
% Data:   September 30, 2019
% Note:   Assumes RGB is in standard format (sRGB)
%=========================================================================%

function [xyz] = rgb2xyz(rgb)

if any(any(rgb>1)); rgb = rgb./255; end
    % convert from integer to 0 to 1 scale

x = 0.4124.*rgb(:,1)+0.3576.*rgb(:,2)+0.1805.*rgb(:,3);
y = 0.2126.*rgb(:,1)+0.7152.*rgb(:,2)+0.0722.*rgb(:,3);
z = 0.0193.*rgb(:,1)+0.1192.*rgb(:,2)+0.9505.*rgb(:,3);
% https://en.wikipedia.org/wiki/SRGB

xyz = [x,y,z];

end

