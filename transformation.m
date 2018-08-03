function [a1, Li, j, griglia, Mass] = transformation(atlas,patient,interp_type,cost_function)

% atlas is the ATLAS IMAGE;
% patient is the PATIENT IMAGE;
% theta: ATLAS -> PATIENT;
% interp_type is 'AI' or 'Cubic' or 'Spline', default is 'AI'
% cost_function is 'LS' or 'WNRMSE' or 'MI', default is 'LS'

addpath('./WaveletBases')


  if 1 - strcmp(interp_type,'AI')*strcmp(interp_type,'Cubic')*strcmp(interp_type,'Spline')
  interp_type = 'AI';
  end
  if 1 - strcmp(cost_function,'LS')*strcmp(cost_function,'WNRMSE')*strcmp(cost_function,'MI')
  cost_function = 'LS';
  end

close all

global spazio spazio_im griglia T R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
global interp_type cost_function
global wname maxlev % wavelet to be used for the Besov norm computation
global hvs
global besov_q;
global Nsample Kmi;

startmode = 'zero'; % nodal base

Kmi=3; Nsample = 32;
maxit=500;

nrefine=2;

% AI wavelet for the description of the image
D = 6;

% Transormations

nw = 3; j0 = 2; jwi = 2; % nw = degree of polynomial interpolation

a0 = zeros(2*(2^jwi+1)^2,1);

figure(1); clf


% CONSTRUCTION OF NOISE

% INITIALIZATION OF THE IMAGE

disp(['Image = ',atlas]);
R = imread(atlas);

Rclean = double(R)/256;
T = imread(patient);

R = double(R)/256;T = double(T)/256;

[R,j] = squarify(R,'medical');
[T,j] = squarify(T,'medical');

maxlev=j;

if size(R) ~= size(T)
  disp('ERROR : reference and template are not the same size !')
end


% Initialization of the transformation space

jmax=9; % resolution to evaluate PHI

disp(['Transformation : wavelet interpolant - nw = ',num2str(nw),' - j0 = ',num2str(j0),...
    ' - J = ',num2str(jwi)]);
if(strcmp(cost_function,'MI'))
    disp(['K = ',num2str(Kmi),' - Nsample = ',num2str(Nsample)]);
end

base=start(nw,jmax);
spazio = uniform2d(j0,jwi); % 'transformations'
griglia = quadgrid(j); % 'pixel'

% Operator evaluating space functions onto grid nodes
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base); % only relevant in a multiscale case
disp('building mass operator');


% grid which the image is defined on

h = 1/2.^j;


% Data for describing T from a matrix to a vector.
% This is not a mandatory trick : one can surely do better than this.

xt=(h/2:h:1-h/2);
yt=(h/2:h:1-h/2);
[Xt,Yt]=meshgrid(xt,yt);
Li = griddata(griglia.x,griglia.y,(1:griglia.npoints)',Xt,Yt);
Li = round(Li); % Here Li basically counts the grid points


N = 2^j;


% Data construction for the Spline or bi-cubic interpolation

if(strcmp(interp_type,'Spline')|strcmp(interp_type,'Cubic'))
  
    hf = h/(2.0^nrefine);
    xe=(-3*h/2:h:1+3*h/2);
    ye = xe;
    [Xe,Ye]=meshgrid(xe,ye);

    Te = [T(:,N-1) T(:,N), T, T(:,1) T(:,2)];
    Te = [Te(N-1,:); Te(N,:); Te; Te(1,:); Te(2,:); ];

    xf = (-3*hf/2:hf:1+3*hf/2);
    yf = xf;
    [Xf,Yf]=meshgrid(xf,yf);
    Tf = interp2(Xe,Ye,Te,Xf,Yf);
    Xi = Xf; Yi = Yf; Ti = Tf;

    S = Ti;
    % S = conv2 (T, ones (3, 3) / 9, 'same');
    [Dxi, Dyi] = gradient(S,hf);

end


% Data construction for the AI interpolation

if (strcmp(interp_type,'AI'))
    
    AIbase=AIstart(D,jmax);
    AIspace = uniformAIspace2d(j,D); % This is the space which represents the image with periodic extension

    % Construction of the cost function an its gradient. Periodic extension of T.

    Te = [T(:,N-D+1:N), T, T(:,1:D)];
    Te = [Te(N-D+1:N,:); Te; Te(1:D,:)];

    Te = Te';

	      AIspace1d = uniformAIspace1d(j,D);
	      cgrid1d = uniform1d(j+nrefine);
	      [A,DA] = AIoperator1d(AIspace1d,cgrid1d,AIbase);

    Ti = A*Te'*A';
    Dyi = DA*Te'*A';
    Dxi = A*Te'*DA';

    % Te is the vector in AIspace corresponding to T

    cgrid = uniform2d(j+nrefine,j+nrefine);

    Xi = reshape(cgrid.x,2^(j+nrefine)+1,2^(j+nrefine)+1)';
    Yi = reshape(cgrid.y,2^(j+nrefine)+1,2^(j+nrefine)+1)';
end

% disp('End of interpolation'); pause


figure(1)
subplot(2,3,1); imshow(R); title('Reference image');
subplot(2,3,2); imshow(T); title('Template image');


disp('2')


T = matrix2vector(T,Li);
R = matrix2vector(R,Li);

c0 = costo(a0);
tolerance = c0/200;

t = cputime;


figure()
xlabel('iteration')
ylabel('cost function')
hold on

  opt = optimset('GradObj','on','MaxIter',maxit,'TolX',1.e-6,'TolFun',1.e-6,...
		 'OutputFcn', @showJ_history,'Display','iter')
 [a1, fval,exitflag, output, grad, hess] = fminunc(@costo,a0,opt);
 
 hold off
 
elapsed_time=cputime-t;


 T1 = deforma(a1,griglia);
figure(1);
subplot(2,3,5); imshow(vector2matrix(T1,Li));title('Transformed template image');

subplot(2,3,6)
disp_deformazione(a1,griglia);title('Transformation')
 
 S=zeros(2^j,2^j,3);
 % S(:,:,1)=matrix2vector(R,Li);
 S(:,:,1) = Rclean;
 S(:,:,2)=vector2matrix(T,Li);
 subplot(2,3,3); imshow(S);title('Reference vs Template')

 T1 = min(T1,1); T1 = max(T1,0);
 S(:,:,2)=vector2matrix(T1,Li);
  subplot(2,3,4); imshow(S);title('Reference vs transformed Template');

output


disp(['CPU-time: ',num2str(elapsed_time)]);

diary off;
clear hvs

end
