function [cont,j] = jpeg2contour(filename,tolerance,h)

pict = imread(filename);
% pict = flipud(pict);
% pict = add_margin(pict);
[pict,j] = squarify(pict);

cont = contourc(pict,[1,1]);
cont = remove_metadata(cont);
cont = smooth3(cont,tolerance);
cont = average(cont,h);

end
