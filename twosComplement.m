function tc = twosComplement( x,n )
%TWOSCOMPLEMENT computes two's complement representation of binary number
%   tc = twosComplement(x, n), gives the two's complement of binary number x (an
%   array of 1 and 0) in n bits.

temp = xor(x,ones(1,n)); %xor to convert 1s to 0s and vice versa
tc = binaryAdd(temp,[zeros(1,n-1) 1],n);    %add one to acquire two's comp.
end

