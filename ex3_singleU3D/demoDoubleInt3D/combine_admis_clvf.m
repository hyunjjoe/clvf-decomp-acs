function [combined, i_exclude] = combine_admis_clvf(admiss1, g1, admiss2, g2)
% Use the 2 admissible control sets to find the admissible set combination

%% Step 1: form a combined grid
grid_min = [g1.min(1); g2.min(1); g1.min(2)];
grid_max = [g1.max(1); g2.max(1); g2.max(2)]; 
pdDims = 3;               
N = [g1.N(1); g2.N(1); g2.N(2)];         % Number of grid point
g = createGrid(grid_min, grid_max, N, pdDims);

%% Step 2: Find the combined admissible sets
dim_x = size(admiss1.max, 1);
dim_y = size(admiss2.max, 1);

u1_max_expand = permute(repmat(admiss1.max,[1 1 dim_y]), [1 3 2]);
u2_max_expand = permute(repmat(admiss2.max,[1 1 dim_x]), [3 1 2]);

u1_min_expand = permute(repmat(admiss1.min,[1 1 dim_y]), [1 3 2]);
u2_min_expand = permute(repmat(admiss2.min,[1 1 dim_x]), [3 1 2]);

u_max_combine= min(u1_max_expand, u2_max_expand);
u_min_combine = max(u1_min_expand, u2_min_expand);

i_exclude = u_min_combine > u_max_combine;
i_exist =  u_min_combine <= u_max_combine;

u_max_combine(i_exclude) = 0;
u_min_combine(i_exclude) = 0;

% Calculate the total number of exclusions
num_exclusions = nnz(i_exclude);

% Calculate the total number of elements in i_exclude
total_elements = numel(i_exclude);

% Calculate the percentage of exclusions
percentage_exclusions = (num_exclusions / total_elements) * 100;

% Display the percentage
fprintf('Percentage of exclusions: %.2f%%\n', percentage_exclusions);

%% Step 3: Arrange outputs
combined = 0.5*(u_min_combine+u_max_combine);
% combined = u_max_combine;
% combined.min = u_min_combine;


num_exist = nnz(i_exist);
total = numel(i_exist);
% total = N(1)*N(2)*N(3);
perc = 100*(num_exist/total);
fprintf('Percentage of existing: %.2f%%\n', perc);


