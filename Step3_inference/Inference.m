function [ y_orig, x_coord, y_coord, dLL ] = Inference( data_path, model_path, output_folder, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(data_path, 'opt');

switch opt.type
  case 1
    load(data_path, 'y','C');
  case 2
    load(data_path, 'y');
end

if opt.mask
  load(data_path, 'UserMask');
end

%Load the model
load(model_path, 'model')

%Overwrite loaded opt fields if there is input in varargin
if nargin>3
  optMapDefault = containers.Map(fieldnames(opt),struct2cell(opt)); %Create unique keys
  optMapInput = containers.Map(fieldnames(varargin{1}),struct2cell(varargin{1})); 
  optMap = [optMapDefault; optMapInput];
  opt = cell2struct(values(optMap),keys(optMap),2);
end

[W, m, Nmaps, subs, isfirst, pos, PrVar, Nmax, Wy, Akki, Bkki, GW, WC, All_filter_conv, sz, Bias, oW, tErr] = Model_initialize(y, opt);
[ W, tErr, Bias, Params, Nmaps, isfirst, pos, subs, NSS, KS, PrVar, Nmax ] = model_read( model );


timestamp = datestr(clock,30);

  switch opt.type
    case 1
      tic;
      for t1 = 1:length(subs) %Iterate over object types
        [ Wy(:,:,subs{t1}), WC1, Akki(subs{t1},subs{t1}), Bkki(subs{t1},subs{t1}), GW(:,:,subs{t1},subs{t1}), ...
          All_filter_conv1] = ...
          compute_filters( y, C, W(:,:,[subs{t1}]) );
        for i1 = 1:length(WC1)
          WC{i1}(:,:,subs{t1}) = WC1{i1};
          All_filter_conv{i1}(:,:,subs{t1}) = All_filter_conv1{i1};
        end
      end
      toc;



    %     tic;
      [H, X, P, dLL, yres, Cres] = ...
        extract_cov_coefs(Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, WC, Bkki, C, All_filter_conv, subs, opt);
      toc;

      save([output_folder '/inference_results_' timestamp '.mat'], 'y','H','X','P','dLL','W','opt','model');

    case 2
      tic;
      for t1 = 1:length(subs) %Iterate over object types
        [ Wy(:,:,subs{t1}), Akki(subs{t1},subs{t1}), Bkki(subs{t1},subs{t1}), GW(:,:,subs{t1},subs{t1})] = ...
        MEAN_compute_filters( y, W(:,:,[subs{t1}]) );
      end
      if opt.mask
        [ H, X, dLL, yres] = MEAN_extract_coefs( Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, Bkki, subs, opt, UserMask );
      else
        [ H, X, dLL, yres] = MEAN_extract_coefs( Wy, GW, Params, y, W, Bias, Akki, isfirst, pos, Bkki, subs, opt);
      end

      save([output_folder '/inference_results_' timestamp '.mat'], 'y','H','X','dLL','W','opt','model');

      toc;
  end
  
  %Convert H into x-y coordinates
  for i1 = 1:size(H,1)
    [y_coord(i1), x_coord(i1)] = ind2sub(size(y), H(i1));
  end
  
  load(data_path, 'y_orig')
  save([output_folder '/inference_results_' timestamp '.mat'], 'y_orig', 'x_coord', 'y_coord', '-append');

end

