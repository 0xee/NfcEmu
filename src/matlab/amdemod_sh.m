function env = amdemod_sh(s, Fc, Fstop)

t = 0:numel(s)-1;

loI = cos(pi*Fc*t);
loQ = sin(pi*Fc*t);

I = s.*loI;
Q = s.*loQ;

h = fir1(201, Fstop);

I = filter(h, 1, I);
Q = filter(h, 1, Q);
%plot(fftshift(abs(fft(I))));
%pause
env = abs(I+i*Q);
