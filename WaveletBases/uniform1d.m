function mesh=uniform1d(j0,jmax)
if(nargin<2) jmax=j0; end
mesh.j=zeros(2^jmax+1,1);
mesh.k=zeros(2^jmax+1,1);
mesh.x=zeros(2^jmax+1,1);

mesh.j(1:2^j0+1)=j0*ones(2^j0+1,1);
mesh.k(1:2^j0+1)=(0:2^j0)';
for j=j0+1:jmax
	mesh.j(2^(j-1)+2:2^j+1)=j*ones(2^(j-1),1);
	mesh.k(2^(j-1)+2:2^j+1)=(1:2:2^j-1)';
end
mesh.x=mesh.k./2.^mesh.j;
mesh.npoints=2^jmax+1;