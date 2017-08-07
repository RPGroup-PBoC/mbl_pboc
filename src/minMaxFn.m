function [minVal, maxVal] = minMaxFn(array)
% This function returns the minimum and maximum value of any given array
% Parametrs
% ---------
% array : array-like
%    Array from which we want to obtain the minimum and maximum value.
% Returns
% -------
% minVal, maxVal : float
%    Minimum and maximum value respectively

minVal = min(array(:)); % Minimum value
maxVal = max(array(:)); % Maximum value

end %function