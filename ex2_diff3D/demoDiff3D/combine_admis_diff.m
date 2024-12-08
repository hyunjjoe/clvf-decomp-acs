function result = combine_admis_clvf(admiss1, g1, admiss2, g2)
% Use the 2 admissible control sets to find the admissible set combination

%% Step 1: form a combined grid
grid_min = [g1.min(1); g2.min(1); g1.min(2)];
grid_max = [g1.max(1); g2.max(1); g2.max(2)];              
N = [g1.N(1); g2.N(1); g2.N(2)];         % Number of grid point
g = createGrid(grid_min, grid_max, N);

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

% Calculate the total number of exclusions
num_exclusions = nnz(i_exclude);

% Calculate the total number of elements in i_exclude
total_elements = numel(i_exclude);

% Calculate the percentage of exclusions
percentage_exclusions = (num_exclusions / total_elements) * 100;

% Display the percentage
fprintf('Percentage of exclusions: %.2f%%\n', percentage_exclusions);

result = 0.5*(u_min_combine+u_max_combine);
sameBounds = u_min_combine == u_max_combine;
result(sameBounds) = u_min_combine(sameBounds);
boundsAverageZero = -u_min_combine == u_max_combine;
result(boundsAverageZero) = 1e-3;
result(i_exclude) = 0;

%% Step 3: Arrange outputs

num_exist = nnz(result);
total = numel(result);
perc = 100*(num_exist/total);
fprintf('Percentage of existing: %.2f%%\n', perc);


