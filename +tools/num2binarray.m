
% NUM2BINARRAY Convert a number to a logical array representing the binary.
%  Author: Timothy Sipkens, 2021-03-09


function [f] = num2binarray(n, a)

if ~exist('a', 'var'); a = []; end
if isempty(a); a = ceil(log2(max(n) + 1)); end

f0 = dec2bin(n, a);

f = false(size(f0));
for ii = 1:size(f0,2)
    f(:, ii) = logical(str2num(f0(:, ii)));
end

end

