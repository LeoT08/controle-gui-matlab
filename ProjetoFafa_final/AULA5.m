s = tf('s')
Gs = 1/(s+1)
T = 0.5


Gz = c2d(Gs,T,'tustin')
step(Gs)
hold on
dstep(Gz,T)