w_c = 1.15;                     %cut-off frequency
N = 4;                          %minimum N
fs = 1200e3;                    %sampling rate
bl = 257e3;                     %pass-band lower limit
bh = 302e3;                     %pass-band upper limit
sb1 = 0;                        %stopband
sb2 = 237e3;                    %stopband 
sb3 = 322e3;                    %stopband
sb4 = 600e3;                    %stopband
t = 0.15;                       %tolerance
pi = 22/7;

%poles of analog low pass filter
p1 = -1.06246 - j*0.440086      
p2 = -1.06246 + j*0.440086
p3 = -0.440086 - j*1.06246
p4 = -0.440086 + j*1.06246

%transformed band edges and relevant parameters
ws1 = tan(sb2*pi/fs)
ws2 = tan(sb3*pi/fs)
wp1 = tan(bl*pi/fs)
wp2 = tan(bh*pi/fs)
w_0 = sqrt(wp1*wp2)
B = wp2-wp1

%makign transfer function
[numerator,denominator] = zp2tf([],[p1 p2 p3 p4],w_c^N)

%transformation of filters
syms s z;
analog_lpf(s) = poly2sym(numerator,s)/poly2sym(denominator,s)
analog_bpf(s) = analog_lpf(((s^2) + (w_0^2))/(B*s))
discrete_bpf(z) = analog_bpf((z-1)/(z+1))

%oefficients of analog BPF
[num_analog, den_analog] = numden(analog_bpf(s));                   %numerical simplification
num_analog = sym2poly(expand(num_analog));                          
den_analog = sym2poly(expand(den_analog));                          %collect coeffs into matrix form
k = den_analog(1);                                                  %normalizing factor
den_analog = den_analog/k
num_analog = num_analog/k

%coefficients of discrete BPF
[num_discrete, den_discrete] = numden(discrete_bpf(z));                 
num_discrete = sym2poly(expand(num_discrete));                          
den_discrete = sym2poly(expand(den_discrete));                          
k = den_discrete(1);                                                    
den_discrete = den_discrete/k
num_discrete = num_discrete/k

%plotting the frequency response of the filter
fvtool(num_discrete,den_discrete) ;


%plotting un-normalized filter response
[H,f] = freqz(num_discrete,den_discrete,6e5, fs);
plot(f,abs(H), 'LineWidth', 3);
hold on
plot([sb2 sb2],[0 1.2],'--g');
plot([sb3 sb3],[0 1.2],'--g');
plot([bl bl],[0 1.2],'--r');
plot([bh bh],[0 1.2],'--r');
plot([0 6e5],[0.15 0.15],'k');
plot([0 6e5],[0.85 0.85],'k');
grid minor
xlabel('Frequency');
ylabel('Magnitude');
title("Magnitude Response");
hold off
