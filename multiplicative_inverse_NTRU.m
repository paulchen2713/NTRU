%
% polynomial multiplicative inverse for NTRU
%   ref: IEEE standard, p.16
%
function [fp, index] = multiplicative_inverse_NTRU(f, p)
    global N;
    fN = zeros(1, N + 1);
    fN(1) = -1;
    fN(N + 1) = 1;
    u = ones(1, 1);
    d = mod(f, p);
    v1 = zeros(1, 1);
    v3 = mod(fN, p);
    v3s = size(v3, 2);
    while any(v3 - zeros(1, v3s)) == 1
        [qq, t3] = division_poly(d, v3, p);
        % qv1 = multiplication_poly(qq, v1, p);
        qv1 = multiplication_NTRU(qq, v1, p);
        t1 = addition_NTRU(u, -qv1, p);
        u = v1;
        d = v3;
        v1 = t1;
        v3 = t3;
        v3s = size(v3, 2);
    end
    if size(d, 2) == 1
        [dd, di] = multiplicative_inverse_p(d, p);
        if dd ~= 1
            fprintf('\nWarning for multiplicative inverse!\n');
        end
        fp = mod(di*u, p);
        index = 'OK';
    else
        fp = 0;
        index = 'FALSE';
    end
return


