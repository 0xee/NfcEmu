f = fopen('stimuli.txt','w');


Fc = 13.56e6;
Fs = 8*Fc;


Ts = 1/Fs;
N = 1e4;
B = 11;

phi = 0.1;

t = 0:Ts:Ts*(N-1);

 nfcField = sin(2*pi*Fc*t + phi);
 nfcField = chirp(t, 0*Fc, t(end), 2*Fc)+0.1;

%nfcField = 0.*t; nfcField(numel(t)/2) = 1;

nfcQuant = int32(2^(B-1) * nfcField - 0.5);

for i = 1:N
   
    fprintf(f, '%d\n', nfcQuant(i));
    
end

    