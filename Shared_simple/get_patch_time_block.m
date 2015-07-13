function patch = get_patch_time_block( Y, row,col, cutsize )
%GET_PATCH_TIME_BLOCK Summary of this function goes here
%   Detailed explanation goes here

d = floor(cutsize/2);

[ valid_inds, cuts ] = mat_boundary([size(Y,1),size(Y,2)], row-d:row+d, col-d:col+d);

patch = zeros(cutsize,cutsize,size(Y,3));

patch(1+cuts(1,1):end-cuts(1,2),1+cuts(2,1):end-cuts(2,2),:) = Y(valid_inds{1},valid_inds{2},:);


end

