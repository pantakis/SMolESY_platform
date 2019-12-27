
function [YOutput,GLC_doublet] = Align_Glucose_transNOESY_platform(XAxis,YAxis,outputfolder)

Spectra = size(YAxis,1);
for i = 1:Spectra    
    [~,ii] = find(XAxis(i,:) > 5.22 & XAxis(i,:) < 5.29);
    RRR = YAxis(i,ii);
    mikos = length(XAxis(i,:));
    elaxisto = min(XAxis(i,:));
    elaxisto = abs(elaxisto);
    megisto = max(XAxis(i,:));
    ola = megisto + elaxisto;
    ena_ppm(i,1) = mikos/ola;
    X1 = XAxis(i,ii);
    clearvars  mikos ola megisto elaxisto ii
    MAX1 = max(nonzeros(RRR(1,:)));
    [row1,col1]=find(RRR(1,:)==MAX1(1,1));
    MAXES(i,1) = X1(:,col1(1,1));
    RRR22 = RRR(1,:);
    RRR22(:,col1(1,1)-4:col1(1,1)+4) = [];
    X2 = X1;
    X2(:,col1-2:col1+2) = [];
    [row2,col2]=find(RRR22==max(nonzeros(RRR22)));
    MAXES(i,2) = X2(:,col2);
    MAXES(i,:) = sort(MAXES(i,:));
    E(i,:) = abs(5.25 - MAXES(i,2));
    E1(i,:) = E(i,1) * ena_ppm(i,1);
    clearvars X2 row1 col1 row2 col2 RRR22 RRR
    D = MAXES(i,2);
    if (D < 5.25)
        YAxis_align_GLC(i,:) = Circulate_shiftNMR(YAxis(i,:),-E1(i,:));
    elseif (D > 5.25)
        YAxis_align_GLC(i,:) = Circulate_shiftNMR(YAxis(i,:),+E1(i,:));
    elseif (D == 5.25)
        YAxis_align_GLC(i,:) = Circulate_shiftNMR(YAxis(i,:),0);
    end % shifting
    clearvars D
end


YOutput = YAxis_align_GLC;
GLC_doublet = MAXES;
f1 = figure('visible','off');
plot(XAxis',YOutput');set(gca,'XDir','reverse');xlim([5.22 5.27]);title('Check Alignment to Glucose');xlabel('PPM');
saveas(gcf, fullfile(outputfolder,'Check Alignment to Glucose'), 'tif');
close(f1);
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

