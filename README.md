# HOCMP

The analysis of a calcium indicator tiff image stack is ran by running the main_1.m script in Matlab (mostly tested on Linux R2013b, requries image processing toolbox, for visualization).


All analysis parameters - including input file path - are within the set_opt.m script, so you will want to edit before anything. The main things to add:


%Directory structure

opt.code_path = <package location>

opt.tiff_path = <Input data file path> (tiff stack, or initial tiff frame)

opt.data_path = <intermediate folder>; %Output preprocessed data

opt.output_folder = %Output folder

opt.output_file_prefix = %Output file name prefixs

% Model setup

opt.m = 17; % Basis function size in pixels (approximate maximal cell size, if you downsample spatially (happens to 60% by default), change this accordingly)


The rest of the parameters are less crucial, their role explained within the set_opt file.


For each setting of the basis function size opt.m, the first run will be slow, as the software needs to precompute the full interaction Gram-matrix to ensure quick running during the iterative inference - dictionary-update process.


The output for now is saved in mat files with cell center locations H, learned basis functions W and reconstruction weights X. The ROIs can be then derived in multiple different ways (thresholding/reconstructing temporal signal quality/finding best projection space etc).




