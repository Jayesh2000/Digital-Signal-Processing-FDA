M = 43;
fs = 1200e3;
bl = 264e3;
bh = 319e3;
pb1 = 0;
pb2 = 244e3;
pb3 = 339e3;
pb4 = 600e3;
t = 0.15;
pi = 22/7;
unnormalized = [pb1,pb2,bl,bh,pb3,pb4]
normalized_into_pi = unnormalized*2/fs
normalized = normalized_into_pi*pi
transformation = tan(normalized/2)
omega0 = (transformation(1,2)*transformation(1,5))^0.5
B = transformation(1,5)-transformation(1,2)
freq_transformed = (transformation*B)
freq_transformed = freq_transformed ./ (omega0^2 - transformation.^2)
p_edge = 1
s_edge = min(freq_transformed(1,3),-freq_transformed(1,4))
D1 = (1/(1-t)^2) - 1
D2 = 1/t^2 - 1
N_min = (acosh(sqrt(D2/D1)) / acosh(s_edge/p_edge))
N_min = ceil(N_min)
%%
syms s
eq1= 1 + 0.3841*(cosh(3*acosh(-s*i))^2) == 0
p = solve(vpa(simplify(eq1)))
%%
p(1)*p(3)*p(4)