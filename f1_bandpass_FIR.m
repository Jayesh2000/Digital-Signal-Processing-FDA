w_c = 1.15;                     %cut-off frequency
N = 4;                          %minimum N
fs = 1200e3;                    %sampling rate
bl = 257e3;                     %pass-band lower limit
bh = 302e3;                     %pass-band upper limit
sb2 = 237e3;                    %stopband 
sb3 = 322e3;                    %stopband
sb1 = 0;                        %stopband
sb4 = 600e3;                    %stopband
t = 0.15;                       %tolerance
pi = 22/7;

w_c1 = bl*2*pi/fs;
w_c2  = bh*2*pi/fs;
w_t = 10e3*2*pi/fs;
%Kaiser paramters
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
n=N_min+17

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(w_c2+w_t,n) - ideal_lp(w_c1-w_t,n);


%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,fs/2, fs);
plot(f,abs(H))
hold on
plot(sb2,abs(H(sb2)),'r*');
plot(sb3,abs(H(sb3)),'r*');
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
FIR_BandPass
