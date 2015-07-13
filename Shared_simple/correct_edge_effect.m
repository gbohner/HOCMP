function A = correct_edge_effect( A, conv_size, dims )
%CORRECT_EDGE_EFFECT Corrects the edge effect after convolution
%   A is tensor, m is convolution window size in a single dimension, dims
%   is the dimensions to correct;

if nargin < 3
  dims = 1:length(size(A));
end

dm = floor(conv_size/2);

% Cut down the padding at the given dimensions that convn has added in the
% previous step, and then correct the edge effects
Adims = 1:ndims(A);
Adims(dims) = [];
A = permute(A,[dims, Adims]);
A = A(dm+1:end-dm,dm+1:end-dm,:,:); % cut the paddings
A = ipermute(A,[dims,Adims]);


szA = size(A);
% a = {0:5,0:1,3:10};
szGr = cell(length(dims),1);
for i1 = 1:length(dims)
  szGr{i1} = 1:szA(dims(i1)); % grid size to evaluate stuff in
end
Gr = cell(numel(szGr),1);
[Gr{:}] = ndgrid(szGr{:}); % The position_based grid

for i1 = 1:length(dims)
  Gr{i1} = arrayfun(@(q)dist_edge(q,szA(dims(i1)),dm),Gr{i1}); %compute the distance from the edge in each element in each array
end

num_elems = ones(szA(dims));

for i1 = 1:length(dims)
  num_elems = num_elems.*Gr{i1};
end

permto = zeros(1,length(szA));
all_dims = (length(dims)+1):length(szA);
insert_what = 1;
for i1 = 1:length(szA)
  insert_next = 1;
  for i2 = 1:length(dims)
    if dims(i2)==i1
      permto(i1) = i2;
      insert_next = 0;
      break
    end
  end
  if insert_next
    permto(i1) = all_dims(insert_what);
    insert_what = insert_what + 1;
  end
end

szA_corrected = szA;
szA_corrected(dims) = 1;

A = A./repmat(permute(num_elems,permto), szA_corrected);



  function r = dist_edge(r,szSdim, dr)
    %Compute distance from nearest edge, but at most the (conv_window-1)/2
    %then add (conv_window-1)/2+1, to count how many elements are inside
    %the convoltuional window if we place it onto the location
    % then divide by the expected number of elements
    r = double((min(min(abs(r),abs(szSdim-r+1)),dr)+dr+1))/double((2*dr+1));
  end
    

end

