 
function [Metabolites_ppm_data, Metabolites_ydata] = AlignFun_SMolESY_platform(features, intensities, ena_ppm ,num, txt, outputfolder, Samples_titles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2020                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %     
% This program is free software: you can redistribute it and/or modify  %
% it under the terms of the GNU General Public License as published by  %
% the Free Software Foundation, either version 3 of the License, or     %
% (at your option) any later version.                                   %
%                                                                       %
% This program is distributed in the hope that it will be useful,       %
% but WITHOUT ANY WARRANTY; without even the implied warranty of        %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         %
% GNU General Public License for more details.                          %
%                                                                       %
% You should have received a copy of the GNU General Public License     %
% along with this program.  If not, see <https://www.gnu.org/licenses/>.%
%                                                                       %    
% Email: p.takis@imperial.ac.uk                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Peak Calibration algorithm of processed 1D NMR spectra to a reference
% value taking into account the highest intesity peak in hte defined
% spectra region.
% 
% Inputs
% features: PPM data of each spectrum.
% intensities: Spectral data of each spectrum.
% ena_ppm: Number of points included in each ppm.
% bucket_width: The window of the bucketing
% num: 1) Min spectral region 2) Max spectral region 3) Ref for calibration
% position 4) Radius of Ref value for searching the max intensity peak
%
%


            B11 = intensities;
            A1 = features;
            test1 = size(B11);            
            Msize = size(txt);
            Msize = Msize(1,1);            
            H = test1(1); 
            for k=1:Msize % k is the number of spin systems of the input file
                for l = 1:H
                    
                    % alignment-peak depiction
                    A2 = A1(l,:);
                    Z111 = A2(A2 > num(k,2));
                    Z211 = A2(A2 < num(k,1));
                    Z111 = size(Z111);
                    Z111 = Z111(:,2);
                    Z211 = size(Z211);
                    Z211 = Z211(:,2);
                    L1 = size(B11(1,:));
                    L1 = L1(:,2);
                    Z211 = (L1 - Z211) + 1;
                    HA = num(k,3) + num(k,4);
                    HB = num(k,3) - num(k,4);
                    Z112 = A2(A2 > HA);
                    Z212 = A2(A2 < HB);
                    Z112 = size(Z112);
                    Z112 = Z112(:,2);
                    Z212 = size(Z212);
                    Z212 = Z212(:,2);
                    L = size(B11(1,:));
                    L = L(:,2);
                    Z212 = (L - Z212) + 1;
                    D = max(B11(l,Z112:Z212));
                    [i,ii] = ind2sub(size(B11(l,Z112:Z212)), find(B11(l,Z112:Z212)==D(1,1)));
                    A3 = A2(:,Z112:Z212);
                    D = A3(i,ii);
                    E = num(k,3) - D;
                    E = abs(E);
                    E1(1,:) = (E(1,1) * ena_ppm(l,1));  
                    % shifting Yaxis data
                    if (D < num(k,3))
                        KK(1,:) = Circulate_shiftNMR(B11(l,:),-E1(1,1));
                        KK1(1,1:length(Z111:Z211)) = KK(1,Z111:Z211);
                    elseif (D > num(k,3))
                        KK(1,:) = Circulate_shiftNMR(B11(l,:),+E1(1,1));
                        KK1(1,1:length(Z111:Z211)) = KK(1,Z111:Z211);
                    elseif (D == num(k,3))
                        KK(1,:) = Circulate_shiftNMR(B11(l,:),0);
                        KK1(1,1:length(Z111:Z211)) = KK(1,Z111:Z211);
                    end % shifting
                    A1111 = A2(:,Z111:Z211);
                    A_previous(l,1) = length(A1111);
                    try
                        if l==1
                            M{k,1}.data(l,1:length(A1111)) = KK1(1,1:length(A1111));
                            XAXIS{k,1}.data(l,1:length(A1111)) = A1111;
                        else
                            if length(A1111) == A_previous(l-1,1)
                                M{k,1}.data(l,1:length(A1111)) = KK1(1,1:length(A1111));
                                XAXIS{k,1}.data(l,1:length(A1111)) = A1111;
                            elseif length(A1111) > A_previous(l-1,1)
                                M{k,1}.data(l,1:A_previous(l-1,1)) = KK1(1,1:A_previous(l-1,1));
                                XAXIS{k,1}.data(l,1:A_previous(l-1,1)) = A1111(1,1:A_previous(l-1,1));
                            elseif length(A1111) < A_previous(l-1,1)
                                DIF = A_previous(l-1,1) - length(A1111);
                                M{k,1}.data(l,1:A_previous(l-1,1)) = KK(1,Z111:Z211+DIF);                             
                                XAXIS{k,1}.data(l,1:A_previous(l-1,1)) = A2(:,Z111:Z211+DIF);    
                            end
                        end
                    catch
                       KK1(1,1:length(A1111)) = 0; 
                       KK(1,length(A2)) = 0;
                       Samples_titles{l}
                       if l==1
                            M{k,1}.data(l,1:length(A1111)) = KK1(1,1:length(A1111));
                            XAXIS{k,1}.data(l,1:length(A1111)) = A1111;
                        else
                            if length(A1111) == A_previous(l-1,1)
                                M{k,1}.data(l,1:length(A1111)) = KK1(1,1:length(A1111));
                                XAXIS{k,1}.data(l,1:length(A1111)) = A1111;
                            elseif length(A1111) > A_previous(l-1,1)
                                M{k,1}.data(l,1:A_previous(l-1,1)) = KK1(1,1:A_previous(l-1,1));
                                XAXIS{k,1}.data(l,1:A_previous(l-1,1)) = A1111(1,1:A_previous(l-1,1));
                            elseif length(A1111) < A_previous(l-1,1)
                                DIF = A_previous(l-1,1) - length(A1111);
                                M{k,1}.data(l,1:A_previous(l-1,1)) = KK(1,Z111:Z211+DIF);                             
                                XAXIS{k,1}.data(l,1:A_previous(l-1,1)) = A2(:,Z111:Z211+DIF);    
                            end
                       end
                    end
                    clearvars KK1 KK D E E1 A1111...
                        Z111 Z211 Z212 Z112 L L1 i ii DIF 
                
                end % for number of spectra
                
                [row1,col1]=find(XAXIS{k,1}.data<num(k,1));
                col11 = unique(col1);
                [row2,col2]=find(XAXIS{k,1}.data>num(k,2));
                col22 = unique(col2);
                cols = [col11;col22];
                M{k,1}.data(:,cols) = [];
                XAXIS{k,1}.data(:,cols) = [];

                figure;
                xlim([num(k,1) num(k,2)]);
                xlabel('ppm')
                title([txt(k,1) ' without baseline (if selected)'])
                % Y-AXIS of all spectra (up to H) alligned according to (k spin systems)                       

                set(gcf,'visible','off');
                plot(XAXIS{k,1}.data',M{k,1}.data');set(gca,'XDir','reverse');xlim([num(k,1) num(k,2)])
                saveas(gcf, fullfile(outputfolder{k,1},[txt{k,1} '-Calibrated']), 'tif');
                figHandles = findobj('type', 'figure', '-not', 'name', 'SMolESY_platform');
                close(figHandles);
                set(gcf,'visible','on');
                clearvars MIN row col
            end % for number of analyzed metabolites spin systems
            Metabolites_ppm_data = XAXIS;
            Metabolites_ydata = M;
end


            
            
            
            
            
            