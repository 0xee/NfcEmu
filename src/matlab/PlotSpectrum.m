function [ dummy ] = PlotSpectrum(x, fs)
%PLOTSPECTRUM Summary of this function goes here
%   Detailed explanation goes here

fv = -fs/2:fs/numel(x):fs/2-fs/numel(x);
S = abs(fft(x));
plot(fv, fftshift(S));

end

