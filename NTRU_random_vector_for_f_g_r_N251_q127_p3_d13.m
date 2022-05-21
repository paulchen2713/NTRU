% 
% NTRU (N-th Truncated Ring Unit) with randomized f, g, m, r, and large N
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
% m = [1, -1, 1, 1, 0, -1];
%
% random generation of m
%
m = floor(3 * rand(1, N));
for in = 1 : N
    if m(in) >= 0 && m(in) < 1
        m(in) = -1;
    elseif m(in) >= 1 && m(in) < 2
        m(in) = 0;
    else
        m(in) = 1;
    end
end
m(N) = 1;
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
e = multiplication_NTRU(r, h, q);
e = mod(p * e, q);
e = addition_NTRU(e, m, q);
% fprintf('\nthe encrypt text e is: [%d %d %d %d %d %d %d]\n', e);
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Decryption
%
% a = f * e (mod q) ---> center-lift
%
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
% fprintf('the center-lifts a is: [%d %d %d %d %d %d %d]\n\n', a);
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
% fprintf('the original message m is: ');
% display(m);
% fprintf('the recovery message c is: ');
% display(c);
%
% check if c == m ?
%
% any() will check if the array is empty or not, if its empty return 0
% in our case if c == m, then c - m == empty array, then will return 0
check_m_c = any(c - m);
if check_m_c == 0
    fprintf('Correct, c == m\n\n');
else
    fprintf('Incorrect, c != m\n\n');
end
%
%


