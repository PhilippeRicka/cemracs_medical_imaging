function [p_tr] = mesh_transf(p,theta, grid, Li, j)
  
  [hatx,haty]=phi(grid,theta);
  hxm = vector2matrix(hatx,Li)*2.^j;
  hym = vector2matrix(haty,Li)*2.^j;
  
  

  p_tr = zeros(size(p));
  
  for k=1:size(p,2)
    idx = round(p(1,k));
    idy = round(p(2,k));
    p_tr(1,k) = hxm(idy,idx);
    p_tr(2,k) = hym(idy,idx);
  end
  
end
