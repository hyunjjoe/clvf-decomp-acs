function V = refine_clvf(grid, initial_data, dt, u_adms, dynSys)

x = grid.xs;

xs = zeros(prod(grid.N, 'all'),3);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);
xs(:,3) = reshape(x{3}, 1, []);

u = eval_u(grid, u_adms, xs, 'cubic');
dx = dynSys.dynamics(NaN, xs, u);  
xs = xs + dx*dt;
V = reshape(eval_u(grid, initial_data, xs, 'cubic'), grid.N');
end
