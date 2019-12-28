function varargout = transNOESY_platform(varargin)
% TRANSNOESY_PLATFORM MATLAB code for transNOESY_platform.fig
%      TRANSNOESY_PLATFORM, by itself, creates a new TRANSNOESY_PLATFORM or raises the existing
%      singleton*.
%
%      H = TRANSNOESY_PLATFORM returns the handle to a new TRANSNOESY_PLATFORM or the handle to
%      the existing singleton*.
%
%      TRANSNOESY_PLATFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSNOESY_PLATFORM.M with the given input arguments.
%
%      TRANSNOESY_PLATFORM('Property','Value',...) creates a new TRANSNOESY_PLATFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transNOESY_platform_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transNOESY_platform_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright to Dr. Panteleimon G. Takis, 2019                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %                                 


% Edit the above text to modify the response to help transNOESY_platform

% Last Modified by GUIDE v2.5 26-Dec-2019 00:46:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @transNOESY_platform_OpeningFcn, ...
                   'gui_OutputFcn',  @transNOESY_platform_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before transNOESY_platform is made visible.
function transNOESY_platform_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transNOESY_platform (see VARARGIN)

% Choose default command line output for transNOESY_platform
handles.output = hObject;
handles.PassExcel = 0;
handles.present_metabolite = 0;
handles.BEEPAA = 1;
handles.COMP(1,1) = NaN;
handles.Quantific(1,1) = 1;
handles.Buckets(1,1) = NaN;
handles.Pre_align(1,1) = NaN;
handles.Cursor_ON_OFF.String = 'Cursor OFF';
handles.Peak_Picking_Status.String = 'Peak picking is OFF';
% load pictures/images for the GUI
axes(handles.axes4)
Arrow = imread('arrow.png');
image(Arrow)
axis off
axis image

handles.BEEPAA = 1;

guidata(hObject, handles);
% load NMR spectrum in all axes

% Text in all notes panels

str1 = "1. Define the parent folder of the NMR spectra. AVOID names of spectra folders including spaces, symbols (e.g. -,\,/,@,$,% etc.) or starting with numbers.";
str2 = "2. Define the Output folder for exporting transNOESY, calibration and integration results.";
str3 = "3. *OPTIONAL: Load the excel input file for multiple Peaks calibration, integration.";
handles.Important_notes_panel.String = str1 + newline + str2 + newline + str3 + "OTHERWISE (i.e. for 1 metabolite at a time) proceed to the peak picking etc. steps ---->>"; 

% Update handles structure


% UIWAIT makes transNOESY_platform wait for user response (see UIRESUME)
% uiwait(handles.transNOESY_platform);


% --- Outputs from this function are returned to the command line.
function varargout = transNOESY_platform_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Name_Metabolite_Callback(hObject, eventdata, handles)
% hObject    handle to Name_Metabolite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Name_Metabolite as text
%        str2double(get(hObject,'String')) returns contents of Name_Metabolite as a double
global metab_name
metab_name = get(handles.Name_Metabolite, 'String');
mkdir(fullfile(handles.Results_folder_path,metab_name))
handles.one_metabolite_output = {fullfile(handles.Results_folder_path,metab_name)};
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Name_Metabolite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Name_Metabolite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear_PickPeak.
function Clear_PickPeak_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_PickPeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        global output_path myData
        output_path = handles.Results_folder_path;
        if  handles.BEEPAA == 1
            mm = msgbox('Peak picking is OFF. Please press ON');
            ah = get( mm, 'CurrentAxes' );
            ch = get( ah, 'Children' );
            set( ch, 'FontSize', 8 );            
            return
        elseif isempty(handles.BEEPAA)
            handles.Important_notes_panel.String = 'Please select the range of the spectrum (clicking the min-max points) and the position of the peak to integrate/calibrate.';
            axes(handles.NOESY_plot);cla
            axes(handles.transNOESY_plot);cla
            axes(handles.Aligned_transNOESY);cla           
            XAxis = handles.NOESY_Xaxes;
            NOESY = handles.NOESY_spectra;
            [row,col]=find(XAxis==min(nonzeros(XAxis)));
             MIN = XAxis(row,col);
             MIN = MIN(1,1);
            [row,col]=find(XAxis==max(nonzeros(XAxis)));
             MAX = XAxis(row,col);
             MAX = MAX(1,1);                        
            axes(handles.NOESY_plot);plot(XAxis',NOESY');set(gca,'XDir','reverse');xlim([MIN MAX])                        
            try    
                transNOESY = handles.transNOESY;
                axes(handles.transNOESY_plot);plot(XAxis',transNOESY');set(gca,'XDir','reverse');xlim([MIN MAX])
    
            catch
                handles.Important_notes_panel.String = 'There is no transNOESY data. Please press [transform_NOESY] button first.';
            end
            
            handles.Name_Metabolite.String = 'Name of the Metabolite';
            handles.Radius_input.String = '';            
            handles.Important_notes_panel.String = 'Please select the range of the spectrum (clicking the min-max points) and the position of the peak to integrate/calibrate.';                       
            myData = [];
            legend(handles.NOESY_plot,'off');
            legend(handles.transNOESY_plot,'off');
        end
guidata(hObject, handles);



