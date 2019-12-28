function NMRdata = getNMRdata(Folder1r1iprocs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2019                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Reading the real and inaginary part of processed 1D NMR spectra:
% 
% Inputs
% Folder1r1iprocs: The NMR folder containing the '1r', '1i', 'procs' files
% for each spectrum. 
%
% Algorithm contains also adapted parts from rbnmr.m function:
%
% Nils Nyberg, Copenhagen University, nn@sund.ku.dk
%
%

NMRdata = readNMR_real_imag(Folder1r1iprocs);


end



function NMRdata = readNMR_real_imag(Folder1r1iprocs)

r1path = fullfile(Folder1r1iprocs,'1r');
i1path = fullfile(Folder1r1iprocs,'1i');

Procs = readnmrpar(Folder1r1iprocs);
%% Open and read file
if Procs.BYTORDP == 0
    endian = 'l';
else
    endian = 'b';
end

[FID, MESSAGE] = fopen(r1path,'r',endian);
if FID == -1
	disp(MESSAGE);
	error(['Error opening file (',r1path,').']);
end

A.Data = fread(FID,'int32');
fclose(FID);

%% Read imaginary data if the file 1i exists
if (exist(i1path,'file')==2)
    [FID, MESSAGE] = fopen(i1path,'r',endian);
    if FID == -1
        % Do nothing
    end
    A.IData = fread(FID,'int32');
    fclose(FID);
end    

%% Correct data for NC_proc-parameter
A.Data = A.Data/(2^-Procs.NC_proc);
if (isfield(A,'IData'))
    A.IData = A.IData/(2^-Procs.NC_proc);
end

Procs.NC_proc = 0;

%% Calculate x-axis
A.XAxis = linspace( Procs.OFFSET,Procs.OFFSET-Procs.SW_p./Procs.SF,Procs.SI)';
NMRdata = A;
end 


function Procs = readnmrpar(Folder1r1iprocs)
% Read file
Procs_file = fullfile(Folder1r1iprocs,'procs');
A = textread(Procs_file,'%s','whitespace','\n');

% Det. the kind of entry
TypeOfRow = cell(length(A),2);
    
R = {   ...
    '^##\$*(.+)=\ \(\d\.\.\d+\)(.+)', 'ParVecVal' ; ...
    '^##\$*(.+)=\ \(\d\.\.\d+\)$'   , 'ParVec'    ; ...
    '^##\$*(.+)=\ (.+)'             , 'ParVal'    ; ...
    '^([^\$#].*)'                   , 'Val'       ; ...
    '^\$\$(.*)'                     , 'Stamp'     ; ...
    '^##\$*(.+)='                   , 'EmptyPar'  ; ...
	'^(.+)'							, 'Anything'	...
    };

for i = 1:length(A)
    for j=1:size(R,1)
        [s,t]=regexp(A{i},R{j,1},'start','tokens');
        if (~isempty(s))
            TypeOfRow{i,1}=R{j,2};
            TypeOfRow{i,2}=t{1};
        break;
        end
    end
end

% Set up the struct
i=0;
while i < length(TypeOfRow)
    i=i+1;
    switch TypeOfRow{i,1}
        case 'ParVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=TypeOfRow{i,2}{2};
        case {'ParVec','EmptyPar'}
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=[];
        case 'ParVecVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=TypeOfRow{i,2}{2};
        case 'Stamp'
            if ~isfield(Procs,'Stamp') 
                Procs.Stamp=TypeOfRow{i,2}{1};
            else
                Procs.Stamp=[Procs.Stamp ' ## ' TypeOfRow{i,2}{1}];
            end
        case 'Val'
			if isempty(Procs.(LastParameterName))
				Procs.(LastParameterName) = TypeOfRow{i,2}{1};
			else
				Procs.(LastParameterName) = [Procs.(LastParameterName),' ',TypeOfRow{i,2}{1}];
			end
        case {'Empty','Anything'}
            % Do nothing
    end
end
    

% Convert strings to values
Fields = fieldnames(Procs);

for i=1:length(Fields)
    DDD = Procs.(Fields{i});
    if isempty(DDD)
    else
        DDDD = str2num(DDD);
        if isempty(DDDD)
        else
            Procs.(Fields{i}) = DDDD;
        end
    end
end

end
