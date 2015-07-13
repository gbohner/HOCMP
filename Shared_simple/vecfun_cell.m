function out = vecfun_cell( fun, A, dim )
%VECFUN Applies a function to the vector in the specified dimension of A,
%then gathers the output into cell array corresponding to the rest of the
%dimensions
%   Detailed explanation goes here

szA = size(A);
perm_dims = 1:length(szA);
perm_dims(1) = dim;
perm_dims(2:dim) = 1:(dim-1);
% put dim first, shift the rest

if dim ~= 1
  A = permute(A,perm_dims);
end

  A = reshape(A,size(A,1),[]);
  outdim = size(fun(A(:,1)));
  
  out = zeros([prod(outdim), size(A,2)]);
  
  for i1 = 1:size(A,2)
    cur_out = fun(A(:,1));
    out(:,i1) = cur_out(:);
  end
  
  out = reshape(out, [outdim, szA(perm_dims(2:end))]);
  out = num2cell(out,1);
  

end

