function C = matrix_outer( A, B )
%MATRIX_OUTER Creates a 4d tensor as the outer product of 2d matrices
%   Detailed explanation goes here

% 3 equivalent versions

% C = zeros([size(A) size(B)]);
% 
% for i1 = 1:size(A,1)
%   for j1 = 1:size(A,2)
%     for u = 1:size(B,1);
%       for v = 1:size(B,2);
%         C(i1,j1,u,v) = A(i1,j1) * B(u,v);
%       end
%     end
%   end
% end

% C = mply(padarray(A,[0,0,1],0,'post'), shiftdim(padarray(B,[0,0,1],0,'post'),2));

C = reshape(A(:)*B(:)',[size(A),size(B)]);

end

