clear all;
close all;

stimuli;

system('cd ../sim; /opt/altera/modelsim_ase/bin/vsim -c -do sim_matlab.do;');

dout = load('results.txt');
din = load('stimuli.txt');

Fc = 13.56e6;
Fs = 8*Fc;

dout = dout(1:numel(din));


Sdin = abs(fftshift(fft(din)));
Sdout = abs(fftshift(fft(dout)));


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

figure;

subplot(211);
plot(fv,Sdin, 'b');
hold on; grid on;



plot(fv, Sdout, 'r');

subplot(212);

plot(fv, 20*log10(H), 'g');

grid on;
