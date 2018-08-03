function [] = mesh_comparison(ver1,tri1,ver2,tri2)

  if size(tri1,1) > size(tri1,2)
    tri1 = tri1';
    tri2 = tri2';
  end

  disp('L^2 distance between meshes : ')
  sqrt(sum(sum((ver1 - ver2).^2)))

  L = min(size(tri1,2),size(tri2,2));

ratios1 = zeros(1,L);
ratios2 = ratios1;

for triangle_num = 1:L

  points1 = ver1(1:2,tri1(:,triangle_num));
  points2 = ver2(1:2,tri2(:,triangle_num));

  ratios1(triangle_num) = maxh(points1)/minh(points1);
  ratios2(triangle_num) = maxh(points2)/minh(points2);

  a1 = angles(points1,tri1(triangle_num));
  a2 = angles(points2,tri2(triangle_num));
 

  a_max1(triangle_num) = max(abs(a1));
  a_max2(triangle_num) = max(abs(a2));

end

disp('Mesh 1 :')
disp('minimum and maximum lengths ratios :')
[min(ratios1),max(ratios1)]
disp('maximum angle :')
max(a_max1)

disp('Mesh 2 :')
disp('minimum and maximum lengths ratios :')
[min(ratios2),max(ratios2)]
disp('maximum angle :')
max(a_max2)


 

end
