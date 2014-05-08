%% 
close all;
clear all;

fc = 13.56e6;

Fs = 8*fc;

Ts = 1/Fs;

N = 4096;

t = 0:Ts:(N-1)*Ts;
f = -Fs/2:Fs/N:Fs/2-Fs/N;


fq = fc/16;

% 848khz nfc subcarrier
s = 0.02* sign(cos(2*pi*fq*t)) + 1;

% nfc carrier
c = cos(2*pi*fc*t);

% tx signal
nfc = s.*c;

% rx signal = tx + noise;
rx = nfc + 0.01*rand(1, numel(nfc));

load adc.mat;


nPlots = 8;
nextPlot= 1;

subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
plot(t,rx);
subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
stem(f,fftshift(abs(fft(rx))));

% downsample to 2*fc;
R = Fs/fc/2;
numel(rx)
rxLow = MaxPPDownsampler(rx, R, 2*R);
t = downsample(t, R);
f = downsample(f, R)./R;
Fs = Fs/R;
N = N/R;
Ts = 1/Fs;
subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
plot(t,rxLow);

subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
stem(f,fftshift(abs(fft(rxLow))));

rxLow = adc;
N = numel(adc);
t = 0:Ts:(N-1)*Ts;
f = -Fs/2:Fs/N:Fs/2-Fs/N;
lo = cos(2*pi*fc*t);
sRx = rxLow .* lo;

%sRx = sRx - mean(sRx);
subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
plot(t,sRx);

subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
stem(f,fftshift(abs(fft(sRx))));

%sRx = zeros(1,numel(sRx));
%sRx(numel(sRx)/2) = 1;

Hlow = fir1(10, fq/Fs/2);

qRx = filter(Hlow,1, sRx);

subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
plot(t,qRx);

%S = (fftshift(abs(fft(sRx))));
%Q = (fftshift(abs(fft(qRx))));

subplot(nPlots/2, 2, nextPlot); nextPlot = nextPlot + 1;
%plot(f,20*log(Q./S));
stem(f,fftshift(abs(fft(qRx))));