function column=AIbuildcol(m,k,type,points,base);

D=base.D;
P=base.P;
N=base.J;
PHI=base.PHI;

[ndof,junk]=size(points);

% INDIVIDUAZIONE E MODIFICA DEI PUNTI FUORI RANGE
% Sinistra

% xbleft = (P+1-D)/(2^m);
% xbright = (2^m - P - 1 +D)/2^m;

% l1 = (points(:,3)<xbleft);
% points(l1,1)=m*ones(sum(l1),1);
% points(l1,2)=(P+1-D)*ones(sum(l1),1);

% l2 = (points(:,3)>xbright);
% points(l2,1)=m*ones(sum(l2),1);
% points(l2,2)=(2^m-P-1+D)*ones(sum(l2),1);

% l = (l1|l2);


% xleft=[0:P];
% xeleft=[-1:-1:P+1-2*D]; %Rifare i conti

% xright=[-1:-1:-P-1];
% xeright=[0:2*D-2-P];

column=zeros(ndof,2);
[pointer,pattern]=AIrestriction(m,k,points,N,D);
column(pattern,:)=PHI(pointer,:);

% CORREZIONE BORDO SINISTRO

% if(k<=P)
	% y=zeros(1,P+1); y(k+1)=1;
	% weights = extrapolate(xleft,y,xeleft,P);
	% for n=1:2*D-P-1
		% [pointer,pattern]=AIrestriction(m,-n,points,N,D);
		% column(pattern,:)=column(pattern,:)+weights(n)*PHI(pointer,:);
	% end
% end

% CORREZIONE BORDO DESTRO

% if(k>=2^m-P-1)
		
% y=zeros(1,P+1); y(2^m-1-k+1)=1;
%     size(xright)
%     size(y)
% weights = extrapolate(xright,y,xeright,P);
% for n=0:2*D-2-P
 		% [pointer,pattern]=AIrestriction(m,2^m+n,points,N,D);
 		% column(pattern,:)=column(pattern,:)+weights(n+1)*PHI(pointer,:);				 
 	% end
% end
 
% if(P==1);
    % column(l,1) = column(l,1)+2^m*column(l,2).*(points(l,3)...
        % -points(l,2)./(2.^points(l,1)));
% end
