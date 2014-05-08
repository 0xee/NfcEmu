% am demod test

close all;
clear all;


N = 10240;

% carrier/sample freqs
Fc = 13.56e6
Fs = 8*Fc;
Ts = 1/Fs;

t = 0:Ts:(N-1)*Ts;

% carrier phase
PhiC = 0.4

%subcarrier freq
Fsc = Fc/16;

% modulation index
Mu =  0.02;

% modulated subcarrier
q = sign(sin(2*pi*Fsc*t+PhiC)) .* (-sign(sin(2*pi*Fsc/8*t+PhiC))+1)/2;

%carrier
ErrC = 10e3;
c = sin(2*pi*(Fc+ErrC)*t+PhiC);

% tx signal
tx = (1+Mu*q).*c;

% awgn channel
Snr = 0.01;
n = 0;
n = Snr*rand(1,N);
rx = tx + n;

subplot(311);
plot(t,rx,'x-');

R = Fs/Fc;

q1 = amdemod(rx, R);
q1 = q1-mean(q1);

 sc_pattern = [-2 -1 -1 -0.5   0.5 1 1 2   2 1 1 0.5   -0.5 -1 -1 -2];
 
 sc_pattern = 16*sc_pattern/sum(abs(sc_pattern));
 
 q1f = filter(sc_pattern, 1, q1);


q2 = amdemod_sh(rx, (Fc+Fsc)/Fs, 0.01);

q2(1:200) = 0;

subplot(313);
plot(t,100*q2);
t1 = downsample(t, R);
subplot(312)
plot(t1, q1, 'x-');
hold on;
plot(t1, q1f, 'gx-');



