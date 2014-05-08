function b = getManchesterBit(v)

b = -1;
spb = numel(v);
if mod(spb,2) ~= 0
    disp('spb must be even');
    
else
    
    
    v
    %h1 = v(spb/4)
    %h2 = v(3*spb/4)
    h1 = sum(v(1:spb/2))
    h2 = sum(v(spb/2+1:end))
    
    
    if h1 <= spb/6 && h2 >= spb/3
        b = 0
    end
    if h1 >= spb/3 && h2 <= spb/6
        b = 1
    end
    
end