% --- Executes on button press in Peak_Picking.
function Peak_Picking_Callback(hObject, eventdata, handles)
% hObject    handle to Peak_Picking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        global myData
        myData = [];        
        
        if  handles.BEEPAA == 1
            mm = msgbox('Peak picking is OFF. Please press ON');
            ah = get( mm, 'CurrentAxes' );
            ch = get( ah, 'Children' );
            set( ch, 'FontSize', 8 );
            set(handles.NOESY_plot, 'ButtonDownFcn',@buttonDownCallbackoff);
            set(handles.transNOESY_plot, 'ButtonDownFcn',@buttonDownCallbackoff);
        elseif isempty(handles.BEEPAA)
            handles.Important_notes_panel.String = 'Please select the range of the spectrum (clicking the min-max points) and the position of the peak to integrate/calibrate.';
        end
            
guidata(hObject, handles);


function buttonDownCallbackoff(o,e)
         return


% --- Executes on button press in PeakPick_ON.
function PeakPick_ON_Callback(hObject, eventdata, handles)
% hObject    handle to PeakPick_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        BeepA = [];
        handles.BEEPAA = BeepA;
        handles.Peak_Picking_Status.String = 'Peak picking is ON';
        handles.Important_notes_panel.String = 'Please select the range of the spectrum (clicking the min-max points) and the position of the peak to integrate/calibrate.';         
        set(handles.transNOESY_plot, 'ButtonDownFcn',@buttonDownCallbackc);hold on;
guidata(hObject, handles);


function buttonDownCallbackc(o,e)
         global myData
         pos = get(gca,'CurrentPoint');
         myData(end+1,:) = pos(1,1);
         pp = pos(1,1:2);
         xx = [pp(1,1) pp(1,1)];
         yy = [pp(1,2) (pp(1,2) + 30000)];
         plot(xx,yy,'b','LineWidth',1);hold on;set(gca,'XDir','reverse');hold on
         h = text(pp(1,1),(pp(1,2) + 30500),['\bf \fontsize{12} ' num2str(pp(1,1))]); 
         set(h, 'rotation', 90);

         
% --- Executes on button press in PeakPick_OFF.
function PeakPick_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to PeakPick_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        BeepA = 1;
        handles.BEEPAA = BeepA;
        handles.Peak_Picking_Status.String = 'Peak picking is OFF';
        str1 = "1. Define the parent folder of the NMR spectra. AVOID names of spectra folders including spaces, symbols (e.g. -,\,/,@,$,% etc.) or starting with numbers.";
        str2 = "2. Define the Output folder for exporting transNOESY, calibration and integration results.";
        str3 = "3. *OPTIONAL: Load the excel input file for multiple Peaks calibration, integration.";
        handles.Important_notes_panel.String = str1 + newline + str2 + newline + str3 + newline + "OTHERWISE (i.e. for 1 metabolite at a time) proceed to the peak picking etc. steps ---->>"; 
        handles.MetaboliteName.String = 'Name of the Metabolite';
        set(handles.transNOESY_plot, 'ButtonDownFcn',@buttonDownCallbackoff);        
guidata(hObject, handles);

% --- Executes on button press in Align_Signal.
function Align_Signal_Callback(hObject, eventdata, handles)
% hObject    handle to Align_Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData radius metab_name 

try
    XAxis = handles.NOESY_Xaxes;
    transNOESY = handles.transNOESY;
catch
    handles.Important_notes_panel.String = 'There is no transNOESY data. Please press [transform_NOESY] button first or please "Pick Peak" the spectral area to plot.';
end
if handles.PassExcel == 0
    input = sort(myData);    
    num = [input(1,1) input(3,1) input(2,1) radius];
    txt = {metab_name};
    output_folder = handles.one_metabolite_output;
    
elseif handles.PassExcel == 1
    
    num = handles.Excelfile_numbers;
    txt = handles.Excelfile_metabolites_names;
    for i = 1:length(txt)
        output_folder{i,1} = fullfile(handles.Results_folder_path,txt{i});
    end
else
    handles.Important_notes_panel.String = 'Please select/fill the approriate fields for calibrating/integrating the selected peak in the selected region of the transNOESY spectra.';
end

wb = waitbar(0, ['\bf \fontsize{12} Please wait for calibrating the selected NMR peaks...']);
wbc = allchild(wb);
jp = wbc(1).JavaPeer;
wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
jp.setIndeterminate(1);

[Metabolites_ppm_data, Metabolites_ydata] = AlignFun_transNOESY_platform(XAxis, transNOESY, handles.ppm_step, num, txt, output_folder);

figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
close(figHandles);

if  handles.PassExcel == 0        
        plot(handles.Aligned_transNOESY,Metabolites_ppm_data{1,1}.data',Metabolites_ydata{1,1}.data');legend(metab_name);
        set(handles.Aligned_transNOESY,'XDir','reverse');
        xlim([num(1,1) num(1,2)]);
    handles.cumulativeMetabolites_ppm = Metabolites_ppm_data;
    handles.cumulativeMetabolites_data = Metabolites_ydata;
elseif handles.PassExcel == 1
    handles.Important_notes_panel.String = 'Please press "Next Peak" --> "Plot" buttons to see the calibration of each peak from the excel file.';
    handles.cumulativeMetabolites_ppm = Metabolites_ppm_data;
    handles.cumulativeMetabolites_data = Metabolites_ydata;
end

guidata(hObject, handles);


