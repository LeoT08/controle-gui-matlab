syms p k L

F = k-1;
S = 1+L*k^2;
f = F*p + p*F + S;
P = solve(f,p);
J = P;

dJdk = simplify( diff(J,k) );
[num,den] = numden(dJdk);

for i = [1 2 3]
    NUM = subs(num,{L},{i});
    raizes = roots( sym2poly(NUM) )
    dJ2dk2 = simplify ( diff(dJdk,k) );
    [ eval( subs(dJ2dk2,{L,k},{i,raizes(1)}) )
        eval( subs(dJ2dk2,{L,k},{i,raizes(2)}) ) ]
end
% k = -0.4142 (L = 1)
% k = -0.2247 (L = 2)
% k = -0.1547 (L = 3)

