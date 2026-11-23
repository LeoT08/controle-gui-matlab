T = 1
s = tf('s')
z = tf('z',T)

Gs = 1/(10.5*s+1)
Gz = c2d(Gs,T,'zoh')
Tz = z^(-5)

Dz = Tz/(Gz*(1-Tz))
Dz = minreal(Dz)

step(Gs)
hold on
dstep(Gz,T)
