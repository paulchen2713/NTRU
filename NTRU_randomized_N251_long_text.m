% 
% NTRU (N-th Truncated Ring Unit) with randomized f, g, m, r, large N, 
%   and take text message input with no limits
% 
clear;
clc;
%
global N;
% 
% public key: N, p, q, d, h 
% 
N = 251; % N = 7;
p = 3;   % p = 3;
q = 127; % q = 41;
df = 13; % df = 2;
dg = 13; % dg = 2;
% 
% private key: f, g 
% 
% f = [-1, 0, 1, 1, -1, 0, 1];
% g = [0, -1, -1, 0, 1, 0, 1];
%
% random generation of f and g
f = zeros(1, N);
rr = rand(1, N);
for id = 1 : df + 1
    [maxi, ip] = max(rr);
    f(ip) = 1;
    rr(ip) = -1;
end
rr = abs(rr);
for id = 1 : df
    [mini, ip] = min(rr);
    f(ip) = -1;
    rr(ip) = 1;
end
f_size = size(f, 2);
while f(f_size) == 0 && f_size > 1
    f = f(1 : f_size-1);
    f_size = f_size - 1;
end
%
g = zeros(1, N);
rr = rand(1, N);
for id = 1 : dg
    [maxi, ip] = max(rr);
    g(ip) = 1;
    rr(ip) = -1;
end
rr = abs(rr);
for id = 1 : dg
    [mini, ip] = min(rr);
    g(ip) = -1;
    rr(ip) = 1;
end
g_size = size(g, 2);
while g(g_size) == 0 && g_size > 1
    g = g(1 : g_size-1);
    g_size = g_size - 1;
end
% fprintf('the private key f is: ');
% display(f);
% fprintf('the private key g is: ');
% display(g);
%
% find the inverse of f in Rp 
% 
[fp, indexp] = multiplicative_inverse_NTRU(f, p);
% fprintf('the inverse of f in Rp is:');
% display(fp);
%
% check whether f * fp = 1 in Rp
%
ffp = multiplication_NTRU(f, fp, p);
% fprintf('check if f * fp == %d\n\n', ffp);
%
% find the inverse of f in Rq
%
[fq, indexq] = multiplicative_inverse_NTRU(f, q);
% fprintf('the inverse of f in Rq is: ');
% display(fq);
%
% check whether f * fq = 1 in Rq
%
ffq = multiplication_NTRU(f, fq, q);
% fprintf('check if f * fq == %d\n\n', ffq);
%
% compute h = fq * g in Rq
%
h = multiplication_NTRU(fq, g, q);
% fprintf('fq * g in Rq is: ');
% display(h);
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Encryption
%
% message: m
%
message = 'The essence of hacking is finding unintended or overlooked uses for the laws and properties of a given situation and then applying them in new and inventive ways to solve a problem whatever it may be. ';
message_len = length(message);
N5 = floor(N / 5) - 1;
mN = ceil(message_len / N5);
mR = mod(message_len, N5);
if mR ~= 0
    m = zeros(1, N);
    for im = 1 : mN-1
        ml = N5;
        for i = 1 : 5
            m(im, i) = mod(ml, 3);
            ml = floor(ml/ 3);
        end
        for j = 1 : N5
            % valid ASCII code for text range from 32 ~ 126
            ma = double(message((im-1)*N5 + j)) - 31;
            for i = 1 : 5
                m(im, j*5 + i) = mod(ma, 3);
                ma = floor(ma/ 3);
            end
        end
        for in = 5*(N5 + 1) : N
            m(im, in) = floor(3*rand(1));
        end
    end
    %
    im = mN;
    ml = mR;
    for i = 1 : 5
        m(im, i) = mod(ml, 3);
        ml = floor(ml / 3);
    end
    for j = 1 : mR
        ma = double(message(im-1)*N5 + j) - 31;
        for i = 1 : 5
            m(im, j*5 + i) = mod(ma, 3);
            ma = floor(ma / 3);
        end
    end
    for in = 5*(mR + 1) + 1 : N
        m(im, in) = floor(3*rand(1));
    end
    %
    m = m - 1;
    for im = 1 : mN
        m(im, N) = 1; % m(N) = 1, corner case
    end
