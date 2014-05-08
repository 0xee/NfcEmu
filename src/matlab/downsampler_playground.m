close all;
clear all;

fc = 13.56e6;

fs = 8*fc;

Ts = 1/fs;

N = 200;

t = 0:Ts:(N-1)*Ts;


R = 4;

t_lo = t(1:R:end);

nSel = 3;

%Hcic = mfilt.cicdecim(R);

mlv = [];
muv = [];
iv = [];

step_phi = 0;

for sel = 1:nSel

    s_mat = [];
    mag = [];

    for phi=0:0.1:6.28
        
        s = cos(2*pi*fc*t+phi);
        s(1:N/8) = 0; s(7*N/8:end) = 0;
        s = s + 1;
        switch sel
            case 1, % just downsampling
                s_lo = downsample(s,R);

            case 2,
                s_lo = resample(s,1,R);

            case 3,
                
                
                L = 2*R;
                
                s_lo = MaxPPDownsampler(s, R, L);
                
                if step_phi == 1
                    phi
                    subplot(nSel, 1, nSel);
                    plot(t, s);
                    hold on;
                    stem(t_lo, s_lo, 'g');
                    hold off;
                    pause
                end
            otherwise,
                disp('invalid selection');
        end
        s_lo = s_lo-mean(s_lo);
        s_mat = [s_mat; s_lo];
        mag = [mag mean(abs(s_lo))/0.75];
    end

    subplot(nSel,2,2*sel-1);
    stem(mag);

    subplot(nSel,2,2*sel);
    sel;
    [mu idx] = max(mag);
    [ml idx] = min(mag);
    muv = [muv mu];
    mlv = [mlv ml];
    iv = [iv idx];
    stem(t_lo, s_mat(idx,:));

end


mlv
muv
iv



