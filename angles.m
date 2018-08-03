function [ang] = angles(three_points)

  for i = 1:3

    edge1 = (three_points(:,mod(i,3)+1) - three_points(:,i));
    edge1 = edge1/norm(edge1);
    edge2 = (three_points(:,mod(i+1,3)+1) - three_points(:,i));
    edge2 = edge2/norm(edge2);

ang(i) = acos(dot(edge1,edge2));

  end

end
