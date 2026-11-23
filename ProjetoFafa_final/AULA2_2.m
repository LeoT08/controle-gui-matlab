A = [0 1; 0 -1]; 
B = [0 1]'; 
C = [1 0]; 

Qy = 100; 
R = 1; 
Q = C'*Qy*C; 

K = lqr(A,B,Q,R) 
polos = eig(A-B*K) 
K = place(A,B,polos) 
