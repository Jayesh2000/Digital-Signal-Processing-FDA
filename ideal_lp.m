function hd = ideal_lp(wc,M);

alpha = (M-1)/2;
n = [0:1:(M-1)];
m = n - alpha + eps;
hd = sin(wc*m) ./ (pi*m);


%The Kaiser window function generates a window between 0 to n
%Therefore the ideal impulse response has been shifted to be centered at
%n/2 sample 
%effectively both the window and the impulse response are centred at the
%same sample
%the corresponding frequency response will have same magnitude plot,
%however it will carry an extra constant phase term
%that phase term will not disturb the Linear Phase response of FIR filter