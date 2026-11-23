 
syms  p11  p12  p22  k1  k2  L  
  
K = [-k1  0; 0 -k2 ]; 
A = [ 0  1; 0  0 ]; 
B = [ 0  0; 1  1 ]; 
F =  A + B*K; 
P = [ p11 p12; p12 p22 ]; 
S = eye(2) + K.'*K*L; 
f = F.'*P + P*F + S ; 
x0 = [1 0]'; 
 
[ P11, P12, P22 ] = solve( f, p11, p12, p22 ); 
P_ = [P11 P12; P12 P22];  
J = x0.'*P_*x0; 
  
dJdk1 = simplify( diff(J,k1) ); 
dJdk2 = simplify( diff(J,k2) ); 
  
[num1,den1] = numden(dJdk1); 
[num2,den2] = numden(dJdk2); 
  
%L = 10 
 
NUM1 = subs(num1,{L},{10}) 
NUM2 = subs(num2,{L},{10}) 
  
[ kk1, kk2 ] = solve( NUM1, NUM2, k1, k2, 'Real', true) 
 
eval(kk1) 
eval(kk2) 
 
% k1 = 0.1440 
% k2 = 0.3709 