function S=operator(base,grid,coefs)

a=base.a;
THETA=base.THETA;
J=base.J;
L=base.L;
P=base.P;

[ndof,junk]=size(grid);
S=zeros(ndof);

xleft=[0:P];
xeleft=[-1:-1:1-L];

xright=[0:-1:-P];
xeright=[1:L-1];

for i=1:ndof,
	
	column=zeros(ndof,1);
	
	% calcolo tutta la colonna i-esima insieme
	
	m=grid(i,1); k=grid(i,2);
	
	pointer = 2^J*(2.^(m-grid(:,1)).*grid(:,2)-k);
	pattern = logical((-L*2^J<pointer)&(pointer<L*2^J));
	pointer=pointer(pattern)+L*2^J;
	for id=0:2,
		column(pattern)=column(pattern)+coefs(id+1)*2^(id*m)*THETA(pointer,id+1);
	end
	% column=sparse(column)
	S(:,i)=column;
	
	
	% CORREZIONE BORDO DESTRO
	
	if(k<=P)
		
		y=zeros(1,P+1); y(k+1)=1;
		weights = extrapolate(xleft,y,xeleft,P);
		for n=1:L-1
			column=zeros(ndof,1);
			pointer = 2^J*(2.^(m-grid(:,1)).*grid(:,2)+n);
			pattern = logical((-L*2^J<pointer)&(pointer<L*2^J));
			pointer=pointer(pattern)+L*2^J;
			for id=0:2,
				column(pattern)=column(pattern)+coefs(id+1)*2^(id*m)*THETA(pointer,id+1);
			end
			S(:,i)=S(:,i)+weights(n)*column;
		end
	
	end

	% CORREZIONE BORDO SINISTRO
	
	if(k>=2^m-P)
		
		y=zeros(1,P+1); y(2^m-k+1)=1;
		weights = extrapolate(xright,y,xeright,P);
		for n=1:L-1
			 column=zeros(ndof,1);
			 pointer = 2^J*(2.^(m-grid(:,1)).*grid(:,2)-2^m-n);
			 pattern = logical((-L*2^J<pointer)&(pointer<L*2^J));
			 pointer=pointer(pattern)+L*2^J;
			for id=0:2,
				column(pattern)=column(pattern)+coefs(id+1)*2^(id*m)*THETA(pointer,id+1);
			end			 
			S(:,i)=S(:,i)+weights(n)*column;
		end
	end
	

end