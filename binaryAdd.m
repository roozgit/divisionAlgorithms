function result = binaryAdd( A, B, n )
%BINARYADD adds two binary numbers
%   result = binaryAdd(A, B , n) simulates a n-bit binary adder which adds
%   binary numbers stored in arrays A & B. Carry bit is dismissed.

result = zeros(1,n);
carries = zeros(1,n+1); %An array for storing the carry at each position

%A loop is created over the binary array. At each position, there are four
%possibilites: 0+0=1, 0+1=1, 1+1=0(with carry), 1+1+carry=1 (with carry)
for i = n : -1 : 1
    partialSum = A(i)+B(i)+carries(i+1);
    switch partialSum
        case 0
            result(i)= 0;
        case 1
            result(i)=1;
        case 2
            result(i)=0;
            carries(i)=1;
        case 3
            result(i)=1;
            carries(i)=1;
    end
end
end