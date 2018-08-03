function [new_VER] = flip_mesh(VER)

% flips upside-down a set of points in the plane
  
  new_VER = VER;
  new_VER(2,:) = -VER(2,:) + min(VER(2,:)) + max(VER(2,:));

end
