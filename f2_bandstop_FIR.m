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

w_c1 = pb2*2*pi/fs;
w_c2 = pb3*2*pi/fs;
w_t = 10e3*2*pi/fs;

A = -20*log10(0.15)
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end
N_min = ceil((A-7.95) / (2.285*0.0333*pi))

%Window length for Kaiser Window
n=N_min+14
bs_ideal =  ideal_lp(pi,n) -ideal_lp(w_c2-w_t,n) + ideal_lp(w_c1+w_t,n);
kaiser_win = (kaiser(n,beta))';
FIR_BandStop = bs_ideal .* kaiser_win;
fvtool(FIR_BandStop);


%magnitude response
[H,f] = freqz(FIR_BandStop,1,fs/2, fs);
plot(f,abs(H))
hold on
plot(pb2,abs(H(pb2)),'r*');
plot(pb3,abs(H(pb3)),'r*');
plot(bl,abs(H(bl)),'b*');
plot(bh,abs(H(bh)),'b*');
plot([0 6e5],[0.15 0.15],'k');
plot([0 6e5],[0.85 0.85],'k');
grid minor
xlabel('Frequency');
ylabel('Magnitude');
title("Magnitude Response");
hold off

%%
FIR_BandStop


