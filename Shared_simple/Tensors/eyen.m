function [ T ] = eyen( sz, diag )
%EYEN Creates a multi-dimensional identity tensor, with 1s along the given
%diagonal and 0s everywhere else

if nargin < 2
  diag = length(sz);
  warning('Gergo:eyen:noDiagGiven','No diagonal was given to fill, using last dimension');
end

dim_order_perm = [diag:length(sz),1:(diag-1)];
sz_perm = sz(dim_order_perm);
T = eye(sz_perm(1),prod(sz_perm(2:end)));
T = reshape(T,sz_perm);
T = ipermute(T,dim_order_perm);




end

