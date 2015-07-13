function [WY, GW, WnormInv] = compute_filters(y, Y, W, Hprev, opt )
%COMPUTE_FILTERS Computes the correlation between filter and data, plus the
% original MAP coefficients
%   Detailed explanation goes here

%Load the GPT (we dont really want to keep it memory all the time
if ~exist([opt.code_path filesep '/Precomputed/Precomputed_shift_tensor_window_' num2str(opt.m) '_moment_' num2str(opt.mom) '.mat'],'file')
  precompute_shift_tensors(opt);
end
load([opt.code_path filesep '/Precomputed/Precomputed_shift_tensor_window_' num2str(opt.m) '_moment_' num2str(opt.mom) '.mat'], 'GPT');

WY = zeros(size(Y,1),size(Y,2),opt.NSS*opt.KS,opt.mom); %big matrix storing the vector resulting of filtering for each location, filter and moment


% Compute the convolutions with the filters
for filt = 1:size(W,2); %Different filters
  Wcur = W(:,filt);
  Wcurc = Wcur(:);
  Wcurc = Wcurc./norm(Wcurc+1e-6); % make sure it has norm of 1.
  Yfilt = Y;
  Wconv = reshape(Wcurc,opt.m,opt.m);
  parfor t1 = 1:size(Y,3)
    Yfilt(:,:,t1) = conv2(Y(:,:,t1),Wconv,'same');
  end
  for mom = 1:opt.mom  
    WY(:,:,filt,mom) = mean(Yfilt.^mom,3);
  end
end


WnormInv = zeros(size(W,2),size(W,2),opt.mom); % Inverse Interaction between basis functions

%WnormInv should be in feature space tho
for filt1 = 1:size(W,2)
  for filt2 = 1:size(W,2)
    Wcur1 = W(:,filt1);
    Wcur2 = W(:,filt2);
    for mom = 1:opt.mom
      if mom>1, Wcur1 = mply(Wcur1, W(:,filt1)',0); end
      if mom>1, Wcur2 = mply(Wcur2, W(:,filt2)',0); end
      Wcur1 = Wcur1./norm(Wcur1(:)+1e-6); % make sure it has norm of 1.
      Wcur2 = Wcur2./norm(Wcur2(:)+1e-6); % make sure it has norm of 1.

      WnormInv(filt1,filt2,mom) = Wcur1(:)'*Wcur2(:); 
    end
  end
end

%Invert Wnorm
for mom = 1:opt.mom
  WnormInv(:,:,mom) = inv(WnormInv(:,:,mom)+eye(size(WnormInv,1),size(WnormInv,2))); % Regularized
end


% if opt.d == opt.m^2 %identity projection
%   Worig = W;
% else
%   %Update filter coefficients (MAP estimate at the locations found in the previous step, so we can find a Worig of the original subspace by regression, corresponding to the best possible inv(P)*W)
%   % Just do it for the first moment
% 
%   %Get patches from mean image to regress from
%   [~, dWorig, Hprev] = pick_patches( y, Y, Hprev, opt, 1);
% 
%   %Get MAP coefficient estimates for the current feature-space basis functions
%   xk = zeros([length(Hprev), size(W,2)]); 
%   for i1 = 1:length(Hprev)
%     [row,col] = ind2sub([size(WY,1),size(WY,2)], Hprev(i1));
%     for map = 1:size(W,2)
%       xk(i1,:) = xk(i1,:) + reshape(WY(row,col,map,1)*WnormInv(map,:,1),1,[]);
%     end
%   end
% 
%   %Do the regression to find the Worig
%   for i1 = 1:size(W,2)
%     Worig(:,i1) = regress(xk(:,i1),dWorig');
%   end
%   
% end
% 
% if 1==1 %opt.fig
%         subs = {[1:(opt.NSS*opt.KS)]};
% 
%      update_visualize( y,Hprev,reshape(Worig,opt.m,opt.m,size(W,2)),opt,subs);
% end



% Use Worig to compute the matching pursuit step in the original space
GW = cell(size(W,2), size(W,2), opt.mom); %Each filter combination at each moment


%Each cell is going to be a cell of (2*m-1)^2 shifts and at each shift and
%each moment we'll have a vector of features^moment to describe how much
%the corresponding WY entry is modified if we set the coeffecient of active
%filt1 at moment mom to 1.

% Use the Worig learned in the original mean space to compute the effects of the projection
% (instead of trying to invert the projection of the feature-space W)

Worig = W;

for filt1 = 1:size(W,2)
  for filt2 = 1:size(W,2)
    Wcur1 = Worig(:,filt1);
    Wcur2 = Worig(:,filt2);
    for mom = 1:opt.mom
      if mom>1, Wcur1 = mply(Wcur1, Worig(:,filt1)',0); end
      if mom>1, Wcur2 = mply(Wcur2, Worig(:,filt2)',0); end

      %flip all dimensions of the second filter, such that convolution
      %gives you nd correlation instead
%       Wcur2r = Wcur2;
%       Wcur2r = flipdim_all(Wcur2r);
      Wcur1 = Wcur1./norm(Wcur1(:)+1e-6); % make sure it has norm of 1.
      Wcur2 = Wcur2./norm(Wcur2(:)+1e-6); % make sure it has norm of 1.
      Wcur1c = Wcur1(:);
      Wcur2c = Wcur2(:);

      GW{filt1,filt2,mom} = zeros(2*opt.m-1, 2*opt.m-1);
      for s1 = 1:(2*opt.m-1)
        for s2 = 1:(2*opt.m-1)
          GW{filt1,filt2,mom}(s1,s2) = Wcur2c(GPT{s1,s2,mom}(:,2))'* Wcur1c(GPT{s1,s2,mom}(:,1)); %compute the shifted effect in original space via the shift tensors GPT. Because the Worigs were computed to correspond to the best inverse of the Ws
        end
      end
    end
  end
end

  
clearvars -except WY GW WnormInv

end

