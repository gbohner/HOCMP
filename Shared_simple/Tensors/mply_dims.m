function C = mply_dims( A, B, dimA, dimB )
%MPLY_DIMS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
  dimA = [];
  dimB = [];
end

tmpdimA = 1:ndims(A);
tmpdimA(dimA) = [];
szA = size(A);

tmpdimB = 1:ndims(B);
tmpdimB(dimB) = [];
szB = size(B);

C = reshape(permute(A,[dimA,tmpdimA]),prod(szA(dimA)),prod(szA(tmpdimA)))'*...
  reshape(permute(B,[dimB,tmpdimB]),prod(szB(dimB)),prod(szB(tmpdimB)));

C = reshape(ndSparse(C), [szA(tmpdimA), szB(tmpdimB)]);


end

