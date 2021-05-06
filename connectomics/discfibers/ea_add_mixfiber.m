function ea_add_mixfiber(~,~,leadgroup,resultfig)
% small function to open ea_mixfiberexplorer. lead group can be a path to
% either lead group analysis file or saved fiber explorer.
load(leadgroup);
if isfield(M,'AtlasDir')
    atlas_dir = M.AtlasDir;
    mixed_fibers(atlas_dir, resultfig);
else
    disp('Please Select the Atlas Folder in the GUI before running analysis')
    mixed_fibers('', resultfig);
    
end
% if ismember('M', who('-file',leadgroup)) % Add new discfiber analysis
%     mixed_fiber(leadgroup,resultfig);
%     ht=getappdata(resultfig,'ht');
%     uipushtool(ht, 'CData', ea_get_icn('mixedfiber'),...
%         'TooltipString', ['Explore Mixed Fiber Tract Analysis',tractId],...
%         'Tag', ['Explore Mixed Fiber Tract Analysis ',tractId],...
%         'ClickedCallback', {@ea_add_mixfiber,atlas_dir,resultfig});
%     
%     Tags = arrayfun(@(tool) tool.Tag, ht.Children, 'Uni', 0);
%     isMixFiberTool = contains(Tags, 'Explore Mixed Fiber Tract Analysis');
%     isAddMixFiberTool = contains(Tags, 'Add Mixed Fiber Tract Analysis');
%     if any(isMixFiberTool(2:end))
%         insertInd = find(isMixFiberTool(2:end),1);
%     else
%         insertInd = find(isAddMixFiberTool,1) -1;
%     end
%     ht.Children=ht.Children([2:insertInd,1,insertInd+1:end]);
% else % Load existing discfiber analysis

end
