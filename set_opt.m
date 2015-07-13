% Set up options

opt = struct(); 

opt.code_path = '/nfs/nhome/live/gbohner/Git_main/HOCMP'; %Code directory
opt.tiff_path = '/nfs/data3/gergo/JimMarshel20150306/visualStim-004/visualStim-004_Cycle00001_CurrentSettings_Ch2_000001.tif'; %Input data file (stack, or initial frame)
opt.data_path = '/nfs/data3/gergo/JimMarshel20150306/TEST0712/data_id_proj_2_mom_test.mat'; %Output preprocessed data
opt.output_folder = '/nfs/data3/gergo/JimMarshel20150306/TEST_ORIG'; %Output folder
opt.output_file_prefix = 'data_id_proj_2_mom_test_model'; %Output file names


% Model setup
opt.m = 17; % Basis function size in pixels
opt.NSS = 1; % Number of object types
opt.KS = 4; % Dimensionality of space per object type (i.e. number of basis functions per object type)

% Data extraction and preprocessing
opt.spatial_scale = 0.6; % Rescale data spatially (so that cell size matches basis function size)
opt.time_scale = 0.5; % Rescale data temporally
opt.init_sig1 = 15; %smoothing filter mean
opt.init_sig2 = 15; %smoothing filter variance
opt.data_type = 'frames'; %Input data type (frames / stack)
opt.src_string = 'Ch2_*'; %in case of loading multiple frames from a directory, look for this substring to load files (choose channel eg)
opt.mask = 0; % Set if the region of interest is only part of the image stack.
opt.rand_proj = opt.m^2; %for no dimensionality reduction. DO NOT CHANGE
opt.d = opt.rand_proj; %Easier to access later
opt.mom = 2; %Number of moments used

% Learning parameters
opt.niter = 10; % number of iterations
%opt.relweight = 10; % weighting between importance of covariance / mean (automatically set to 'optimal' value in Shared_main/extract_coefs.m)
opt.fig = 0; %Whether to visualize or not during learning
opt.ex          = 1; % what example image to display during training
opt.cells_per_image = 100; % a rough estimate of the average number of cells per image
opt.relweight = 1; %Relative weight between mean and correlation coeff.
opt.MP      = 0; % somewhat redundant: if set to 1 always uses one subspace per object
opt.inc     = 2; % every opt.inc iterations estimate a new subspace
opt.warmup = 1;
opt.learn   = 1; % do learning?
opt.spatial_push = @(grid_dist)logsig(0.5*grid_dist-floor(opt.m/2-1)); % Specified distance based function (leave as [] if not desired)

