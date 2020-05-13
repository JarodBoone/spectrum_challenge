function [b1, b2, b3] = parity_check(b1_r, b2_r, b3_r, p1_n, p2_n, p3_n, p1_r, p2_r, p3_r)

if((p1_n ~= p1_r) && (p2_n ~= p2_r))
    if(b1_r == 0) b1 = 1;
    else b1 = 0; end
else
    b1 = b1_r;
end

if((p1_n ~= p1_r) && (p3_n ~= p3_r))
    if(b2_r == 0) b2 = 1;
    else b2 = 0; end
else
    b2 = b2_r;
end

if((p2_n ~= p2_r) && (p3_n ~= p3_r))
    if(b3_r == 0) b3 = 1;
    else b3 = 0; end
else
    b3 = b3_r;
end

end

