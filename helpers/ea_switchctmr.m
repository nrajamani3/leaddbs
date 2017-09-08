function ea_switchctmr(varargin)
% varargin: handles, switchto (1=MR, 2=CT; optional).
% being called when new patient is loaded.
handles=varargin{1};
switchto=0;

if nargin==1 % autodetect
    % check if MRCT popup is set correctly
    modality=ea_checkctmrpresent(handles);
    switchto=find(modality);
    if any(modality)
        try
            if ~modality(get(handles.MRCT,'Value'))
                set(handles.MRCT,'Value',switchto);
            end
        end
    end
else
    % switch MRCT popup to specified handle.
    switchto=varargin{2};
end

if ~(sum(switchto>0)>1) && ~isempty(switchto) % e.g. MR and CT present
    switch switchto
        case 1 % MR
                set(handles.coregctmethod,'Enable','off');

                % PaCER:
                set(handles.reconmethod,'enable','off');
                set(handles.reconmethod,'Value',1); % set to TRAC/CORE algorithm.
                set(handles.targetpopup,'enable','on');
                set(handles.maskwindow_txt,'enable','on');

        case 2 % CT
                set(handles.coregctmethod,'Enable','on');

                % PaCER:
                set(handles.reconmethod,'enable','on');
                set(handles.reconmethod,'Value',2); % set to PaCER algorithm.
                %% can rm if statement once released.
                prefs=ea_prefs;
                    set(handles.targetpopup,'enable','off');
                    set(handles.maskwindow_txt,'enable','off');
    end
end

try
    ea_updatestatus(handles);
end
