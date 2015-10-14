function register = repBinary( x, n )
%REPBINARY binary represnetation of a psiitive or negative number
%   r = repBinary(x, n) represnts number x in n bits. If x <0, two's
%   complement represention of x is displayed.

%Initial conditions. make sure x is an integer and representable with n
%bits
 if ~isequal(size(x),[1 1])
     error('input argument must be a scalar')
 end
 
 %if mod(x,1) ~= 0 || x<-2^(n-1) || x>2^(n-1)-1
 %    error('Input argument out of boundary')
%end
 
 %Convert x to binary and represent it with n bits.
 if x>=0
     temp = de2bi(x,'left-msb');
     register = [zeros(1,n-length(temp)) temp];
 else
     register = de2bi(2^n-abs(x),'left-msb');
 end