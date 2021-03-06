function griglia=uniform2d(j0,jmax)

npoints=(2^jmax+1)^2;
griglia.j=zeros(npoints,1);
griglia.kx=zeros(npoints,1);
griglia.ky=zeros(npoints,1);
griglia.x=zeros(npoints,1);
griglia.y=zeros(npoints,1);
griglia.b=zeros(npoints,1);
griglia.j0=j0;
griglia.npoints=npoints;

v=(0:2^j0);
ky=repmat(v,2^j0+1,1); ky=reshape(ky,(2^j0+1)^2,1);
kx=repmat(v',1,2^j0+1);
kx=reshape(kx,(2^j0+1)^2,1);

griglia.j(1:(2^j0+1)^2)=j0*ones((2^j0+1)^2,1);
griglia.kx(1:(2^j0+1)^2)=kx;
griglia.ky(1:(2^j0+1)^2)=ky;


for j=j0+1:jmax

griglia.j((2^(j-1)+1)^2+1:(2^j+1)^2)=j*ones(2^(j-1)*(3*2^(j-1)+2),1);

vx=(1:2:2^j-1);
vy=(0:2:2^j);
ky=repmat(vy,2^(j-1),1); ky=reshape(ky,(2^(j-1)+1)*2^(j-1),1);
kx=repmat(vx',1,2^(j-1)+1); kx=reshape(kx,(2^(j-1)+1)*2^(j-1),1);
griglia.kx((2^(j-1)+1)^2+1:(2^(j-1)+1)*(2^j+1))=kx;
griglia.ky((2^(j-1)+1)^2+1:(2^(j-1)+1)*(2^j+1))=ky;



vy=(1:2:2^j-1);
vx=(0:2:2^j);
ky=repmat(vy,2^(j-1)+1,1); ky=reshape(ky,(2^(j-1)+1)*2^(j-1),1);
kx=repmat(vx',1,2^(j-1)); kx=reshape(kx,(2^(j-1)+1)*2^(j-1),1);
griglia.kx((2^(j-1)+1)*(2^j+1)+1:(2^(j-1)+1)*(3*2^(j-1)+1))=kx;
griglia.ky((2^(j-1)+1)*(2^j+1)+1:(2^(j-1)+1)*(3*2^(j-1)+1))=ky;


vy=(1:2:2^j-1);
vx=(1:2:2^j-1);
ky=repmat(vy,2^(j-1),1); 
ky=reshape(ky,2^(j-1)*2^(j-1),1);
kx=repmat(vx',1,2^(j-1)); kx=reshape(kx,2^(j-1)*2^(j-1),1);
griglia.kx((2^(j-1)+1)*(3*2^(j-1)+1)+1:(2^j+1)^2)=kx;
griglia.ky((2^(j-1)+1)*(3*2^(j-1)+1)+1:(2^j+1)^2)=ky;

end

griglia.x=griglia.kx.*2.^(-griglia.j);
griglia.y=griglia.ky.*2.^(-griglia.j);

griglia.b=((griglia.kx==0)|(griglia.ky==0)|(griglia.kx==2.^griglia.j)|(griglia.ky==2.^griglia.j));