% --- Executes on button press in Check_Selected_region.
function Check_Selected_region_Callback(hObject, eventdata, handles)
% hObject    handle to Check_Selected_region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
global myData
try
    XAxis = handles.NOESY_Xaxes;
    transNOESY = handles.transNOESY;
    axes(handles.Aligned_transNOESY);plot(XAxis',transNOESY');set(gca,'XDir','reverse');xlim([min(myData) max(myData)])    
catch
    handles.Important_notes_panel.String = 'There is no transNOESY data. Please press [transform_NOESY] button first or please "Pick Peak" the spectral area to plot.';
end


function Radius_input_Callback(hObject, eventdata, handles)
% hObject    handle to Radius_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Radius_input as text
%        str2double(get(hObject,'String')) returns contents of Radius_input as a double
global radius
Raddius = get(handles.Radius_input, 'String');
radius = str2num(Raddius);

% --- Executes during object creation, after setting all properties.
function Radius_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radius_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Spectra_folder.
function Spectra_folder_Callback(hObject, eventdata, handles)
% hObject    handle to Spectra_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.NOESY_plot);cla
    axes(handles.transNOESY_plot);cla
    NMRspectra = uigetdir;
    handles.NMRspectra_path = NMRspectra;
    % take the labels of the spectra
    files = dir(handles.NMRspectra_path);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    vresF = {subFolders.name}.';    
    % delete any empty cells
    KK = find(cellfun(@(x) isempty(x), vresF, 'UniformOutput', 1));
    vresF(KK) = [];
    KK1 = find(cellfun(@(x) isequal(x, '..'), vresF, 'UniformOutput', 1));
    vresF(KK1) = [];
    KK2 = find(cellfun(@(x) isequal(x, '.'), vresF, 'UniformOutput', 1));
    vresF(KK2) = [];
    KK3 = find(cellfun(@(x) isequal(x, '.DS_Store'), vresF, 'UniformOutput', 1));
    vresF(KK3) = [];
    clearvars KK KK1 KK2 KK3
    S = length(vresF);
    Samples_titles = vresF;
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading NMR data...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        % read real and imaginary NMR data
        for i = 1:S
            G1 = fullfile(handles.NMRspectra_path,vresF{i},'pdata','1');
            try
                W(i,1) = getNMRdata(G1);
            catch
                G11 = fullfile(handles.NMRspectra_path,vresF{i});
                files2 = dir(G11);
                dirFlags2 = [files2.isdir];
                subFolders2 = files2(dirFlags2);
                vresFsub = {subFolders2.name}.';    
                KK = find(cellfun(@(x) isempty(x), vresFsub, 'UniformOutput', 1));
                vresFsub(KK) = [];
                KK1 = find(cellfun(@(x) isequal(x, '..'), vresFsub, 'UniformOutput', 1));
                vresFsub(KK1) = [];
                KK2 = find(cellfun(@(x) isequal(x, '.'), vresFsub, 'UniformOutput', 1));
                vresFsub(KK2) = [];
                KK3 = find(cellfun(@(x) isequal(x, '.DS_Store'), vresFsub, 'UniformOutput', 1));
                vresFsub(KK3) = [];
                clearvars KK KK1 KK2 KK3
                G2 = fullfile(G11,vresFsub{1},'pdata','1');
                W(i,1) = getNMRdata(G2);
            end
        end
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        test = size(W);
        J = test(1);
        % End read real and imaginary NMR data

        for c=1:J
            B11(:,c) = W(c).Data;
            A2(:,c) = W(c).XAxis;
            C11(:,c) = W(c).IData;                
            % 1 ppm datapoints on Xaxis
            mikos(c,:) = length(A2(:,c));
            elaxisto(c,:) = min(A2(:,c));

            if elaxisto(c,:) < 0
               elaxisto(c,:) = abs(elaxisto(c,:));
            elseif elaxisto(c,:) >= 0
                elaxisto(c,:) = elaxisto(c,:);
            end 
            megisto(c,:) = max(A2(:,c));
            ola(c,:) = megisto(c,:) + elaxisto(c,:);
            ena_ppm(c,:) = mikos(c,:)/ola(c,:); 
            % end of 1 ppm datapoints calculation                       
        end
        one_ppm_step = ena_ppm;

        NOESY = B11';
        XAxis = A2';
        NOESYim = C11';
        handles.NOESY_spectra = NOESY;
        handles.NOESYim_spectra = NOESYim;
        handles.NOESY_Xaxes = XAxis;
        handles.ppm_step = one_ppm_step;
        handles.Samples_titles = Samples_titles;
        str1 = "NMR real/imaginary data is successfully read and loaded on the transNOESY platform.";
        handles.Important_notes_panel.String = str1 + newline + "Please define the [Output_folder].";
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        str1 = "ERROR: NMR real and/or imaginary data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.Important_notes_panel.String = str1 + newline + "Reminder: Imaginary spectral data is needed to run transNOESY platform.";
    end
    
guidata(hObject, handles);

% --- Executes on button press in Output_folder.
function Output_folder_Callback(hObject, eventdata, handles)
% hObject    handle to Output_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Results_folder = uigetdir;
    handles.Results_folder_path = Results_folder;
guidata(hObject, handles);


