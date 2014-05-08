clear all;
close all;

fir_stimuli;

system('cd ../sim; /opt/altera/modelsim_ase/bin/vsim -c -do sim.do;');

dout = load('fir_results.txt');
ddout= load('dfir_results.txt');
din = load('fir_stimuli.txt');

Fs = 13.56;

dout = dout(1:numel(din));
ddout = ddout(1:numel(din));


Sdin = abs(fftshift(fft(din)));
Sdout = abs(fftshift(fft(dout)));
Sddout = abs(fftshift(fft(ddout)));


%finc = FsOut/numel(Sdout);
%fv = -FsOut/2:finc:FsOut/2-finc;

% if FsOut < FsIn
% %  Sdout = kron([0; 1; 0], Sdout);
% %  Sdout = [Sdout; 0];
% lower = (numel(Sdin)-numel(Sdout))/2;
% Sdin = Sdin(lower:end);
% Sdin = Sdin(1:numel(Sdout));
% end

finc = Fs/numel(Sdin);
fv = -Fs/2:finc:Fs/2-finc;

H = Sdout./Sdin;
dH = Sddout./Sdin;

subplot(211);
plot(fv,Sdin, 'b');
hold on; grid on;



plot(fv, Sdout, 'r');
plot(fv, Sddout, 'g');

subplot(212);

plot(fv, 20*log10(H), 'r');
hold on;
plot(fv, 20*log10(dH), 'g');

grid on;
