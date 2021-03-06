function gradTa = gradiente(a,griglia)
global T Xi Yi Li Ti Dxi Dyi
global interp_type

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMON PART 1

N = max(size(a));
gradTa = zeros(griglia.npoints,N);
gradTacont = zeros(griglia.npoints,N);

[hatx,haty]=phi(griglia,a);

hatx = hatx - floor(hatx);
haty = haty - floor(haty);

Dphi = gradphi(griglia);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FD Gradient + Interpolation

switch interp_type
        


% Dphi = [Dphi1/Da1 Dphi1/Da2;
%        Dphi2/Da1 Dphi2/Da2];


% NB. in questo caso, Dphi e' costante in x e y - Se no bisogna metterci un
% terzo indice che identifica il punto della griglia


    case 'BSpline'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B-spline

j = max(griglia.j)-1;
dj = 2.^j;


% A1 = sparse(griglia.npoints,2^j);
% A2 = sparse(griglia.npoints,2^j);
% dA1 = sparse(griglia.npoints,2^j);
% dA2 = sparse(griglia.npoints,2^j);

for i = 1:2^j;
    A1(:,i)=bspline3(dj*hatx-(i-1));
    A2(:,i)=bspline3(dj*haty-(i-1));
    dA1(:,i)=dj*(bspline2(dj*hatx-(i-1)+.5)- bspline2(dj*hatx-(i-1)-.5));
    dA2(:,i)= dj*(bspline2(dj*haty-(i-1)+.5)- bspline2(dj*haty-(i-1)-.5));
end

A1 = sparse(A1); A2=sparse(A2);
dA1 = sparse(dA1); dA2=sparse(dA2);

Np = griglia.npoints;

DX = sparse(Np,Np);
DY = zeros(Np,Np);

for i = 1:griglia.npoints
    k1 = (griglia.kx(i)+1)/2;
    k2 = (griglia.ky(i)+1)/2;
    DX(:,i)= dA1(:,k1).*A2(:,k2);
   DY(:,i)= A1(:,k1).*dA2(:,k2); 
end

Tx = DX*T; Ty=DY*T;

    case 'BSplineP'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B-spline

j = max(griglia.j)-1;
dj = 2.^j;
Npe = dj+5;


A1 = sparse(griglia.npoints,Npe);
A2 = sparse(griglia.npoints,Npe);
dA1 = sparse(griglia.npoints,Npe);
dA2 = sparse(griglia.npoints,Npe);

% A1 = sparse(griglia.npoints,2^j);
% A2 = sparse(griglia.npoints,2^j);
% dA1 = sparse(griglia.npoints,2^j);
% dA2 = sparse(griglia.npoints,2^j);

for i = 1:Npe;
    A1(:,i)=sparse(bspline3(dj*hatx-(i-3)));
    A2(:,i)=sparse(bspline3(dj*haty-(i-3)));    
    dA1(:,i)=dj*sparse((bspline2(dj*hatx-(i-3)+.5)- bspline2(dj*hatx-(i-3)-.5)));
    dA2(:,i)= dj*sparse((bspline2(dj*haty-(i-3)+.5)- bspline2(dj*haty-(i-3)-.5)));
end


% A1 = sparse(A1); A2=sparse(A2);
% dA1 = sparse(dA1); dA2=sparse(dA2);

Np = griglia.npoints;

Tx = zeros(Np,1); Ty = zeros(Np,1);
% DX = sparse(Np,Npe^2);
% DY = zeros(Np,Npe^2);

for i = 1:Npe;
    for k = 1:Npe;
        iglob = (k-1)*Npe+i;
        Tx(:)= Tx(:)+Ti(iglob)*dA1(:,i).*A2(:,k);
        Ty(:)= Ty(:)+Ti(iglob)*A1(:,i).*dA2(:,k);
    end
end

%%%%%%% FINE B-SPLINE

    case 'Spline'
        
                
hatx = vector2matrix(hatx,Li);
haty = vector2matrix(haty,Li);

Tx = interp2(Xi,Yi,Dxi,hatx,haty,'spline');
Ty = interp2(Xi,Yi,Dyi,hatx,haty,'spline');


[Tx Ty];

Tx = matrix2vector(Tx,Li);
Ty = matrix2vector(Ty,Li);

    otherwise
        
hatx = vector2matrix(hatx,Li);
haty = vector2matrix(haty,Li);

Tx = interp2(Xi,Yi,Dxi,hatx,haty,'cubic');
Ty = interp2(Xi,Yi,Dyi,hatx,haty,'cubic');


[Tx Ty];

Tx = matrix2vector(Tx,Li);
Ty = matrix2vector(Ty,Li);

end      


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMON PART 2
for i = 1:N
   gradTa(:,i)=Tx.*Dphi(:,i,1) + Ty.*Dphi(:,i,2);
end

% gradTa(:,1)=2*a(1)*griglia.x.^2 + 2*a(2)*griglia.x;
% gradTa(:,2)=2*a(2) + 2*a(1)*griglia.x;
% gradTa(:,3)=6*a(3)*griglia.y.^2+6*a(4)*griglia.y;
% gradTa(:,4)=6*a(4)+6*a(3)*griglia.y;
% 
% % gradTa = [Tx,Ty].*Dphi;
%  
% norm(gradTa(:,1)-gradTacont(:,1))
% norm(gradTa(:,2)-gradTacont(:,2))
% norm(gradTa(:,3)-gradTacont(:,3))
% norm(gradTa(:,4)-gradTacont(:,4))
