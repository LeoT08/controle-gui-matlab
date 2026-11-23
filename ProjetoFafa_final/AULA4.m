syms s t z

f = heaviside(t)
Fs = laplace(f)
Fz = ztrans(f)

Ft = ilaplace(Fs)
Fd = iztrans(Fz)