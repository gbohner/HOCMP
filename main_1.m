addpath(genpath(fileparts(mfilename('fullpath')))); % Add folder to path

% clear all
% close all
%profile off;
%profile on;
set_opt; %Create the opt structure.


cd(opt.code_path);

% load('/nfs/data3/gergo/JimMarshel20150306/TEST/data_id_proj_2moments_test_vs_old.mat', 'opt')
% opt.output_file_prefix = 'data_id_proj_2_moments_test';

extractDataFromTif_parfor(opt.tiff_path,opt.data_path,opt);
Model_learn(opt.data_path, opt, opt.output_folder);

% % Extract data from Tiff into mat file
% extractDataFromTif_parfor('/nfs/data3/gergo/JimMarshel20150306/visualStim-004/visualStim-004_Cycle00001_CurrentSettings_Ch2_000001.tif','/nfs/data3/gergo/JimMarshel20150306/TMP/data_6proj_3moments_try2.mat',opt);
% extractDataFromTif_parfor('/nfs/data3/gergo/JimMarshel20150306/visualStim-004/visualStim-004_Cycle00001_CurrentSettings_Ch2_000001.tif','/nfs/data3/gergo/JimMarshel20150306/TMP/data_20proj_2moments_try2.mat',opt);

% extractDataFromTif_parfor('/nfs/data3/gergo/JimMarshel20150306/visualStim-004/visualStim-004_Cycle00001_CurrentSettings_Ch2_000001.tif','/nfs/data3/gergo/JimMarshel20150306/TMP/data_20proj_2moments_try3.mat',opt);
% Model_learn('/nfs/data3/gergo/JimMarshel20150306/TMP/data_20proj_2moments_try3.mat', opt, '/nfs/data3/gergo/JimMarshel20150306/TMP');



% input_folder = '/nfs/data3/gergo/Fhatarah';
% allfiles = dir([input_folder '/*.tif']);
% for i1 = 1:size(allfiles,1)
%   input_path = [input_folder '/' allfiles(i1).name];
%   nospacefname = allfiles(i1).name(~isspace(allfiles(i1).name));
%   data_path = [input_folder '/Results/' nospacefname(1:end-4) '/' nospacefname(1:end-4) '_preprocessed_data.mat'];
%   output_folder = [input_folder '/Results/' nospacefname(1:end-4)];

%% Step 1 - Data extraction and preprocessing

% set_opt; %Create the opt structure.

% input_path = '/nfs/data3/gergo/Fhatarah/m10039 R hem A24b.tif'; %Input file or folder
% data_path = '/nfs/data3/gergo/Fhatarah/Results/m10039RhemA24b/a1.mat'; %Preprocessed data file
% output_folder = '/nfs/data3/gergo/Fhatarah/Results/m10039RhemA24b'; % Output folder

% input_path = '/nfs/data3/gergo/Fhatarah/m10039 R hem M2.tif'; %Input file or folder
% data_path = '/nfs/data3/gergo/Fhatarah/Results/m10039RhemM2/a1.mat'; %Preprocessed data file
% output_folder = '/nfs/data3/gergo/Fhatarah/Results/m10039RhemM2'; % Output folder

% extractDataFromTif(input_path,data_path,opt);

%% Step 2 - Learning a new model
% Model_learn('/nfs/data3/gergo/Fhatarah/Results/m10039RhemA24b/a1.mat', opt, '/nfs/data3/gergo/Fhatarah/Results/m10039RhemA24b');


%% Step 3 - Inference using a learned model and preprocessed data
% model_path = '/nfs/data3/gergo/Fhatarah/Results/m10039RhemA24b/inference_model.mat';
% [ y, x_coord, y_coord, dLL ] = Inference(data_path, model_path,  output_folder, ...
%   struct('cells_per_image',400) ...
%   );

% end

%Visualize inference results
% figure; imagesc(y); colormap(gray);
% hold on;
% scatter(x_coord(1:150), y_coord(1:150), 55, 'r.');
% scatter(x_coord(151:300), y_coord(151:300), 55, 'g.');
% 
% figure; plot(dLL); xlabel('Object number'); ylabel('Delta Log Likelihood');


%profile off
%profile viewer
