function [out] = Correction( in )
%This function corrects for MATLAB's floating point arithmetic.

out = (round(in*1000)/1000);

end

