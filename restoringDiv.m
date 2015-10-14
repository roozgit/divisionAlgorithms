function ansmat = restoringDiv( A,Q,M )
%RESTORINGDIV performs restoring division algorithm
%   ansmat = restoringDiv(A, Q, M) returns the cell array ansmat. The first
%   element of ansmat is a matrix with each row showing one step of
%   restoring division algorithm. The second element of the cell array is a
%   text array which describes each step.

n = length(M);  %8 bit registers for our cases
M2c = twosComplement(M,n);  %Calculate M'

%check division by zero
if nnz(M) == 0 %if there are no nonzero elements it means M=0b0
    ansmat = {[A Q], {'DIVISION BY ZERO ERROR!'}};
    return
end

divmat = [A Q]; %divmat holds AQ combined registers at each step
stepDesc{1,1} ='0-Initialization';

Aregister=A;
Qregister=Q;
for i = 1: 3 : 3*n
    %We use circshift for shift left command. circhift replaces the LSB of
    %array with its MSB, therefore we need to change those values manually.
    Aregister = circshift(Aregister',-1)';
    Aregister(n)=Qregister(1);
    Qregister = circshift(Qregister',-1)';
    Qregister(n)=0;
    %Shift left is done. Store it in the next row of matrix
    divmat(i+1,:) = [Aregister Qregister];
    stepDesc{i+1,1} =strcat(num2str((i+2)/3),'-SHift Left AQ');
    
    divmat(i+2,:)=[binaryAdd(Aregister,M2c,n) Qregister];   %Add M'
    stepDesc{i+2,1}='A=A-M';

    if divmat(i+2,1)==1 %If A-M<0 (sign bit==1)
        divmat(i+3,:)=[Aregister Qregister]; %Restore Aregister from above
        stepDesc{i+3,1}='A<0, REStore, Q0=0';
    else
        Qregister(1,8)=1;   %Set Q0=1
        Aregister= divmat(i+2,1:8); %Do not restore. Update Aregister
        divmat(i+3,:)=[Aregister Qregister];
        stepDesc{i+3,1}='A>0, Q0=1';
    end
end

ansmat = {divmat, stepDesc}; %Return a cell array to display both the
%numerical steps and textual descriptions

end