elseif mR == 0
    m = zeros(1, N);
    % for im = 1 : mN-1
    for im = 1 : mN
        ml = N5;
        for i = 1 : 5
            m(im, i) = mod(ml, 3);
            ml = floor(ml/ 3);
        end
        for j = 1 : N5
            % valid ASCII code for text range from 32 ~ 126
            ma = double(message(im-1)*N5 + j) - 31;
            for i = 1 : 5
                m(im, j*5 + i) = mod(ma, 3);
                ma = floor(ma/ 3);
            end
        end
        % for in = 5*(N5 + 1) : N
        for in = 5*(N5 + 1) + 1 : N
            m(im, in) = floor(3*rand(1));
        end
    end
    %
    m = m - 1;
    for im = 1 : mN
        m(im, N) = 1; % m(N) = 1, corner case
    end
end
%
% r = [-1, 1, 0, 0, 0, -1, 1];
%
% random generation of r
%
dr = 2;
r = zeros(1, N);
rr = rand(1, N);
for id = 1 : dr
    [maxi, ip] = max(rr);
    r(ip) = 1;
    rr(ip) = -1;
end
rr = abs(rr);
for id = 1 : dr
    [mini, ip] = min(rr);
    r(ip) = -1;
    rr(ip) = 1;
end
r_size = size(r, 2);
while r(r_size) == 0 && r_size > 1
    r = r(1 : r_size-1);
    r_size = r_size - 1;
end
%
% ciphertext: e = p.r*h + m (mod q)
%
rh = multiplication_NTRU(r, h, q); % rh == r * h
prh = mod(p * rh, q);              % prh == p . r*h
e = zeros(mN, N);
for im = 1 : mN
    e(im, :) = addition_NTRU(prh, m(im, :), q); % e = addition_NTRU(e, m, q);
end
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Decryption
%
% a = f * e (mod q) ---> center-lift
%
ee = e;
RR_message = zeros(1, 0);
for im = 1 : mN
    e = ee(im, :);
    a = multiplication_NTRU(f, e, q);
    a_size = size(a, 2);
    for ia = 1 : a_size
        if a(ia) > floor((q-1) / 2)
            a(ia) = a(ia) - q;
        end
    end
    while a(a_size) == 0 && a_size > 1
        a = a(1 : a_size-1);
        a_size = a_size - 1;
    end
    %
    % b = a (mod p)
    %
    b = mod(a, p);
    b_size = size(b, 2);
    while b(b_size) == 0 && b_size > 1
        b = b(1 : b_size-1);
        b_size = b_size - 1;
    end
    %
    % message recovery: c = fp * b (mod p) ---> center-lift
    %
    c = multiplication_NTRU(fp, b, p);
    c_size = size(c, 2);
    for ic = 1 : c_size
        if c(ic) > floor((p-1) / 2)
            c(ic) = c(ic) - p;
        end
    end
    while c(c_size) == 0 && c_size > 1
        c = c(1 : c_size - 1);
        c_size = c_size - 1;
    end
    %
    % convert the ternary bits back to text
    %
    c = c + 1;
    R_message_len = 0;
    for i = 1 : 5
        R_message_len = R_message_len + c(i) * 3^(i-1);
    end
    R_message = zeros(1, R_message_len);
    for j = 1 : R_message_len
        for i = 1 : 5
            R_message(j) = R_message(j) + c(j*5 + i) *3^(i-1);
        end
    end
    R_message = R_message + 31;
    RR_message = [RR_message R_message];
end

for i = 1 : message_len
    RR_message(i) = char(RR_message(i));
end
%
%
fprintf('the original message is: %s\n', message);
fprintf('the recovery message is: %s\n', RR_message);
%
%

