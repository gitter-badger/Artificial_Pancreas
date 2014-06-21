function [ft]=invlap(Lf,t) 

% Gives a numerical approximation of the inverse Laplace transform, given
% that t is supplied

% Lf: anonymous function for the Laplace transform calculation 
% t: column vector of times from 0 to tmax 
% ft: inverse transform ?same size as t
nt=numel(t); 
dt=max(t)/(nt-1);
% parameter settings 
N=8*nt; 
a=44/N; 
% Numerical values of li
li=[0,6.28318530717958,12.5663706962589,...
  18.8502914166954, 25.2872172156717,...
  34.2969716635260, 56.1725527716607, 170.533131190126];
bi=[1, 1.00000000000004, 1.00000015116847, ...
1.00081841700481, 1.09580332705189, ...
2.00687652338724, 5.94277512934943, 54.9537264520382]; 
c=2*i*pi/N; 
li=a+i.*li; 
k=0:N; 
%i=sqrt(-1)!
% the following line may be replaced by a loop on n = size ?liin order 
% to avoid memory failure for huge values of nt = size?t???106?
[k,li]=meshgrid(k,li); 
s=(li+c*k)/dt; 
ft = real(Lf(s)); 
ft = 4*bi*ft/dt;
if length(ft)==8
    ft(2:N+1)=ft(1);
end
ft(1)=0.5*(ft(1)+ft(N+1)); 
% discrete Fourier's inversion 
ft = ifft(ft(1:N));
ft = real(exp(a.*(0:nt-1)).*(ft(1:nt))); 
return
