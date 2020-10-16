M = 43;
fs = 1200e3;
bl = 257e3;
bh = 302e3;
sb1 = 0;
sb2 = 237e3;
sb3 = 322e3;
sb4 = 600e3;
t = 0.15;
pi = 22/7;
unnormalized = [sb1,sb2,bl,bh,sb3,sb4]
normalized_into_pi = unnormalized*2/fs
normalized = normalized_into_pi*pi
transformation = tan(normalized/2)
omega0 = (transformation(1,3)*transformation(1,4))^0.5
B = transformation(1,4)-transformation(1,3)
freq_transformed = (transformation.^2 - omega0^2)
freq_transformed = freq_transformed ./ (transformation*B)
p_edge = 1
s_edge = min(-freq_transformed(1,2),freq_transformed(1,5))
D1 = (1/(1-t)^2) - 1
D2 = 1/t^2 - 1
N_min = (log(sqrt(D2/D1)) / log(s_edge/p_edge))
N_min = ceil(N_min)
left_inequal = p_edge/(D1^(1/(2*N_min)))
right_inequal = s_edge/(D2^(1/(2*N_min)))
cf = round((right_inequal+left_inequal)/2,2)

syms s p;
eq2 = s^(2*N_min) == -1*(j*cf)^(2*N_min)
poles = solve(eq2);
p1 = -1.06246 - j*0.440086
p2 = -1.06246 + j*0.440086
p3 = -0.440086 - j*1.06246
p4 = -0.440086 + j*1.06246
c_a = 1
c_b = -(p1+p2+p3+p4)
c_c = (p1*p2 + p1*p3 + p1*p4 + p2*p3 + p2*p4 + p3*p4)
c_d = -(p1*p2*p3 + p1*p2*p4 + p1*p3*p4 + p2*p3*p4)
c_e = (p1*p2*p3*p4)
s^4 -(p1+p2+p3+p4)*s^3 + (p1*p2 + p1*p3 + p1*p4 + p2*p3 + p2*p4 + p3*p4)*s^2 -(p1*p2*p3 + p1*p2*p4 + p1*p3*p4 + p2*p3*p4)*s + (p1*p2*p3*p4)

eq3 = (cf^(N_min))/(c_a*(s^4) + c_b*(s^3) + c_c*(s^2) + c_d*s + c_e)==0

