
% RGB2LCH Convert RGB colors to LCH format
% Author: Timothy Sipkens
% Data:   September 30, 2019
%=========================================================================%
function [lch] = rgb2lch(rgb)

lab = rgb2lab(rgb);
l = lab(:,1);
a = lab(:,2);
b = lab(:,3);

h = atan2(b,a);
if h<0; h = h + (2 * pi); end
c = sqrt(a.^2 + b.^2);
lch = [l,c,h];

end

