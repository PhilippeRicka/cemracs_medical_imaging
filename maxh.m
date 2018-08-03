function h = maxh(triangle_vertices)

  a = norm(triangle_vertices(:,1) - triangle_vertices(:,2));
  b = norm(triangle_vertices(:,2) - triangle_vertices(:,3));
  c = norm(triangle_vertices(:,3) - triangle_vertices(:,1));

  h = max(max(a,b),c);

end
