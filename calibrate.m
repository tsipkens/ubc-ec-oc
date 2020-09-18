
% CALIBRATE  Use known reflection to calibrate measurements
% Author:    Timothy Sipkens
% Data:      October 1, 2019
%=========================================================================%
function [reflect_circle] = calibrate(rgb_sq,id,rgb_circle)

[id_int1,id_int2] = intersect(id,3:13);
reflect = 255/100.*[0,0,100,8.9,4.2,3.4,11,20.2,36.8,3.4,44.3,70.0,100,0,0];

Ar = [ones(size(rgb_sq(id_int2,1))),rgb_sq(id_int2,1),(rgb_sq(id_int2,1).^2)];
Ag = [ones(size(rgb_sq(id_int2,2))),rgb_sq(id_int2,2),(rgb_sq(id_int2,2).^2)];
Ab = [ones(size(rgb_sq(id_int2,3))),rgb_sq(id_int2,3),(rgb_sq(id_int2,3).^2)];

xr = (Ar'*Ar)\(Ar'*reflect(id_int1)');
xg = (Ag'*Ag)\(Ag'*reflect(id_int1)');
xb = (Ab'*Ab)\(Ab'*reflect(id_int1)');

% vec = logspace(0,2,100);
vec = 1:250;
A0 = [ones(size(vec));vec;vec.^2]';

%{
figure;a
plot(rgb_sq(id_int2,1),reflect(id_int1),'ro');
hold on;
plot(rgb_sq(id_int2,2),reflect(id_int1),'go');
plot(rgb_sq(id_int2,3),reflect(id_int1),'bo');
plot(vec,A0*xr,'r');
plot(vec,A0*xg,'g');
plot(vec,A0*xb,'b');
hold off;
xlabel('RGB response');
ylabel('Expected reflectance');
%}

reflect_circle = [[1,rgb_circle(1),rgb_circle(1)^2]*xr,...
    [1,rgb_circle(2),rgb_circle(2)^2]*xg,...
    [1,rgb_circle(3),rgb_circle(3)^2]*xb];


end

