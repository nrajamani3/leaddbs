function electrode=ea_elspec_elaine_rat_electrode(varargin)
% This function creates the electrode specification for a certain
% lead. Since this code is usually only executed once (to
% establish the model), it is not optimized in any way. You can however use
% this code to modify the electrode model and/or duplicate the function to
% build a different model.

% Set folder
elemodelPath = fileparts(mfilename('fullpath'));
modelFolder = 'ELAINE_Rat_Electrode_Components';

% Get specification
options.elmodel='ELAINE Rat Electrode';
options = ea_resolve_elspec(options);
elspec = options.elspec;

% Get insulation and contact numbers
numIns = numel(ea_regexpdir([elemodelPath, filesep, modelFolder,filesep, 'Insulations'], '.*\.smesh$'));
numCon = numel(ea_regexpdir([elemodelPath, filesep, modelFolder,filesep, 'Contacts'], '.*\.smesh$'));

%% Import insulations and contacts meshes
for k = 1:numIns
    filename = [elemodelPath, filesep, modelFolder, filesep, 'Insulations', filesep, 'ins', num2str(k), '.1'];
    [node,~,face]=readtetgen(filename);
    electrode.insulation(k).vertices = node;
    electrode.insulation(k).faces = face(:,1:3);
    clear face node filename
end

for k = 1:numCon
    filename = [elemodelPath, filesep, modelFolder, filesep, 'Contacts', filesep, 'con', num2str(k), '.1'];
    [node,~,face]=readtetgen(filename);
    electrode.contacts(k).vertices = node;
    electrode.contacts(k).faces = face(:,1:3);
    clear face node filename
end

%% Contact coordinates and other specifications
electrode.coords_mm(1,:)=[0 0 elspec.tip_length];

electrode.head_position = [0 0 elspec.tip_length]; % dummy value
electrode.tail_position = [0 0 elspec.tip_length*4]; % dummy value
electrode.x_position = [elspec.lead_diameter/2, 0, elspec.tip_length]; % dummy value
electrode.y_position = [0, elspec.lead_diameter/2, elspec.tip_length]; % dummy value

electrode.electrode_model = options.elmodel;
electrode.isdirected = elspec.isdirected;
electrode.numel = elspec.numel;
electrode.contact_color = elspec.contact_color;
electrode.lead_color = elspec.lead_color;

%% saving electrode struct
save([elemodelPath, filesep, elspec.matfname, '.mat'],'electrode');

%% create and save _vol file
filename = [elemodelPath, filesep, modelFolder, filesep, 'final.1'];
[node,~,face] = readtetgen(filename);
save([elemodelPath, filesep, elspec.matfname, '_vol.mat'],'face','node')
clear node face

%% visualize
if nargin
    vizz=0;
else
    vizz=1;
end

if vizz
    X = eye(4);
    aData = 1;

    figure;
    for ins=1:length(electrode.insulation)
        vs=X*[electrode.insulation(ins).vertices,ones(size(electrode.insulation(ins).vertices,1),1)]';
        electrode.insulation(ins).vertices=vs(1:3,:)';
        elrender=patch('Faces',electrode.insulation(ins).faces,'Vertices',electrode.insulation(ins).vertices);
        ea_specsurf(elrender,elspec.lead_color,aData);
    end

    for con=1:length(electrode.contacts)
        vs=X*[electrode.contacts(con).vertices,ones(size(electrode.contacts(con).vertices,1),1)]';
        electrode.contacts(con).vertices=vs(1:3,:)';
        elrender=patch('Faces',electrode.contacts(con).faces,'Vertices',electrode.contacts(con).vertices);
        ea_specsurf(elrender,elspec.contact_color,aData);
    end

    axis equal
    view(0,0);
end
