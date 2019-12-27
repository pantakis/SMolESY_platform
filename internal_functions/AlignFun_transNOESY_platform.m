 
function [Metabolites_ppm_data, Metabolites_ydata] = AlignFun_transNOESY_platform(features, intensities, ena_ppm ,num, txt, outputfolder)
            
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
                figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
                close(figHandles);
                set(gcf,'visible','on');
                clearvars MIN row col
            end % for number of analyzed metabolites spin systems
            Metabolites_ppm_data = XAXIS;
            Metabolites_ydata = M;
end

function y_data = Circulate_shiftNMR(x_data,ppm_points)

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
            
            
            
            
            
            