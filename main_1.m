clear all
close all
set_opt; %Create the opt structure (one in the current folder, could be put in the same folder as data, along with this main file)
cd(opt.code_path);

addpath(genpath(fileparts(mfilename('fullpath')))); % Add code folder to path
extractDataFromTif_parfor(opt.tiff_path,opt.data_path,opt); % Preprocessing / data extraction step
Model_learn(opt.data_path, opt, opt.output_folder); % Learning step (already does the inference step during learning)


