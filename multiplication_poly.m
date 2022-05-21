%
% multiplication for polynomials
%
function out=multiplication_poly(a,b,p)
sa=size(a,2);
sb=size(b,2);
sc=sa+sb-1;
c=zeros(1,sc);
for i=1:sa
    c(i:i+sb-1)=c(i:i+sb-1)+a(i)*b;
end
out=mod(c,p);
so=sc;
while out(so)==0 && so>1
    out=out(1:so-1);
    so=so-1;
end
return