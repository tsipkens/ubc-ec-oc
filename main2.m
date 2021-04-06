
clear;
close all;
clc;

addpath cmap;

load('data/feb21.mat');


% Reformat and transform data.
data0 = data;
data_a = [[data0(:,1); data0(:,2); data0(:,3)], ...
    [data0(:,4); data0(:,5); data0(:,6)], ...
    [data0(:,7); data0(:,8); data0(:,9)], ...
    repmat(data0(:,10), [3,1]), ...
    repmat(data0(:,11), [3,1])];
data_b = [10.^mean(log10([data0(:,1), data0(:,2), data0(:,3)]), 2), ...
    10.^mean(log10([data0(:,4), data0(:,5), data0(:,6)]), 2), ...
    10.^mean(log10([data0(:,7), data0(:,8), data0(:,9)]), 2), ...
    data0(:,10), ...
    data0(:,11)];


% Alternative color spaces and EC/OC assignment.
data = data_a;


%-- Remove high OC, which throws some results off. -----%
f_high_oc = data(:, end-1) > 150;
data = data(~f_high_oc, :);

% f_high_ec = data(:, end) > 25;
% data = data(~f_high_ec, :);

oc = data(:, end-1);  % assign EC and OC
ec = data(:, end);
%-------------------------------------------------------%


rgb = [data(:,1), ...
    data(:,2), ...
    data(:,3)] ./ 255;
lch = tools.rgb2lch(rgb);
lab = tools.rgb2lab(rgb);
hsv = rgb2hsv(rgb);


% Set up data.
% b = log10(oc);  disp('OC');
% Lb =  diag(ones(size(b)) ./ 0.2);

b = oc;  disp('[ Running for <strong>OC</strong> ]');
Lb =  diag(ones(size(b)) ./ 9);

% b = ec;  disp('[ Running for <strong>EC</strong> ]');
% Lb =  diag(ones(size(b)) ./ 6);


%-- Consdier multiple models ----------%
A0 = [ones(size(rgb,1), 1), ...
    rgb, ...
    lab(:, :), ...
    hsv(:, 1:2), ...
    lch(:, 2:3), ...
    lab(:,2) ./ lab(:,3), ... 
    lab(:, :) .^ 2, ...
    lch(:, 2) .^ 2];
fields = {'Const', ...
    'R', 'G', 'B', ...
    'L', 'a', 'b', ...
    'ha', 's', ... 
    'C', 'hb', ...
    'a_b', ...
    'L2', 'a2', 'b2', ...
    'C2'};

model_vec = { ...
    1:4, ...
    [1:7, 9:14], ...
    [1, 5:7, 9:14] , ...
    1:5, ...
    [1:7], ...
    ...
    };


model_vec0 = tools.num2binarray(1:(2 ^ (size(A0, 2)-1) - 1));
model_vec0 = [ ...
    true(size(model_vec0, 1), 1), ...
    model_vec0];
model_vec = num2cell(model_vec0, 2);


% figure(1);
% plot([-5, 40], [-5, 40], 'k--');
% cmap_sweep(length(model_vec), dense)
% hold on;
% msize = 3;

disp(' ');
disp(' Running potential models:');
tools.textbar([0, length(model_vec)])
for ii=1:length(model_vec)
    
    %{
    disp(['<strong>[ CASE ', num2str(ii), ...
        ' ]</strong>']);
    disp([' ', fields{model_vec{ii}}]);
    %}
    
    Aii = A0(:, model_vec{ii});
    xii = (Lb * Aii) \ (Lb * b);
    bii = Aii * xii;
    
    Sx_inv = ((Lb * Aii)' * Lb * Aii);
    % Lc = chol(Sc_inv);
    
    Sx = inv(Sx_inv);
    
    % Metrics
    Cii(ii) = -log(sqrt(det(Sx)));
    Rii(ii) = corr(b, bii);
    Fbii(ii) = norm(Lb * (b - bii)) .^ 2;
    
    Bii(ii) = -1 ./ 2 .* Fbii(ii) + Cii(ii);
    
    %{
    plot(b, bii, 'o', ...
        'MarkerSize', msize);
    
    disp(' ');
    disp(' ');
    %}
    
    tools.textbar([ii, length(model_vec)]);
    
end
% hold off;

disp(' Complete.');
disp(' ');


Bi0 = (Bii - Bii(1));

%{
figure(1);
plot(Bi0, '.');
%}

[p, anova_cell] = anovan( ...
    Bi0', num2cell(model_vec0(:,2:end)', 2), ...
    'varnames', fields(2:end), ...
    'display', 'off');

anova_tbl = sortrows( ...
    cell2table([anova_cell(2:(end-2), 6), num2cell(p)], ...
    'VariableNames', [anova_cell(1, 6), 'p-values'], ...
    'RowNames', {anova_cell{2:(end-2), 1}}'), ...
    [1,2], {'descend', 'ascend'})




%%
%-- Evaluate best model -----------%
[~, idx] = max(Bi0);

Ai = A0(:, model_vec{idx});
xi = (Lb * Ai) \ (Lb * b);
bi = Ai * xi;

figure(3);
plot(b, bi, '.');
hold on;
plot([floor(min(b)), ceil(max(b))], ...
    [floor(min(b)), ceil(max(b))], 'k--');
hold off;
xlabel('Observed');
ylabel('Predicted');

corr(bi, b)

model_struct = cell2struct(num2cell(xi), fields(model_vec{idx}));

disp('Selected model: ');
disp('  ');
disp(model_struct);
disp(' ');



% Plot of Bayes factor and correlation.
% Dark is 1, light is ~15 parameters.
cm = inferno(size(A0, 2) + 1);
figure(4);
scatter(1 - Rii, Bi0, 3, ...
    cm(sum(model_vec0, 2), :), 'filled');
set(gca, 'XScale', 'log');
alpha(0.5);
xlabel('Proximity of unity correlation, 1 - R');
ylabel('Bayes factor');
colormap(cm);
colorbar; caxis([1, size(A0, 2) + 2]);



sig_est = std(b - bi)



%{
figure(5);
cm5 = viridis(4);
scatter(1 - Rii, Bi0, 3, ...
    cm5(2.*model_vec0(:,4)+1, :), 'filled');
set(gca, 'XScale', 'log');
alpha(0.5);
%}


