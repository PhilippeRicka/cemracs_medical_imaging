function [pointer,pattern]=restriction(m,k,points,J,L)
pointer = 2^J*(2.^(m-points(:,1)).*points(:,2)-k);
pattern = logical((-L*2^J<pointer)&(pointer<L*2^J));
pointer=pointer+L*2^J;
pointer=pointer(pattern);