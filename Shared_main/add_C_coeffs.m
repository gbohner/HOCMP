function [C, WC] = add_C_coeffs( C, WC, W, H, P, All_filter_conv, subs, varargin )
%ADD_C_COEFFS Summary of this function goes here
%   Detailed explanation goes here

if nargin > 4
  if varargin{1} == 1
    %add the coeffs * basis function
    sig = 1;
  else
    %subtruct the coeffs * basis function
    sig = -1;
  end
else
  % By default, subtruct
  sig = -1;
end



sz = [size(C{1}), length(subs)];
m = size(W,1);
d = (m-1)/2;
Nmaps = size(W,3);
W1 = padarray(W,[d,d],0,'both');
[row,col,type] = ind2sub(sz,H(1));
maps_type = subs{type};


if isempty(WC)
%   skip_WC = 1;
  WC = cell((2*m-1)^2,1);
else
%   skip_WC = 0;
end

% WC = cell((2*m-1)^2,1);
% for i = 1:(2*m-1)^2
%   WC{i} = zeros([sz(1:2), Nmaps]);
% end

% Total_change_C = zeros(m);
% Total_change_WC = zeros(2*m-1,2*m-1,Nmaps);



 for sh = 1:((2*m-1)*(2*m-1))
%     c1 = (floor((sh-1)/(2*m-1))-(m-1)); %Shift along dim 1
%     c2 = (rem((sh-1), (2*m-1))-(m-1)); % Shift along dim 2

    
%     filter_conv = zeros(size(W));
%     % Compute the convolutions of Ws
%     for map = 1:size(W,3)
%       filter_conv(:,:,map) = W(:,:,map).*shift(W(:,:,map),[-c1,-c2]);
%     end
    
    for h1 = 1:size(H,1)
      [row,col,~] = ind2sub(sz,H(h1));
      [inds, cut] = mat_boundary(sz(1:2),row-d:row+d,col-d:col+d); % Inds for the spatial W, boundary based on the image boundary
      cell_added = zeros(m-cut(1,2)-cut(1,1),m-cut(2,2)-cut(2,1));
      for map = maps_type      
          cell_added = cell_added...
            + sig*All_filter_conv{sh}(1+cut(1,1):end-cut(1,2),1+cut(2,1):end-cut(2,2),map)*P(h1,map);
%             Total_change_C(1+cut(1,1):end-cut(1,2),1+cut(2,1):end-cut(2,2)) =...
%               Total_change_C(1+cut(1,1):end-cut(1,2),1+cut(2,1):end-cut(2,2)) + cell_added;
      end

      C{sh}(inds{1},inds{2}) = C{sh}(inds{1},inds{2}) + cell_added;
          
      if ~isempty(WC{sh})
        [inds, cut2] = mat_boundary(sz(1:2),row-(m-1):row+(m-1),col-(m-1):col+(m-1)); % total area of change in WC
        cut2 = cut2 - cut;
        
        %Reconvolve the change in C with all maps
        for map = 1:Nmaps  
          cell_added_conv = conv2(cell_added, rot90(All_filter_conv{sh}(:,:,map),2),'full');          

          WC{sh}(inds{1},inds{2},map) = WC{sh}(inds{1},inds{2},map) + cell_added_conv(1+cut2(1,1):end-cut2(1,2),1+cut2(2,1):end-cut2(2,2));
        end
      end
          
%           cut3 = cut2+cut;
%           Total_change_WC(1+cut3(1,1):end-cut3(1,2),1+cut3(2,1):end-cut3(2,2),map) = ...
%             Total_change_WC(1+cut3(1,1):end-cut3(1,2),1+cut3(2,1):end-cut3(2,2),map) + ...
%             cell_added_conv(1+cut2(1,1):end-cut2(1,2),1+cut2(2,1):end-cut2(2,2));
    end
  end
end

