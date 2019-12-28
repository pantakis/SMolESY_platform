function y_data = Circulate_shiftNMR(x_data,ppm_points)

% Adapted from:
% FSHIFT Fractional circular shift
%   Syntax:
%
%       >> y = fshift(x,s)
%
%   FSHIFT circularly shifts the elements of vector x by a (possibly
%   non-integer) number of elements s. FSHIFT works by applying a linear
%   phase in the spectrum domain and is equivalent to CIRCSHIFT for integer
%   values of argument s (to machine precision).

% Author:   François Bouffard
%           fbouffard@gmail.com



    existing_test = 0; 
    if size(x_data,1) == 1
        x_data = x_data(:); 
        existing_test = 1; 
    end
    N = size(x_data,1); 
    Round_closest = floor(N/2)+1; 
    f = ((1:N)-Round_closest)/(N/2); 
    p = exp(-1j*ppm_points*pi*f).'; 
    y_data = ifft(fft(x_data).*ifftshift(p)); 
    if isreal(x_data)
        y_data = real(y_data); 
    end
    if existing_test
        y_data = y_data.'; 
    end
end