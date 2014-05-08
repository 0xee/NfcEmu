function q = amdemod(s, R)

pp = reshape(s, R, numel(s)/R);

q = sum(abs(pp));