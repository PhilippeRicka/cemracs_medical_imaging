function column=buildcol(m,k,points,base);

L=base.L;
P=base.P;
J=base.J;
THETA=base.THETA;


[ndof,junk]=size(points);

xleft=[0:P];
xeleft=[-1:-1:1-L];

xright=[0:-1:-P];
xeright=[1:L-1];

column=zeros(ndof,3);
[pointer,pattern]=restriction(m,k,points,J,L);
column(pattern,:)=THETA(pointer,:); 

if(k<=P)
	y=zeros(1,P+1); y(k+1)=1;
	weights = extrapolate(xleft,y,xeleft,P);
	for n=1:L-1
		[pointer,pattern]=restriction(m,-n,points,J,L);
		column(pattern,:)=column(pattern,:)+weights(n)*THETA(pointer,:);
	end
end

% CORREZIONE BORDO SINISTRO

if(k>=2^m-P)
		
	y=zeros(1,P+1); y(2^m-k+1)=1;
	weights = extrapolate(xright,y,xeright,P);
	for n=1:L-1
		[pointer,pattern]=restriction(m,2^m+n,points,J,L);
		column(pattern,:)=column(pattern,:)+weights(n)*THETA(pointer,:);				 
	end
end