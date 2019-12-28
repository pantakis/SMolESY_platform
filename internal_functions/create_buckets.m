
function [Xmean,Buckets_intF] = create_buckets(XAxis,YAxis,bucket_width)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2019                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Creating buckets (bins) of processed 1D NMR spectra
% 
% Inputs
% XAxis: PPM data of each spectrum
% YAxis: Spectral data of each spectrum
% bucket_width: The window of the bucketing
%
%


% first measure each bucket along the XAxis
if max(XAxis) > 0 && min(XAxis) > 0 || max(XAxis) > 0 && min(XAxis) == 0
    Bucket_times = (max(XAxis) - min(XAxis))/bucket_width;
    Bucket_times = round(Bucket_times,0);
elseif max(XAxis) > 0 && min(XAxis) < 0
    Bucket_times = (max(XAxis) - min(XAxis))/bucket_width;
    Bucket_times = round(Bucket_times,0);
elseif max(XAxis) < 0 && min(XAxis) < 0 || max(XAxis) == 0 && min(XAxis) < 0
    Bucket_times = (max(XAxis) + min(XAxis))/bucket_width;
    Bucket_times = round(Bucket_times,0);
end
   
for i = 1:Bucket_times
% calculate bucket
BUCKET(i,1) = min(XAxis) + (i-1)*bucket_width;
BUCKET(i,2) = min(XAxis) + i*bucket_width;
ind1 = interp1(XAxis(1,:),1:length(XAxis(1,:)),BUCKET(i,1),'nearest');
ind2 = interp1(XAxis(1,:),1:length(XAxis(1,:)),BUCKET(i,2),'nearest');
REFS(i,1) = ind1(1,1);
REFS(i,2) = ind2(1,1);
end
indFF = interp1(XAxis(1,:),1:length(XAxis(1,:)),max(XAxis),'nearest');
REFS(end,end) = indFF;
% integrate bucket and calculate mean ppm values for each bucket
for i = 1:Bucket_times
    if i == 1
        Buckets_int(1,i) = trapz(XAxis(1,REFS(i,2):REFS(i,1)),YAxis(1,REFS(i,2):REFS(i,1)),2);
        Xmean1(1,i) = mean([XAxis(1,REFS(i,2)) XAxis(1,REFS(i,1))],2);
        Xmean(1,i) = round(Xmean1(1,i),3);
    else
        Buckets_int(1,i) = trapz(XAxis(1,(REFS(i,2)+1):REFS(i,1)),YAxis(1,(REFS(i,2)+1):REFS(i,1)),2);
        Xmean1(1,i) = mean([XAxis(1,(REFS(i,2)+1)) XAxis(1,REFS(i,1))],2);
        Xmean(1,i) = round(Xmean1(1,i),3);
    end
end
Buckets_intF = -1*Buckets_int;
