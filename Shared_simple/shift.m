function A = shift( A, shiftsize, varargin)
%SHIFT Shifts the array A noncircularly,inserting 0s (or, if specified as 3rd argument, something else) into empty spaces

if nargin == 3
  ins = varargin{1};
else
  ins = 0;
end

if ~issparse(A)
  sparse_mat = 0;
else
  sparse_mat = 1;
end

%Dont do unnecessary dimshifts, they are costy

to_shiftdim = [0, ones(1,length(shiftsize)-1), ndims(A)-length(shiftsize)+1]; %Add a last shiftdim to get back to original matrix
for i1 = 1:length(shiftsize)
  if shiftsize(i1) == 0,  to_shiftdim(i1+1) = to_shiftdim(i1+1) + to_shiftdim(i1); to_shiftdim(i1) = 0; end;
end


  for i1 = 1:length(shiftsize)
    if shiftsize(i1) == 0, continue; end;
    A = shiftdim(A, to_shiftdim(i1));
    sz = size(A);
    A = reshape(A,sz(1),[]);
    if sparse_mat == 0
      A = shift_first_dim(A, shiftsize(i1), ins);
    else
      A = shift_first_dim_sparse(A, shiftsize(i1), ins);
    end
    A = reshape(A,sz);
  end
  
  % Do the last shiftdim
  A = shiftdim(A,to_shiftdim(end));


function A = shift_first_dim(A, ssz, ins)
  %shifts first dimension of A by ssz
  if ssz == 0, return; end;
  if ssz >= size(A,1), A = ins * ones(size(A)); return; end;
  if ssz > 0
    %shift downwards
    validinds = ssz+1:size(A,1);
    A(validinds,:) = A(validinds-ssz,:);
    A(1:ssz,:) = ins; %insert the given value to places we shifted away from
  else
    ssz = abs(ssz);
    validinds = 1:(size(A,1)-ssz);
    A(validinds,:) = A(validinds+ssz,:);
    A((size(A,1)-ssz+1):end,:) = ins;
  end
end


function A = shift_first_dim_sparse(A, ssz, ins)
  %shifts first dimension of A by ssz
  if ssz == 0, return; end;
  if ssz >= size(A,1), 
    if ins == 0, A = sparse(size(A,1), size(A,2)); return; end;
    if ins ~= 0, A = ins * ones(size(A)); return; end;
  end
  
  [row,col,val] = find(A);
  
  row = row+ssz;
  good_inds = logical(((row>=1).*(row <= size(A,1))));
  
  A = sparse(row(good_inds),col(good_inds),val(good_inds),size(A,1),size(A,2));
  A = ndSparse(A);
  
end

end

