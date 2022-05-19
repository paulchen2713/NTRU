%
% polynomial division for polynomials
%   ref: IEEE standard, p.16
%
function [qq, r] = division_poly(a, b, p)
    a = mod(a, p);
    b = mod(b, p);
    r = a;
    qq = zeros(1, 1);
    bs = size(b, 2);
    [d, u] = multiplicative_inverse_p(b(bs), p);
    if d ~= 1
        fprintf('\nWarning for multiplicative inverse!\n');
    end
    rs = size(r, 2);
    while rs >= bs
        rbs = rs - bs;
        v = zeros(1, rbs + 1);
        v(rbs + 1) = u * r(rs);
        vb = multiplication_poly(v, b, p);
        r = addition_NTRU(r, -vb, p);
        qq = addition_NTRU(qq, v, p);
        rs = size(r, 2);
        if any(r - zeros(1, rs)) == 0
            return
        end
    end
return