% --- Executes on button press in Excel_input.
function Excel_input_Callback(hObject, eventdata, handles)
% hObject    handle to Excel_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    
    [excel pathexcel] = uigetfile('*.xlsx');
    
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the excel file...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);   
    
    handles.Excelfile_path = [pathexcel excel];
    [num,txt,raw] = xlsread(handles.Excelfile_path);
    Msize = size(num);
    Msize = Msize(1);
    X = Msize + 1;
    txt = txt(2:X,1);
    handles.Excelfile_numbers = num;
    handles.Excelfile_metabolites_names = txt;
    handles.PassExcel = 1;
    for i = 1:length(txt)
        mkdir(fullfile(handles.Results_folder_path,txt{i}));
        handles.one_metabolite_output{i,1} = fullfile(handles.Results_folder_path,txt{i});
    end
    figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
    close(figHandles);
    handles.Important_notes_panel.String = "Excel file for multiple peaks calibration/integration is successfully loaded. You could proceed to their calibration by pressing [Calibrate signals] button. --->";
catch
    figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
    close(figHandles);
    handles.Important_notes_panel.String = "ERROR: There was a problem with loading the Excel file for multiple peaks calibration/integration.";
end

guidata(hObject, handles);


% --- Executes on button press in Plot_eg_NOESY_NMR.
function Plot_eg_NOESY_NMR_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_eg_NOESY_NMR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

XAxis = handles.NOESY_Xaxes;
NOESY = handles.NOESY_spectra;
axes(handles.NOESY_plot);plot(XAxis',NOESY');set(gca,'XDir','reverse');
guidata(hObject, handles);


% --- Executes on button press in OFF_cursor.
function OFF_cursor_Callback(hObject, eventdata, handles)
% hObject    handle to OFF_cursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Cursor_ON_OFF.String = 'Cursor OFF';

set (gcf, 'WindowButtonMotionFcn', @CursorData_mouseoverOFF)
legend(handles.NOESY_plot,'off');
legend(handles.transNOESY_plot,'off');
 guidata(hObject, handles);

function CursorData_mouseoverOFF (object, eventdata)

return

% --- Executes on button press in ON_cursor.
function ON_cursor_Callback(hObject, eventdata, handles)
% hObject    handle to ON_cursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Cursor_ON_OFF.String = 'Cursor ON';

set(gcf, 'WindowButtonMotionFcn', @CursorData_mouseover);
guidata(hObject, handles);


function CursorData_mouseover (hObject, eventdata)

C = get (gca, 'CurrentPoint');
if C(1,1) > 15.1 || C(1,1) < -10
    return
else
    legend(gca, {['\fontsize {14} \bf Peak position cursor: ' num2str(C(1,1)) ' ppm']});
end

% --- Executes on button press in transform_NOESY.
function transform_NOESY_Callback(hObject, eventdata, handles)
% hObject    handle to transform_NOESY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    DD = size(handles.NOESYim_spectra);
    % start waitbar
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for transforming NMR data...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);
    
    for c = 1:DD(1)
        NOE_tr(c,:) = gradient(handles.NOESYim_spectra(c,:),handles.NOESY_Xaxes(c,:));
        handles.Important_notes_panel.String = 'Please wait till the transformation of the NMR spectra is completed.';
    end
    figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
    close(figHandles); % close waitbar

    handles.Important_notes_panel.String = 'The transformation of the NMR spectra is completed. You could proceed with exporting the transformed spectra and their plotting.';
    handles.transNOESYinit = NOE_tr;
    handles.transNOESY = NOE_tr;
catch
    handles.Important_notes_panel.String = 'ERROR: The transformation of the NMR spectra cannot be completed.';
end

guidata(hObject, handles);


% --- Executes on button press in Plot_transNOESY.
function Plot_transNOESY_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_transNOESY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    if isnan(handles.COMP(1,1))
        XAxis = handles.NOESY_Xaxes;
        transNOESY = handles.transNOESY;
        axes(handles.transNOESY_plot);plot(XAxis',transNOESY');set(gca,'XDir','reverse');
        linkaxes([handles.transNOESY_plot handles.NOESY_plot],'off');
    elseif handles.COMP(1,1) == 1
        XAxis = handles.NOESY_Xaxes;
        transNOESY = handles.transNOESY;
        axes(handles.transNOESY_plot);plot(XAxis',transNOESY');set(gca,'XDir','reverse');
        linkaxes([handles.transNOESY_plot handles.NOESY_plot],'x');
    end
    
catch
     handles.Important_notes_panel.String = 'ERROR: There is no transNOESY data. Please press [transform_NOESY] button first.';
end
guidata(hObject, handles);


