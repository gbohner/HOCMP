function [ P] = createRandomProj( opt, varargin )
%CREATERANDOMPROJ Summary of this function goes here
%   Detailed explanation goes here
% 

if nargin == 1
% Random Projection
  P = randn(opt.rand_proj, opt.m^2);

else
  P = varargin{1};
end
% 

if opt.d == opt.m^2
%id_projection
  P = eye(opt.m^2);
end


% % Hand-designed features
% P1 = reshape(


% Normalization
P = bsxfun(@times, P, 1./sqrt(sum(abs(P).^2,2)));

opt.P = P;


% Compute gram matrix for all moments and shifts
% GP = cell(2*opt.m-1, 2*opt.m-1, opt.mom);
% 
% for mom1 = 1:opt.mom
%   szPf = [opt.d^mom1, opt.m^(2*mom1)]; %folded dimensions
%   szPuf = [opt.d^mom1, ones(1,2*mom1)*opt.m]; %unfolded dimensions in non-feature-space
%   if mom1 == 1
%     CurP = opt.P;
%   else
%     CurP = reshape(permute(mply_dims(CurP, opt.P),[1,3,2,4]),szPf);
%   end
%     CurPuf = reshape(CurP,szPuf);
%     % Handle the identity projection as special case
%     if opt.d == opt.m^2 %only realistic if we do identity projection
%       CurPinv = sparse(CurP);
%     else
%       fprintf('Starting pinv for moment %d\n', mom1);
%       tic;
%       CurPinv = pinv(CurP);
%       toc;
%     end
%     
%     %Iterate through shifts
%     for s1 = 1:(2*opt.m-1)
%       fprintf('Shift along direction 1 is currently %d\n',s1);
%       curm = opt.m; %just to use in the parfor not having to pass through the whole opt struct
%       parfor s2 = 1:(2*opt.m-1)
%         tic; GP{s1,s2,mom1} = reshape(shift(CurPuf,[(s1-curm)*(2:2:(3+2*(mom1-1))),(s2-curm)*(3:2:(3+2*(mom1-1)))]), szPf)*CurPinv; toc;
%         % Shift every dimension with s1-s2-s1-s2-etc then multiply with the
%         % inverse
%       end
%     end
% end

% save([opt.data_path(1:end-4) '_GP_save.mat'], 'P', 'GP');
  
  
    

% % Compute stuff we'll need later

% Compute the design tensor for each moment

% P_cur = opt.P; % d x m^2
% 
% All_P_tensors = cell(opt.mom,1);
% 
% All_P_tensors{1} = P_cur;
% 
% for mom1 = 2:opt.mom
%   P_cur = mply(P_cur, opt.P, 0);
%   P_cur = permute(P_cur, [1, 3, 2, 4]);
%   P_cur = reshape(P_cur, opt.d^(mom1), opt.m^(2*mom1));
%   All_P_tensors{mom1} = P_cur;
% end
% 
% size(P_cur);


% Compute the pseudoinverse of the design tensor along the design-direction
% for mom1 = 1:opt.mom
%   All_P_tensors_inv{mom1} = pinv(All_P_tensors{mom1});
% end

% Compute shift tensors
% All_shift_tensors = cell(opt.mom,1);
% for mom1 = 1:opt.mom
%  All_shift_tensors{mom1} = cell(2*m-1,2*m-1);
%  All_shift_tensors{mom1} = pinv(All_P_tensors{mom1});
% end




end

