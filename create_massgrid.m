function [ Mass, griglia ] = create_massgrid( p, base, M )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

global spazio

griglia.npoints = max(size(p));
jmax = base.J;
griglia.j = jmax*ones(griglia.npoints,1);
griglia.kx = floor(p(1,:)' * 2^jmax /M);
griglia.ky = floor(p(2,:)' * 2^jmax /M);
griglia.x = (griglia.kx * 2^(-jmax));
griglia.y = (griglia.ky * 2^(-jmax));

Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base); % only relevant in a multiscale case

end

