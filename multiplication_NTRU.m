%
% multiplication for NTRU
%
function out=multiplication_NTRU(a,b,p)
global N;
sa=size(a,2);
sb=size(b,2);
sc=sa+sb-1;
c=zeros(1,sc);
for i=1:sa
    c(i:i+sb-1)=c(i:i+sb-1)+a(i)*b;
end
if sc>N
    out=c(1:N);
    out(1:sc-N)=out(1:sc-N)+c(N+1:sc);
    so=N;
else
    out=c;
    so=sc;
end
out=mod(out,p);
while out(so)==0 && so>1
    out=out(1:so-1);
    so=so-1;
end
return