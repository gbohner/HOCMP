function [ output_args ] = Model_learn( data_path, opt_input, output_folder )
%MODEL_LEARN Summary of this function goes here
%   Detailed explanation goes here

load(data_path, 'y', 'y_orig', 'Y','opt'); %could load opt as well, but it may have changed

opt = merge_structs(opt, opt_input);

if opt.mask
  load(data_path, 'UserMask');
end

W  = Model_initialize( Y, opt);


% Params = [Nmax tErr PrVar size(y,1) opt.m Nmaps opt.relweight];

%% Run the learning
for n = 1:opt.niter 
    

    disp('start');
    tic;    
    %Compute convolution of Y with the filters as well as the "local Gram
    %matrices of filters to use in the matching pursuit step afterwards
    if n == 1
      %H does not exist
      H = floor(1+size(Y,1)*size(Y,2)*rand(opt.cells_per_image*10,1)); % create a random Hprev for locations used (in theory any/all location can be used for the regression)
    end
    [WY, GW, WnormInv] = compute_filters(y, Y, W, H, opt );
    
    [ H, X, L] = extract_coefs( WY, GW, WnormInv, W, opt);



%       %     tic;
%         [H, X, P, dLL, yres, Cres] = ...
%           extract_cov_coefs(Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, WC, Bkki, C, All_filter_conv, subs, opt);
%         toc;
% 
%         model = model_write( W, tErr, Bias, Params, Nmaps, isfirst, pos, subs, opt.NSS, opt.KS, PrVar, Nmax);
% 
%         save([output_folder '/cur_run_iter_' num2str(n) '.mat'], 'y','H','X','P','dLL','W','opt','model');
% 
%         W = update_dict(n,yres,Cres,H,W,X,P, All_filter_conv, subs,opt);
%       case 2
%         tic;
%         for t1 = 1:length(subs) %Iterate over object types
%           [ Wy(:,:,subs{t1}), Akki(subs{t1},subs{t1}), Bkki(subs{t1},subs{t1}), GW(:,:,subs{t1},subs{t1})] = ...
%           MEAN_compute_filters( y, W(:,:,[subs{t1}]) );
%         end
%         if opt.mask
%           [ H, X, dLL, yres] = MEAN_extract_coefs( Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, Bkki, subs, opt, UserMask );
%         else
%           [ H, X, dLL, yres] = MEAN_extract_coefs( Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, Bkki, subs, opt);
%         end
%         
%          model = model_write( W, tErr, Bias, Params, Nmaps, isfirst, pos, subs, opt.NSS, opt.KS, PrVar, Nmax);
% 
%  ave([output_folder '/cur_run_iter_' num2str(n) '.mat'], 'y','H','X','dLL','W','opt','model');
      save([output_folder '/' opt.output_file_prefix '_iter_' num2str(n) '.mat'],'H','X','L','W','opt')%         
%         W = MEAN_update_dict(n,yres,H,W,X,subs,opt);
%         toc;
%     end
%     
      
     
      
      

      [W] = update_dict(Y,H,W,opt,n+2);
      
      subs = {[1:(opt.NSS*opt.KS)]};

     update_visualize( y,H,reshape(W,opt.m,opt.m,size(W,2)),opt,subs);
%     end
    
    
    
    
    if rem(n,1)==0
        fprintf('Iteration %d , elapsed time is %0.2f seconds\n', n, toc)
    end
    

end

end

