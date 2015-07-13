function [ memsize, freemem ] = get_memory_unix()
%GET_MEMORY Returns the memory size and free memory remaining in GBs on Unix
%   Detailed explanation goes here

[r,w] = unix('free | grep Mem');
stats = str2double(regexp(w, '[0-9]*', 'match'));
memsize = stats(1)/1e6;
freemem = (stats(3)+stats(end))/1e6;

end

