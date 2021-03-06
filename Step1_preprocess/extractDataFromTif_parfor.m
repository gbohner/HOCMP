function [y, Y, opt] = extractDataFromTif_parfor( tif_path, output_path, varargin )
%EXTRACTDATAFROMTIF Extracts the relavant information from an input tif
%stack 
% - give input tif file name
% - output path for large .mat file
% - other arguments:
%   - options struct
%   -  ...
  

  narg = nargin;
  
  y = [];
  V = [];

  % Default opts
  opt.init_sig1 = 15; %smoothing filter large
  opt.init_sig2 = 0.5; %smoothing filter small
  opt.m = 15; %basis function size
  opt.spatial_scale =1 ; % resize images
  opt.time_scale = 1; % resample time
  opt.data_type = 'frames'; %frames / stack
  opt.src_string = 'Ch2'; %in case of loading multiple frames from a directory, look for this substring to load files
  
  opt.tif_path = tif_path;
  opt.output_path = output_path;
  
  %Merge default and input options
  if nargin>=3
    opt = merge_structs(opt, varargin{1});
  end
  
  if strcmp(opt.data_type, 'stack')
    info = imfinfo(tif_path);
    T = numel(info); % Number of frames
    sz = size(imresize(imread(tif_path,1),opt.spatial_scale)); % Image size
    if T>1
      Is = zeros([T, sz(1), sz(2)]); % Image stack
      for i2 = 1:T
          Is(i2,:,:) = imresize(double(imread(tif_path, i2)),opt.spatial_scale);
      end
    else
      Is = imresize(double(imread(tif_path)),opt.spatial_scale);
    end
  elseif strcmp(opt.data_type, 'frames')
    filepath = fileparts(tif_path);
    allfiles = dir([filepath '/*' opt.src_string '*']);
    T = size(allfiles,1);
    sz = size(imresize(imread([filepath '/' allfiles(1).name]),opt.spatial_scale));
    Is = zeros([T, sz(1), sz(2)]); % Image stack
    for i2 = 1:T
      Is(i2, :,:) = imresize(double(imread([filepath '/' allfiles(i2).name])),opt.spatial_scale,'bicubic');
    end
  end
  
  %Downsample in time (average in subsequent time windows)
  if opt.time_scale ~= 1
    Istmp = Is;
    T = floor(T *opt.time_scale);
    Is = zeros(T, sz(1),sz(2));
    for i2 = 1:T
      Is(i2,:,:) = mean(Istmp(ceil((i2-1)/opt.time_scale)+1:floor(i2/opt.time_scale),:,:),1);
    end
  end

  
  
  y = squeeze(mean(Is,1));
  y_orig = y;
  
  if opt.mask
    imshow(y);
    UserMask = roipoly(mat2gray(y));
  end
  
  if T>1
    V = squeeze(var(Is,1,1));
  else
    V = ones(size(y));
  end
  
  m = opt.m;
  
  edge_effect = conv2(ones(size(y)),ones(m),'same');
  
  % Apply normalizing filters  
  if T>1
    [y, A, B] = normal_img(double(y), opt.init_sig1, opt.init_sig2,V);
  else
    [y, A, B] = normal_img(double(y), opt.init_sig1, opt.init_sig2);
  end
  opt.A = A;
  opt.B = B;
  
  
  Is = bsxfun(@minus, Is, reshape(A,1,size(A,1),size(A,2))); %Subtract mean before covariance calculations
  for t1 = 1:T
    Is(t1,:,:) = squeeze(Is(t1,:,:)) ./ (opt.B.^0.5);
  end
%   Is = bsxfun(@minus, Is, mean(Is,1)); %Subtract mean before covariance calculations
  
  
  Y = shiftdim(Is,1); % it is now x*y*time

%	if opt.rand_proj
%		opt.P = createRandomProj(opt);
%	end
  
  save(output_path, 'Y', 'y', 'y_orig','V', 'opt','-v7.3');

  if opt.mask
    save(output_path, 'UserMask', '-append');
  end
  
  
  clearvars -except Y y opt

end
  
  
  

