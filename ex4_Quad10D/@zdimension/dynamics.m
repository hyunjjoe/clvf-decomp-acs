function dx = dynamics(obj, t, x, u, d)

    kT = obj.kT;   
    g = obj.g; 

if iscell(x)
  dx = cell(obj.nx, 1);

   dx{1} = x{2} + d;
   dx{2} = kT*u - g;
   
else
  dx = zeros(obj.nx, 1);
  
   dx(1) = x(2) + d;
   dx(2) = kT*u - g;
end


end
