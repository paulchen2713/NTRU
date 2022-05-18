%
% addition for NTRU
%
function out = addition_NTRU(a, b, p)
    sa = size(a, 2);
    sb = size(b, 2);
    
    if sa > sb
        b((sb + 1):sa) = zeros(1, sa - sb);
        ss = sa;
    elseif sb > sa
        a((sa + 1):sb) = zeros(1, sb - sa);
        ss = sb;
    else
        ss = sa;
    end
    
    out = mod(a + b, p);
    while out(ss) == 0 && ss > 1
        out = out(1:(ss - 1));
        ss = ss - 1;
    end
return