% --- Executes on button press in Export_int.
function Export_int_Callback(hObject, eventdata, handles)
% hObject    handle to Export_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.PassExcel == 0
    try    
        global metab_name
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for exporting integration data...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        
        if  handles.X_Ints == 0
            Integrals = handles.Ints{1,1}.Ints;
            Samples_titles = handles.Samples_titles;    
            T = table(Samples_titles,Integrals);
            T.Properties.VariableNames = {'Spectra_Titles', 'Integrals'};
            try
                writetable(T,[handles.one_metabolite_output{1,1} '/' metab_name '-integrals.txt'],'Delimiter','\t')
            catch
                writetable(T,[handles.one_metabolite_output{1,1} '\' metab_name '-integrals.txt'],'Delimiter','\t')
            end
            figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
            close(figHandles); % close waitbar
            handles.Important_notes_panel.String = ['Integrals are successfully exported to the file: [' fullfile(handles.one_metabolite_output{1,1},metab_name) '-integrals.txt]'];
        else
            Integrals = [handles.X_Ints;handles.Ints{1,1}.Ints];
            Samples_titles = [{'PPM'};handles.Samples_titles];    
            T = table(Samples_titles,Integrals);
            T.Properties.VariableNames = {'Spectra_Titles__PPM', 'Bucket'};
            try
                writetable(T,[handles.one_metabolite_output{1,1} '/' metab_name '-Bucket_table.txt'],'Delimiter','\t')
            catch
                writetable(T,[handles.one_metabolite_output{1,1} '\' metab_name '-Bucket_table.txt'],'Delimiter','\t')
            end
            figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
            close(figHandles); % close waitbar
            handles.Important_notes_panel.String = ['Buckets are successfully exported to the file: [' fullfile(handles.one_metabolite_output{1,1},metab_name) '-Bucket_table.txt]'];
        end
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles); % close waitbar        
        handles.Important_notes_panel.String = 'ERROR: Integrals/Buckets cannot be exported. Please check the given name of the [Peak], that should not be empty, not contain any spaces, symbols (e.g. -,\,/,@,$,% etc.) or starting with numbers.';
    end
    
    
    
elseif handles.PassExcel == 1
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for exporting integration data...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        for i = 1:length(handles.one_metabolite_output)            
            if  handles.X_Ints == 0
                Integrals = handles.Ints{i,1}.Ints;
                Samples_titles = handles.Samples_titles;
                T = table(Samples_titles,Integrals);
                T.Properties.VariableNames = {'Spectra_Titles', 'Integrals'};
                try
                    writetable(T,[handles.one_metabolite_output{i,1} '/' handles.Excelfile_metabolites_names{i,1} '-integrals.txt'],'Delimiter','\t');
                catch
                    writetable(T,[handles.one_metabolite_output{i,1} '\' handles.Excelfile_metabolites_names{i,1} '-integrals.txt'],'Delimiter','\t');
                end
            else
                Integrals = [handles.X_Ints{i,1}.X;handles.Ints{i,1}.Ints];
                Samples_titles = [{'PPM'};handles.Samples_titles];    
                T = table(Samples_titles,Integrals);
                T.Properties.VariableNames = {'Spectra_Titles__PPM', 'Bucket'};
                try
                    writetable(T,[handles.one_metabolite_output{i,1} '/' handles.Excelfile_metabolites_names{i,1} '-Bucket_table.txt'],'Delimiter','\t');
                catch
                    writetable(T,[handles.one_metabolite_output{i,1} '\' handles.Excelfile_metabolites_names{i,1} '-Bucket_table.txt'],'Delimiter','\t');
                end
            end                        
        end
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles); % close waitbar
        handles.Important_notes_panel.String = ['Each integral is successfully exported to .txt file under each folder at [' handles.Results_folder_path '] and named as indicated in the .xlsx file.'];
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles); % close waitbar        
        handles.Important_notes_panel.String = 'ERROR: Integrals/Buckets cannot be exported. Please check the given name of the [Peaks] in the .xlsx file, that should not contain any spaces, symbols (e.g. -,\,/,@,$,% etc.) or starting with numbers.';
    end
end


% --- Executes on button press in Perform_Integration.
function Perform_Integration_Callback(hObject, eventdata, handles)
% hObject    handle to Perform_Integration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Bucket_size
if handles.PassExcel == 0
     try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for integrating the selected region...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        if isnan(handles.Buckets(1,1)) && handles.Quantific(1,1) == 1 % Quantification
            for i = 1:size(handles.cumulativeMetabolites_data{1, 1}.data,1)
                Lv = handles.cumulativeMetabolites_data{1, 1}.data(i,:)>=0;
                PosPart = trapz(fliplr(handles.cumulativeMetabolites_ppm{1, 1}.data(i,Lv)),...                    
                    fliplr(handles.cumulativeMetabolites_data{1, 1}.data(i,Lv)),2);
                NegPart = trapz(fliplr(handles.cumulativeMetabolites_ppm{1, 1}.data(i,~Lv)),...                    
                    fliplr(handles.cumulativeMetabolites_data{1, 1}.data(i,~Lv)),2);
                SumParts = PosPart - NegPart;
                transNOESY_ints(i,1) = SumParts;
                clearvars Lv PosPart NegPart SumParts 
            end
        A{1,1}.Ints = transNOESY_ints;
        handles.Ints = A;
        handles.X_Ints = 0;
        else % Bucketing
            for i = 1:size(handles.cumulativeMetabolites_data{1, 1}.data,1)
                [Xmean,Buckets_intF] = create_buckets(handles.cumulativeMetabolites_ppm{1, 1}.data(i,:),handles.cumulativeMetabolites_data{1, 1}.data(i,:),Bucket_size);                                            
                Buckets_XAxis(i,1:length(Xmean)) = Xmean;
                Buckets_YAxis(i,1:length(Xmean)) = Buckets_intF; 
            end
            Buckets_XAxisF = mean(Buckets_XAxis,1);
%             for i = 1:size(handles.cumulativeMetabolites_data{1, 1}.data,1)
%                 transNOESY_ints(i,1) = trapz(fliplr(handles.cumulativeMetabolites_ppm{1, 1}.data(i,:)),...
%                 fliplr(handles.cumulativeMetabolites_data{1, 1}.data(i,:)),2);
%             end
        A{1,1}.Ints = Buckets_YAxis;
        handles.Ints = A;
        handles.X_Ints = Buckets_XAxisF;            
        end         
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        if isnan(handles.Buckets(1,1)) && handles.Quantific(1,1) == 1 % Quantification
            handles.Important_notes_panel.String = 'Integration for Quantification is successfully completed.'; 
        else % Bucketing
            handles.Important_notes_panel.String = 'Integration for Bucketing is successfully completed.'; 
        end
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);          
        handles.Important_notes_panel.String = 'ERROR: Integration cannot be completed. Check the Peak Picking values. Please note: there should be only 3 values.'; 
    end
    
elseif handles.PassExcel == 1
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for integrating the selected region...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        if isnan(handles.Buckets(1,1)) && handles.Quantific(1,1) == 1 % Quantification
            for k = 1:length(handles.Excelfile_metabolites_names)
                for i = 1:size(handles.cumulativeMetabolites_data{k, 1}.data,1)
                    Lv = handles.cumulativeMetabolites_data{k, 1}.data(i,:)>=0;
                    PosPart = trapz(fliplr(handles.cumulativeMetabolites_ppm{k, 1}.data(i,Lv)),...                    
                        fliplr(handles.cumulativeMetabolites_data{k, 1}.data(i,Lv)),2);
                    NegPart = trapz(fliplr(handles.cumulativeMetabolites_ppm{k, 1}.data(i,~Lv)),...                        
                        fliplr(handles.cumulativeMetabolites_data{k, 1}.data(i,~Lv)),2);
                    SumParts = PosPart - NegPart;
                    transNOESY_ints(i,1) = SumParts;
                    clearvars Lv PosPart NegPart SumParts
                end
                A{k,1}.Ints = transNOESY_ints;                                
            end
        handles.Ints = A;
        handles.X_Ints = 0;
        else % Bucketing
            for k = 1:length(handles.Excelfile_metabolites_names)
                for i = 1:size(handles.cumulativeMetabolites_data{k, 1}.data,1)
                    [Xmean,Buckets_intF] = create_buckets(handles.cumulativeMetabolites_ppm{k, 1}.data(i,:),handles.cumulativeMetabolites_data{k, 1}.data(i,:),Bucket_size);                                            
                    Buckets_XAxis(i,1:length(Xmean)) = Xmean;
                    Buckets_YAxis(i,1:length(Xmean)) = Buckets_intF;
                end                                
%                 for i = 1:size(handles.cumulativeMetabolites_data{k, 1}.data,1)                                        
%                     transNOESY_ints(i,1) = trapz(fliplr(handles.cumulativeMetabolites_ppm{k, 1}.data(i,:)),...                    
%                     fliplr(handles.cumulativeMetabolites_data{k, 1}.data(i,:)),2);
%                 end
                A{k,1}.Ints = Buckets_YAxis;
                Buckets_XAxisF{k,1}.X = mean(Buckets_XAxis,1);
            end
        handles.Ints = A;
        handles.X_Ints = Buckets_XAxisF;
        end
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        if isnan(handles.Buckets(1,1)) && handles.Quantific(1,1) == 1
            handles.Important_notes_panel.String = 'Integration for Quantification is successfully completed.'; 
        else
            handles.Important_notes_panel.String = 'Integration for Bucketing is successfully completed.'; 
        end
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);         
        handles.Important_notes_panel.String = 'ERROR: Integration cannot be completed. Check the .xlsx file Peak Picking values (min-max-calibration_center).'; 
    end
end

guidata(hObject, handles);


% --- Executes on button press in Export_trans_spectra.
function Export_trans_spectra_Callback(hObject, eventdata, handles)
% hObject    handle to Export_trans_spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isnan(handles.Pre_align(1,1))
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for exporting transformed NMR data...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);
        Trans = handles.transNOESYinit;
        Samples_titles = handles.Samples_titles;
        XAxis = handles.NOESY_Xaxes;
        Spectra = reshape([XAxis(:) Trans(:)]',2*size(XAxis,1), []);
        for i = 1:size(handles.transNOESY,1)
            PPM_Axis(i,1) = {['PPM-' Samples_titles{i}]};
        end   
        Samples_TitlesF = reshape([PPM_Axis(:) Samples_titles(:)]',2*size(PPM_Axis,1), []);
        T1 = table(Samples_TitlesF,Spectra);
        writetable(T1,fullfile(handles.Results_folder_path,'transNOESY_spectra.txt'),'Delimiter','\t','WriteVariableNames',false)
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        str1 = "The transformed spectral data has been successfully exported to the file: [";
        str2 = fullfile(handles.Results_folder_path,'transNOESY_spectra.txt]');
        str3 = "You could proceed with plotting the spectra and selecting any Peaks for calibration, integration.";
        handles.Important_notes_panel.String = str1 + str2 + newline + str3; 
    catch
        handles.Important_notes_panel.String = "ERROR: There is not any transformed spectral data to export. Please press [transform_NOESY] button first or define the [Output_folder].";
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
    end
elseif handles.Pre_align(1,1) == 1 % export spectra to Glucose anomeric proton (d at 5.25 ppm)
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for aligning to Glucose...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);        
        YAxis = handles.transNOESYinit;
        XAxis = handles.NOESY_Xaxes;
        
        [Trans_aligned,GLC_doublet] = Align_Glucose_transNOESY_platform(XAxis,YAxis,handles.Results_folder_path);
        D = abs(GLC_doublet(:,1) - GLC_doublet(:,2));
        [iMAX,~] = find(D > 0.007);
        [iMIN,~] = find(D < 0.0045);
        iMM = [iMAX;iMIN];
        
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');        
        close(figHandles);
        
        str1 = "The transformed spectral data has been successfully aligned to Glucose anomeric proton doublet";
        handles.Important_notes_panel.String = str1;
        
        wb = waitbar(0, ['Please wait for exporting the ALIGNED to Glucose transformed NMR data...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);        
               
        Samples_titles = handles.Samples_titles;
        
        Samples_titles_to_doubt = Samples_titles(iMM);
        
        Spectra = reshape([XAxis(:) Trans_aligned(:)]',2*size(XAxis,1), []);

        for i = 1:size(handles.transNOESY,1)
            PPM_Axis(i,1) = {['PPM-' Samples_titles{i}]};
        end   
        Samples_TitlesF = reshape([PPM_Axis(:) Samples_titles(:)]',2*size(PPM_Axis,1), []);
        T1 = table(Samples_TitlesF,Spectra);
        writetable(T1,fullfile(handles.Results_folder_path,'transNOESY_ALIGNED_to_GLUCOSE_spectra.txt'),'Delimiter','\t','WriteVariableNames',false)
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        str1 = "The transformed spectral data ALIGNED to GLUCOSE has been successfully exported to the file: [";
        str2 = fullfile(handles.Results_folder_path,'transNOESY_ALIGNED_spectra.txt');
        str21 = "]";
        str31 = "Please check the Aligned to GLUCOSE spectra at: [";
        str32 = fullfile(handles.Results_folder_path,'Check Alignment to Glucose.tif');
        str4 = "You could proceed with plotting the 'NOT-aligned' spectra and selecting any Peaks for calibration, integration.";        
        handles.Important_notes_panel.String = str1 + str2 + str21 + newline + str31 + str32 + str21 + newline + str4;
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);        
    catch
        handles.Important_notes_panel.String = "ERROR: There is not any transformed spectral data to export. Please press [transform_NOESY] button first or define the [Output_folder].";
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
    end               
end
     
guidata(hObject, handles);

% --- Executes on button press in Change_metabolite_next.
function Change_metabolite_next_Callback(hObject, eventdata, handles)
% hObject    handle to Change_metabolite_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.PassExcel == 1
    handles.present_metabolite = handles.present_metabolite + 1;
    if handles.present_metabolite > length(handles.Excelfile_metabolites_names)
        mm2 = msgbox('Reminder: There are no other Peaks. Press the [Previous Peak button].');
        ah2 = get( mm2, 'CurrentAxes' );
        ch2 = get( ah2, 'Children' );
        set( ch2, 'FontSize', 8 );        
    end
else
    mm2 = msgbox('There is a problem with the excel input file for multiple Peaks calibration, integration');
    ah2 = get( mm2, 'CurrentAxes' );
    ch2 = get( ah2, 'Children' );
    set( ch2, 'FontSize', 8 );            
end

guidata(hObject, handles);


% --- Executes on button press in Change_metabolite_previous.
function Change_metabolite_previous_Callback(hObject, eventdata, handles)
% hObject    handle to Change_metabolite_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.present_metabolite = handles.present_metabolite - 1;

if handles.present_metabolite == 0 || handles.present_metabolite < 0
            mm2 = msgbox('Reminder: Press the [Next Peak button].');
            ah2 = get( mm2, 'CurrentAxes' );
            ch2 = get( ah2, 'Children' );
            set( ch2, 'FontSize', 8 );
    handles.present_metabolite = 1;        
end
guidata(hObject, handles);

% --- Executes on button press in plot_excel.
function plot_excel_Callback(hObject, eventdata, handles)
% hObject    handle to plot_excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Aligned_transNOESY);cla

    plot(handles.Aligned_transNOESY,handles.cumulativeMetabolites_ppm{handles.present_metabolite,1}.data',handles.cumulativeMetabolites_data{handles.present_metabolite,1}.data');

set(handles.Aligned_transNOESY,'XLim',[min(handles.cumulativeMetabolites_ppm{handles.present_metabolite,1}.data(1,:)) max(handles.cumulativeMetabolites_ppm{handles.present_metabolite,1}.data(1,:))]);
set(handles.Aligned_transNOESY,'XDir','reverse');
legend(handles.Excelfile_metabolites_names{handles.present_metabolite,1}) 


% --- Executes on button press in Clear_plot.
function Clear_plot_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Aligned_transNOESY);cla
handles.present_metabolite = 0;

guidata(hObject, handles);


% --- Executes on button press in Link_Plots.
function Link_Plots_Callback(hObject, eventdata, handles)
% hObject    handle to Link_Plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Link_Plots

value1 = get(handles.Link_Plots, 'Value');
if value1 == 0
    handles.COMP(1,1) = NaN;
    linkaxes([handles.transNOESY_plot handles.NOESY_plot],'off');
else  
    handles.COMP(1,1) = 1;
    linkaxes([handles.transNOESY_plot handles.NOESY_plot],'x');
end
guidata(hObject, handles);


% --- Executes on button press in Int_Bucketing.
function Int_Bucketing_Callback(hObject, eventdata, handles)
% hObject    handle to Int_Bucketing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Int_Bucketing
Bucketing = get(handles.Int_Bucketing, 'Value');
if Bucketing == 0
    handles.Buckets(1,1) = NaN;    
else  
    handles.Buckets(1,1) = 1;    
end
guidata(hObject, handles);


% --- Executes on button press in Int_Quantification.
function Int_Quantification_Callback(hObject, eventdata, handles)
% hObject    handle to Int_Quantification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Int_Quantification

Quantif = get(handles.Int_Quantification, 'Value');
if Quantif == 0
    handles.Quantific(1,1) = NaN;    
else  
    handles.Quantific(1,1) = 1;    
end
guidata(hObject, handles);


% --- Executes on button press in Accumulate_Integrals.
function Accumulate_Integrals_Callback(hObject, eventdata, handles)
% hObject    handle to Accumulate_Integrals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isnan(handles.Buckets(1,1)) && handles.Quantific(1,1) == 1 % Quantification
    try
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for merging all integrals into a single file...']);
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);

        % Get a list of all files and folders in this folder.
        files = dir(handles.Results_folder_path);

        % Get a logical vector that tells which is a directory.
        dirFlags = [files.isdir];

        % Extract only those that are directories.
        subFolders = files(dirFlags);

        Peak_names = {subFolders.name}.';
        KK = find(cellfun(@(x) isempty(x), Peak_names, 'UniformOutput', 1));
        Peak_names(KK) = [];
        KK1 = find(cellfun(@(x) isequal(x, '..'), Peak_names, 'UniformOutput', 1));
        Peak_names(KK1) = [];
        KK2 = find(cellfun(@(x) isequal(x, '.'), Peak_names, 'UniformOutput', 1));
        Peak_names(KK2) = [];
        KK3 = find(cellfun(@(x) isequal(x, '.DS_Store'), Peak_names, 'UniformOutput', 1));
        Peak_names(KK3) = [];
        for i = 1:length(Peak_names)
            tempfold = fullfile(handles.Results_folder_path,Peak_names{i});
            fileList = dir(fullfile(tempfold,'*integrals.txt'));        
            if isempty(fileList)
               BB(i,1) = 0;
            else
                BB(i,1) = i;
            end
        end
        [y,yy] = find(BB == 0);
        BB(y) = [];
        Peak_namesN = Peak_names(BB);    
        for i = 1:length(Peak_namesN)
            tempfold = fullfile(handles.Results_folder_path,Peak_namesN{i});
            fileList = dir(fullfile(tempfold,'*.txt'));
            A = tdfread(fullfile(fileList.folder,fileList.name),'\t');
            CummulativeIntegrals(:,i) = A.Integrals;
            clearvars A fileList tempfold
        end

        Spectra = handles.Samples_titles;

        TT = table(Spectra,CummulativeIntegrals);
        TT = splitvars(TT, 'CummulativeIntegrals');
        TT.Properties.VariableNames = [{'Spectra_Titles'};Peak_namesN];
        writetable(TT,fullfile(handles.Results_folder_path, 'Cummulative_integrals.txt'),'Delimiter','\t')

        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);

        str1 = "The merged data has been successfully exported to the file: [";
        str2 = handles.Results_folder_path;
        handles.Important_notes_panel.String = str1 + str2 + "/Cummulative_integrals.txt]";     
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'transNOESY_platform');
        close(figHandles);
        handles.Important_notes_panel.String = "ERROR: Merging of integrals into one file is failed. Please check each integral separately.";
    end
else
    mm = msgbox('This function cannot be applied to Bucketing results');
    ah = get( mm, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 8 );            
    return 
end

guidata(hObject, handles);


% --- Executes on button press in Glucose_align_check.
function Glucose_align_check_Callback(hObject, eventdata, handles)
% hObject    handle to Glucose_align_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Glucose_align_check
Pre_align_Glucose = get(handles.Glucose_align_check, 'Value');
if Pre_align_Glucose == 0
    handles.Pre_align(1,1) = NaN;    
else  
    handles.Pre_align(1,1) = 1;    
end
guidata(hObject, handles);



function Bucket_width_input_Callback(hObject, eventdata, handles)
% hObject    handle to Bucket_width_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bucket_width_input as text
%        str2double(get(hObject,'String')) returns contents of Bucket_width_input as a double
global Bucket_size
Bucket_wid = get(handles.Bucket_width_input, 'String');
Bucket_size = str2num(Bucket_wid);
Test = str2num(Bucket_wid);
if Test < 0.001
    mm = msgbox('Bucket size should be > 0.001 PPM.');
    ah = get( mm, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 8 );            
    return
elseif Test > (max(handles.cumulativeMetabolites_ppm{1, 1}.data(1,:)) - min(handles.cumulativeMetabolites_ppm{1, 1}.data(1,:)))/2
    mm = msgbox('Bucket size should be at least twice smaller the selected spectral region, please increase the spectral region or decrease the bucket size.');
    ah = get( mm, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 8 );            
    return
elseif isempty(Test)
    mm = msgbox('Please enter the bucket size.');
    ah = get( mm, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 8 );            
    return
else
end



% --- Executes during object creation, after setting all properties.
function Bucket_width_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bucket_width_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
