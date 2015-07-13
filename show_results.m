% Assuming there is already an opt loaded, otherwise remake or load the corresponding struct:
%set_opt 
%load(data_path, 'opt')

iter = 4;
load(opt.data_path, 'y', 'y_orig', 'opt');
load([opt.output_folder filesep opt.output_file_prefix '_iter_' num2str(iter) '.mat']);

subs = {[1:(opt.NSS*opt.KS)]};
update_visualize( y_orig,H,reshape(W,opt.m,opt.m,size(W,2)),opt,subs, 0);


% load('/nfs/data3/gergo/JimMarshel20150306/TEST/data_old_to_compare_to.mat', 'y_orig', 'y')
% 
% figure(1); imagesc(y); colormap gray
% figure(2); imagesc(y_orig); colormap gray
% 
% opt.data_path = '/nfs/data3/gergo/JimMarshel20150306/TEST/data_id_proj_2moments_test_vs_old.mat';
% load(opt.data_path, 'y', 'y_orig', 'opt');
% 
% 
% figure(3); imagesc(y); colormap gray
% figure(4); imagesc(y_orig); colormap gray
