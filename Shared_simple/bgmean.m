function [out, mask] = bgmean( A, percentile )
%BGMEAN Summary of this function goes here
%   Detailed explanation goes here

amin = min(A(:));
amax = max(A(:));

athresh = (amax-amin)*percentile + amin;

out = mean(A(A<athresh)); % The mean of the bottom percentile

if nargout >= 2
  mask = A<athresh; % The entries of A belonging to that bottom percentile
end

end

