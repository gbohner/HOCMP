function Yt1 = compute_t_moments(IsPt, T, sz, opt)
  
  %initialize moments
  Yt1 = cell([sz,opt.mom]);
  
   for mom = 1:opt.mom
    if mom == 1
%       Yt1(:,:,mom) = vecfun_cell(@get_first_moment, IsPt);
      Yt1(:,:,mom) = num2cell(IsPt./T,1);
    end
    if mom > 1
      Yt1(:,:,mom) = cellfun(@get_nth_moment, Yt1(:,:,mom-1), Yt1(:,:,1),'UniformOutput', 0);
    end
  end

%   IsPt = shiftdim(IsPt,2); %shift features into the first dimension
%   IsPt = mat2cell(IsPt,size(IsPt,1),ones(1,size(IsPt,2)),ones(1,size(IsPt,3))); %keep first dim features intact, divide along spaatial direction
%   
%   for mom = 1:opt.mom
%     if mom == 1
%       Yt1(:,:,mom) = cellfun(@get_first_moment, IsPt,'UniformOutput', 0);
%     end
%     if mom > 1
%       Yt1(:,:,mom) = cellfun(@get_nth_moment, Yt1(:,:,mom-1), Yt1(:,:,1),'UniformOutput', 0);
%     end
%   end
%   
% %   
% %   
%   function out = get_first_moment(v)
%     out=v./T;
%   end

  function out = get_nth_moment(vprev, v1) 
    % Multiply by T, because both of these have already been divided by T,
    % so atm we're 1/T^2 and we only want 1/T
    out = mply(vprev, v1', 0)*T;
  end
      
end
