f = fopen('fir_stimuli.txt','w');

Fs = 108.48e6;
Ts = 1/Fs;
N = 1e4;
B = 11;

Fc = 13560e3;
phi = 0.1;

t = 0:Ts:Ts*(N-1);

% nfcField = sin(2*pi*Fc*t + phi);
 nfcField = chirp(t, 0*Fc, t(end), 2*Fc);

%nfcField = 0.*t; nfcField(numel(t)/2) = 1;

nfcField = nfcField - mean(nfcField);

nfcQuant = int32(2^(B-1) * nfcField - 0.5);

for i = 1:N
   
    fprintf(f, '%d\n', nfcQuant(i));
    
end

    