function mesh=uniform1d(j0,jmax)
mesh=zeros(2^jmax,4);
mesh(1:2^j0,1)=j0*ones(2^j0,1);
mesh(1:2^j0,2)=(0:2^j0-1)';
for j=j0+1:jmax
	mesh(2^(j-1)+1:2^j,1)=j*ones(2^(j-1),1);
	mesh(2^(j-1)+1:2^j,2)=(1:2:2^j-1)';
end
mesh(:,3)=mesh(:,2)./2.^mesh(:,1);
% mesh(1,4)=1;
% mesh(2^j0+1,4)=1;