function [py] = pick_patches( Y, H, opt, type)
%PICK_PATCHES Summary of this function goes here
%   Detailed explanation goes here

sz = [size(Y,1), size(Y,2)];

i1 = 1;
while i1<=size(H,1)
  [row,col,t] = ind2sub(sz,H(i1));
  if (t~=type)
    H(i1) = [];
  else
    i1 = i1+1;
  end
end

py = [];

%Pick the patches
for h1 = 1:size(H,1)
  [row,col,~] = ind2sub(sz,H(h1));
  [curpy] = get_n_order_patch(Y, row,col);
  py(:,end+1:end+size(curpy,2)) = curpy;
end

  function [out] = get_n_order_patch(Y,row,col)    
     % Compute changes in yres
     out = [];
     %Compute the corresponding patch tensors from Y
    patch = get_patch_time_block( Y, row,col, opt.m );
    patch = reshape(num2cell(reshape(patch,opt.m^2,[]),1),size(Y,3),1);
    patch = repmat(patch,[1,opt.mom]); %T * moments cell
    patch_out = cell(1,opt.mom);
    for mom = 1:opt.mom
      for t1 = 1:size(patch,2);
        if mom>1, patch{t1,mom} = mply(patch{t1,mom-1},patch{t1,1}',0); end
        if t1 == 1, patch_out{mom} = zeros(size(patch{t1,mom})); end; %initialize as 0s
        patch_out{mom} = patch_out{mom} + patch{t1,mom}./size(Y,3); %Add the patch's momth moment tensor divided by total time points
      end
    end
     
    for mom = 1:opt.mom
      cur = patch_out{mom};
      cur = reshape(cur,opt.d,[]);
      cur = cur./size(cur,2);
      out = [out, cur];
    end
  end

  function out = get_orig_patch(y, row,col)
    out = y((row-floor(opt.m/2)):(row+floor(opt.m/2)),(col-floor(opt.m/2)):(col+floor(opt.m/2)));
    out = out(:);
  end
            

  

end

