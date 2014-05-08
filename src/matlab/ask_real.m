 clear all;
 close all;
 
 %load adc.mat;
 Fs = 13.56e6;
 load ../vhdl/src/grpNfcEmu/unitNfcEmu/data/stimuli.txt
%load ../../data/adc_nfc_ask_load_mod.txt
%rx = adc_nfc_ask_load_mod;
  rx = stimuli;

 % load /tmp/adc.txt
  
  N = 2^16;
 rx = rx(1:N);
 
 Ts = 1/Fs;
 
 t = 0:Ts:(N-1)*Ts;
 f = -Fs/2:Fs/N:Fs/2-Fs/N;
 
 rx = rx(1:N)';

% rx = rx-mean(rx);
 
 nPlots = 6; cplot = 1;
 subplot(nPlots, 1, cplot); cplot = cplot + 1;
 plot(t,rx,'rx-');
 title('envelope');
  %%
 
sc_pattern = [-1 -1 -1 -1   1 1 1 1   1 1 1 1   -1 -1 -1 -1];
 %sc_pattern = [-1 -1 -1 0   0 1 1 1  1 1 1 0  0 -1 -1 -1];
% sc_pattern = -cos(2*pi*(0:15)/15);
%sc_pattern = sc_pattern-mean(sc_pattern);

 sc_pattern = 16*sc_pattern/sum(abs(sc_pattern))
 filtered = filter(sc_pattern, 1, rx);
 
 subplot(nPlots, 1, cplot); cplot = cplot + 1;
  plot(t,filtered,'gx-');
hold on;
 
 sc_pattern = [-2 -1 -1 -0.5   0.5 1 1 2   2 1 1 0.5   -0.5 -1 -1 -2];
 
 sc_pattern = 16*sc_pattern/sum(abs(sc_pattern));
 
 filtered = filter(sc_pattern, 1, rx);
 
 hold on;
 %subplot(nPlots, 1, cplot); cplot = cplot + 1;
  plot(t,filtered,'x-');
 title('matched filter');

 
 rx = filtered;
% S = fftshift(abs(fft(rx-mean(rx))));
 
 %
 q = abs(rx);
 
  subplot(nPlots, 1, cplot); cplot = cplot + 1;
  plot(t, q);
  title('abs');
       
 R = 8;
 
 pp = reshape(q,R,numel(q)/R);

 t = downsample(t, R);
 f = downsample(f, R)/R;
 N = N/R;
 Fs = Fs/R;
 
 
 q = sum(pp);
  subplot(nPlots, 1, cplot); cplot = cplot + 1;
  plot(t,q, 'x-');
  hold on;
  title('int. downsampled/thresholded');
  th = 400;
  
 q = double(q > th);
 
 plot(t, q*th, 'g');
  
 
  M = 5;
  man = 0*q;
  cnt = 0;
  state = 0;
  n = man;
  
 for i = 1:N
     if q(i) == 1
        cnt = cnt + 1;
     else 
         cnt = cnt - 1;
     end
     
     cnt = max(min(cnt,5),0);
     
     if cnt == 0
         state = 0;
     else
         cnt;
     end
     if cnt == 5
         state = 1;
     end
     man(i) = state;
     n(i) = cnt;
 end
 
 
 
  subplot(nPlots, 1, cplot); cplot = cplot + 1;
  stem(t,man);
  hold on;
  title('manchester');
  %plot(t,n, 'g');
  
  state = 0;
  % 0...idle
  % 1... check sof
  % 2... data
  d = [0 diff(man)];
  %plot(t,d,'g');
  b = 0.5;
  tb = t(1);
  det = 0*man;
  spb = 16;
  sof = 1;
  last = 0;
  i = 1;
  while i <= N-spb
     det(i) = state;
    switch state
        case 0
            if d(i) > 0
              state = 1;
            else
              i = i + 1;
            end
        case 1
            x = getManchesterBit(man(i:i+spb-1));
            if x == sof
                state = 2;
                i = i + spb;
                b = [b sof];
                tb = [tb t(i)];
            else
                i = i + 1;
                state = 0;
            end
            
            disp('sof');
        case 2
            x = getManchesterBit(man(i:i+spb-1));
            i = i + spb;
            if x ~= -1                
                b = [b x];
                tb = [tb t(i)];
            else                
                state = 0;
            end
            disp('data');
    end 
      
      
  end
  
  hold on;
  plot(t,det,'gx-');
      b = [b 0.5];
      tb = [tb t(end)];
  
  subplot(nPlots, 1, cplot); cplot = cplot + 1;
      
  bar(tb,2*b-1);
      
      
      
      