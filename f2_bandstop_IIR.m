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
D1 = 0.3841;
D2 = 43.4444;
N = 3;
p1 = -0.43105373745015337089706247949539;
p2 = - 0.2155268687250766854485312397477 + 0.94305646354145164515525800236185i;
p3 = - 0.2155268687250766854485312397477 - 0.94305646354145164515525800236185i;
ws1 = tan(bl*pi/fs)
ws2 = tan(bh*pi/fs)
wp1 = tan(pb2*pi/fs)
wp2 = tan(pb3*pi/fs)
w_0 = sqrt(wp1*wp2)
B = wp2-wp1

[numerator,denominator] = zp2tf([],[p1 p2 p3],((-1)^N)*p1*p2*p3)

syms s z;
analog_lpf(s) = poly2sym(numerator,s)/poly2sym(denominator,s)
analog_bsf(s) = analog_lpf((B*s)/((s^2) + (w_0^2)))
discrete_bsf(z) = analog_bsf((z-1)/(z+1))

[num_analog, den_analog] = numden(analog_bsf(s));                   %numerical simplification
num_analog = sym2poly(expand(num_analog));                          
den_analog = sym2poly(expand(den_analog));                          %collect coeffs into matrix form
k = den_analog(1);                                                  %normalizing factor
den_analog = den_analog/k
num_analog = num_analog/k


[num_discrete, den_discrete] = numden(discrete_bsf(z));                 
num_discrete = sym2poly(expand(num_discrete));                          
den_discrete = sym2poly(expand(den_discrete));                          
k = den_discrete(1);                                                    
den_discrete = den_discrete/k
num_discrete = num_discrete/k


fvtool(num_discrete,den_discrete) ;


[H,f] = freqz(num_discrete,den_discrete,12e5, fs);
plot(f,abs(H), 'LineWidth', 3);
hold on
plot([pb2 pb2],[0 1.2],'--g');
plot([pb3 pb3],[0 1.2],'--g');
plot([bl bl],[0 1.2],'--r');
plot([bh bh],[0 1.2],'--r');
plot([0 6e5],[0.15 0.15],'k');
plot([0 6e5],[0.85 0.85],'k');
grid minor
xlabel('Frequency');
ylabel('Magnitude');
title("Magnitude Response");
hold off
