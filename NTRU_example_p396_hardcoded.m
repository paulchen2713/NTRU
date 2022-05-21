% 
% NTRU (N-th Truncated Ring Unit) with hard-coded f, g, m, r
%
clear;
clc;
%
global N;
% 
% public key: N, p, q, d, h
%
N = 7;
p = 3;
q = 41;
df = 2;
dg = 2;
% 
% private key: f, g 
% 
f = [-1, 0, 1, 1, -1, 0, 1];
g = [0, -1, -1, 0, 1, 0, 1];
% 
% find the inverse of f in Rp 
% 
[fp, indexp] = multiplicative_inverse_NTRU(f, p);
fprintf('fp = [%d  %d  %d  %d  %d  %d  %d]\n', fp); 
%
% check whether f * fp = 1 in Rp
%
ffp = multiplication_NTRU(f, fp, p);
fprintf('f * fp = %d\n', ffp);
%
% find the inverse of f in Rq
%
[fq, indexq] = multiplicative_inverse_NTRU(f, q);
fprintf('fq = [%d %d  %d %d %d %d %d]\n', fq); 
%
% check whether f * fq = 1 in Rq
%
ffq = multiplication_NTRU(f, fq, q);
fprintf('f * fq = %d\n', ffq);
%
% compute h = fq * g in Rq
%
h = multiplication_NTRU(fq, g, q);
fprintf('h  = [%d %d %d  %d %d  %d %d]\n', h);
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Encryption
%
% message: m
m = [1, -1, 1, 1, 0, -1];
%
r = [-1, 1, 0, 0, 0, -1, 1];
%
% ciphertext: e = p.r*h + m (mod q)
%
e = multiplication_NTRU(r, h, q);
e = mod(p * e, q);
e = addition_NTRU(e, m, q);
fprintf('\nthe encrypt text e is: [%d %d  %d %d  %d  %d %d]\n', e);
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
fprintf('the center-lifts a is: [%d %d  %d %d %d %d %d ]\n', a);
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
%
fprintf('the original message m is: [%d %d  %d  %d  %d %d]\n', m);
fprintf('the recovery message c is: [%d %d  %d  %d  %d %d]\n\n', c);
%
%


