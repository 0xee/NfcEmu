function [sLo] = MaxPPDownsampler(s, R, L)

                pp = reshape(s,R,numel(s)/R);
                
                pp_mag = zeros(size(pp));
                for i = 1:R
                    r1 = pp(i,:)-mean(pp(i,:));
                    c1 = [r1(1); zeros(L-1,1)];
                    toe = toeplitz(c1,r1);
                    pp_mag(i,:) = sum(abs(toe));    
                end

                [m col_idx] = max(pp_mag);

                col_offset = 0:R:R*(numel(col_idx)-1);

                idx = col_offset + col_idx;

                sLo = pp(idx);



end

