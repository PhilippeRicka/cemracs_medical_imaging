function [VER,TRI] = read_msh(filename)

  [fid,message] = fopen(filename, 'r');
  if (fid == -1)
    disp( message )
      return;
  end

  str = fgets(fid);
    if index( str, 'MeshFormat' ) == 0
      disp('This is not a valid msh file.')
    end

    while index( str, 'Nodes') == 0
    str = fgets(fid);
    end

    npoints = str2num(fgetl(fid));
      VER = zeros(npoints,4);

      for node_index = 1:npoints
			 VER(node_index,:) = str2num(fgets(fid));
      end

      str = fgetl(fid);
while index( str, 'Elements') == 0
  str = fgetl(fid);
end

fgetl(fid);
str = fgetl(fid);

n = 1;

while index( str, 'EndElements') == 0
  
data = str2num(str);
if data(2) == 2
  TRI(n,:) = data(end-2:end);
  n = n + 1;
end
str = fgetl(fid);
end

VER(:,1) = [];
VER = VER';
% TRI = TRI';

  fclose(fid);

end 
