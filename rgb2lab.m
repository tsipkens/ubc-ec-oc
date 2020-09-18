
% RGB2LAB Convert RGB colors to LAB format
% Author: Timothy Sipkens
% Data:   September 30, 2019
%=========================================================================%
function [lab] = rgb2lab(rgb)

xyz = rgb2xyz(rgb);
xr = xyz(:,1)./0.950489;
yr = xyz(:,2)./1.00;
zr = xyz(:,3)./1.088840;

f = @(t) iif(t>((6/29)^3),t.^(1/3),1/3*(29/6)^2.*t + 4/29);

L = 116.*f(yr)-16;
a = 500.*(f(xr)-f(yr));
b = 200.*(f(yr)-f(zr));
lab = [L,a,b];

end


%== IIF ==================================================================%
%   An inline 'if' function
function out = iif(cond,val_true,val_false)

out = zeros(size(cond));
out(cond) = val_true(cond);
out(~cond) = val_false(~cond);

end

