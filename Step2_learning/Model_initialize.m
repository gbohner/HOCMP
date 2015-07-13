function [W,  Worig]  = Model_initialize( Y, opt, varargin )
%MODEL_INITIALIZE Initializes the basis function matrices
%   Detailed explanation goes here

  if ~isfield(opt, 'NSS')
    opt.NSS = 1; % Number of object types
  end
  if ~isfield(opt, 'KS')
    opt.KS = 4; % Dimensionality of space per object type
  end
  
  W = zeros(opt.m^2, opt.NSS*opt.KS); % initialize basis functions
    
  
  if nargin ==2 
    % Initialize circles with reasonable size
    [~, mask] = transform_inds_circ(0,0,150,opt.m,(opt.m-1)/2,0); % . , . , ., filter size, circle outer radius, inner hole radius
    W(:,1) = mask(:);
%      [~, mask] = transform_inds_circ(0,0,150,opt.m,(opt.m-3)/2,0); % . , . , ., filter size, circle outer radius, inner hole radius
%     W(:,2) = mask(:);
%      [~, mask] = transform_inds_circ(0,0,150,opt.m,(opt.m-5)/2,0); % . , . , ., filter size, circle outer radius, inner hole radius
%     W(:,3) = mask(:);
  
  elseif nargin > 2
    % Second argument is type of initialization, third is the data needed for it
    switch varargin{1}
      case 'supervised'
        %learn the best basis functions from varargin{2}, which should be a
        %collection of examples
      case 'pointlike'
        % Initialize the last object type to a dot/small circle
        [~, mask] = transform_inds_circ(0,0,150,opt.m,3,0);
        W(:,(opt.NSS-1)*opt.KS+1) = mask(:);
    end
  end
  
  
  Worig = W;
  
  %Project the assumed initial basis function into feature space
%   if opt.rand_proj
%     W = opt.P*W;
%   end
  
  % Make sure that basis function column norms are ~1.
  
  W = bsxfun(@times, W, 1./sum(W.^2+1e-6,1));
  
  
  
  
  %% Initilize other variables
  
% m = opt.m;
% Nmaps = size(W,3);
% 
% subs = cell(1,opt.NSS);
% for i = 1:opt.NSS
%     subs{i} = (i-1)*opt.KS+1:i*opt.KS;
% end  
%     
% isfirst = zeros(1,Nmaps);
% for i = 1:opt.NSS
%     isfirst(subs{i}(1)) =  1;
% end
% 
% pos = zeros(Nmaps,1);
% for j = 1:length(subs)
%     pos(subs{j}(1)) = 0;
% end
% pos(1) = 1;
% 
% PrVar       = 1000;
% Nmax = 80;
% 
% Wy = zeros(size(y,1), size(y,2), Nmaps, 1);
% 
% Akki = zeros(Nmaps);
% Bkki = zeros(Nmaps);
% m = size(W,1);
% GW = zeros(2*m-1, 2*m-1, Nmaps, Nmaps);
% WC = cell((2*m-1)^2,1);
% All_filter_conv = cell((2*m-1)^2,1); %Store all filter_convultions
% for i1 = 1:(2*m-1)^2
%   WC{i1} = zeros([size(y), Nmaps]);
%   All_filter_conv{i1} = zeros([m,m,Nmaps]);
% end
% 
% sz = [size(y), length(subs)];
% 
% Bias = zeros(Nmaps,1);
% 
% oW = zeros(size(W));
%     
% tErr = 10.1;
  
end

