function [J,DJ,HJ] = costoMI2(a)
% global npix
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global R griglia
global Nsample Kmi
global alfa
% Nsample passo di campionamento dell'insieme dei valori assunti

L = 6;%(-L,L) = supporto effettivo della gaussiana;

N = length(a);
npix = length(R);

da = 1/Nsample;
gamma = Kmi * da;

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);

[h_joint,Dh_joint,hT,DhT,hR]=hist1(Ta,R,gradTa);

den=hR.*hT;

% % calcolo dell'argomento del log
% 
% h_norm = h_joint;
% 
% iz = (h_norm<= 1.e-16);
% nz = sum(iz);
% h_norm(iz)=ones(nz,1);
% den(iz) = ones(nz,1);
% hT(iz) = ones(nz,1); % questa troncatura serve per la derivata del log
% 
% h_norm = h_norm./den;

% diag1=sparse((1:Nsample^2)',(1:Nsample^2)',log(h_norm)+1);
% diag2=sparse((1:Nsample^2)',(1:Nsample^2)',h_joint./hT);
% diag3= sparse((1:Nsample^2)',(1:Nsample^2)',1/h_norm);
% diag4=sparse((1:Nsample^2)',(1:Nsample^2)',1/hT);

diag1 = sparse((1:Nsample^2)',(1:Nsample^2)',h_joint);
diag2 = sparse((1:Nsample^2)',(1:Nsample^2)',(hR.^2).*(hT));

A = sum(h_joint.^2); B = (sum((hR.^2).*(hT.^2)));
J = A/B;
J = - log(J)/(1-alfa);

DA = sum(diag1 * Dh_joint);
DB = sum(diag2 * DhT);


DJ =  alfa*(DB/B - DA/A)/(1-alfa); 

% J = -sum(h_joint.*log(h_norm))/(Kmi^2);
% DJ = -sum(diag1*Dh_joint-diag2*DhT)/(Kmi^2);

HJ = [];

% HJ = -Dh_joint'*diag3*Dh_joint + Kmi*DhT'*diag4*DhT;


end