function [W] = update_dict(Y,H,W,opt,nIter)
%UPDATE_DICT Summary of this function goes here
%   Detailed explanation goes here
% Use the mean image to find a reasonable backprojection of W to the
% original space, via the locations


[dW] = pick_patches(Y,H,opt,1);
[U, Sv] = svd(dW,'econ');

if opt.fig
  figure(12);
  plot(diag(Sv));
end

W(:,1:min(size(W,2),nIter)) = U(:,1:min(size(W,2),nIter));

m = opt.m;
d = floor(m/2);

W = reshape(W,m,m,[]);
xs  = repmat(-d:d, m, 1);
ys  = xs';

absW = abs(W);
absW = absW/mean(absW(:));
x0 =  mean2(mean(absW,3) .* xs);
y0 =  mean2(mean(absW,3) .* ys);

xform = [1 0 0; 0 1 0; -x0 -y0 1];
tform_translate = maketform('affine',xform);

for k = 1:size(W,3)
    W(:,:,k) = imtransform(W(:,:,k), tform_translate,...
        'XData', [1 m], 'YData',   [1 m]);
    W(:,:,k) = W(:,:,k) - mean2(W(:,:,k));
    if std2(W(:,:,k))~=0
      W(:,:,k) = W(:,:,k)./std2(W(:,:,k));
    end
end

W = reshape(W,m^2,[]);

%Make sure all Ws are positive near the center
[~, mask] = transform_inds_circ(0,0,150,opt.m,max((opt.m-5)/2,1),0);
mask = logical(mask);
for k = 1:size(W,2)
  if sum(W(mask(:),k)) < sum(W(~mask(:),k))
    W(:,k) = -1.*W(:,k);
  end
end

end

