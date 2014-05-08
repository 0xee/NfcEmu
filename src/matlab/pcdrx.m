close all;
clear all;

load ../vhdl/grpNfc/unitNfcEmu/data/stimuli.txt;
envelope = stimuli;

Fs = 13.56e6;
res = 1e6;
Ts = 1/Fs*res;

N = 2^13;%numel(envelope);
offset = 2^13;
envelope = envelope(offset+1:offset+N);
t = 0:Ts:(N-1)*Ts;

nPlots = 3;
p = 1;

subplot(nPlots, 1, p); p = p + 1;
plot(t, envelope);

mf = [-1 -1 -1 -1 1 1 1 1 1 1 1 1 -1 -1 -1 -1];

sc = filter(mf, 1, envelope);

rec = 0;

subplot(nPlots, 1, p); p = p + 1;
plot(t, sc, 'o-');
hold on;
grid on;




R = 8;
scenv = amdemod(sc, R);
t = downsample(t,R);
N = N/R;

subplot(nPlots, 1, p); p = p + 1;
plot(t, scenv, 'o-');
grid on;


spikeTimeout = 4;

s = floor(spikeTimeout/Ts)

scth = 100;

state = 0;
cnt = 0;
man = [];
for i = 1:N
   
    
end