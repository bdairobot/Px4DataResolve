function varargout = Px4DataResolve(varargin)
% px4dataresolve MATLAB code for Px4DataResolve.fig
%      px4dataresolve, by itself, creates a new px4dataresolve or raises the existing
%      singleton*.
%
%      H = px4dataresolve returns the handle to a new px4dataresolve or the handle to
%      the existing singleton*.
%
%      px4dataresolve('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in px4dataresolve.M with the given input arguments.
%
%      px4dataresolve('Property','Value',...) creates a new px4dataresolve or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Px4DataResolve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Px4DataResolve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Px4DataResolve

% Last Modified by GUIDE v2.5 23-Aug-2016 13:44:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Px4DataResolve_OpeningFcn, ...
                   'gui_OutputFcn',  @Px4DataResolve_OutputFcn, ...
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


% --- Executes just before Px4DataResolve is made visible.
function Px4DataResolve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Px4DataResolve (see VARARGIN)

% Choose default command line output for Px4DataResolve
handles.output = hObject;

colorList = [[0.929411764705882,0.333333333333333,0.337254901960784];...
              [1,0.807843137254902,0.329411764705882];...
              [0.282352941176471,0.811764705882353,0.678431372549020];...
             [0.364705882352941,0.611764705882353,0.925490196078431];...
              [0.925490196078431,0.529411764705882,0.752941176470588];...
              [0.627450980392157,0.831372549019608,0.407843137254902];...
              [0.309803921568627,0.756862745098039,0.913725490196078];...
              [0.674509803921569,0.572549019607843,0.925490196078431]];
handles.colorList = colorList;
handles.colorBackground = [0.94 0.94 0.94];
handles.fileImported = 0;
handles.sliderWidth = 10;
handles.radioHeight= 20;
% set(handles.tbtXYMode,'Value',0,'UserData',[]);

handles.InitPos.figPos = get(hObject,'Position');
handles.InitPos.optGroupPos = get(handles.OptionGroup,'Position');
handles.InitPos.varGroupGPos = get(handles.VariableGroup,'Position');
handles.InitPos.plotGroupPos = get(handles.AxesGroup,'Position');

handles.plotFileName = '../plot/default.plot';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Px4DataResolve wait for user response (see UIRESUME)
% uiwait(handles.Px4DataResolve);


% --- Outputs from this function are returned to the command line.
function varargout = Px4DataResolve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbtClean.
function pbtClean_Callback(hObject, eventdata, handles)
% hObject    handle to pbtClean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.fileImported == 0
    return;
end
lines = findall(handles.AxesPlot,'Type','line');
if ~isempty(lines)
    delete(lines);
end

radios = findall(handles.VariableGroup,'Style','radiobutton');
if ~isempty(radios)
    set(radios,'Value',0,'Foregroundcolor',[0 0 0]);
end

%adjust slider and name group

hTopNameGroup = handles.topNameGroup;
topVarNames = [];
set(hTopNameGroup,'UserData',topVarNames);

handles = redrawNameGroup(handles,topVarNames,handles.varNames);
guidata(hObject, handles);

% 
% hNameSlider = handles.nameSlider;
% 
% maxValue = get(hNameSlider,'Max');
% hNameGroup = handles.nameGroup;
% nameGroupPos = get(hNameGroup,'Position');
% topNameGroupPos = get(hTopNameGroup,'Position');
% 
% varNums = length(handles.varNames);
% radioHeight = handles.radioHeight;
% nameGroupPos(2) = topNameGroupPos(2) - varNums*radioHeight;
% set(hNameGroup,'Position',nameGroupPos);
% set(hNameSlider,'Value',maxValue);

set(handles.popuMode,'UserData',[]);

% --- Executes on button press in pbtOpenFile.
function pbtOpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to pbtOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileNameG, pathName] = uigetfile(...
        {'*.csv;*.px4log;*.mat',...
        'Data Files (*.csv,*.px4log,*.mat)'},...
        'Open file',...
        'MultiSelect','on',...
        '../data');

if ~isequal(pathName,0) && ~isequal(fileNameG,0)
    if ~iscell(fileNameG)
        fileNameG = cellstr(fileNameG);
    end
    for i = 1:length(fileNameG)
        fileName = fileNameG{i};
        fileIndex = strcat(pathName,fileName);
        handles.fileName = fileName;
        handles.pathName = pathName;
        guidata(hObject, handles);
        hMsgbox = msgbox('Loading file please wait !','modal');

        plotList = extractPlotList(handles.plotFileName);
        step = getStep(handles);

        if ~strcmp(fileName(end-3:end),'.csv') && ~strcmp(fileName(end-3:end),'.mat')
            delim = ',';
            time_field = 'TIME';
            data_file = [pathName,fileName(1:end-7),'.csv'];
            csv_null = '';
            %if there are hints: can not find python, please install python2.*
            %first, then add python path into System PATH
            s = system( sprintf('python sdlog2_dump.py "%s" -f "%s" -t"%s" -d"%s" -n"%s"', fileIndex, data_file, time_field, delim, csv_null) );

            px4_data = [];
            try
                temp_px4_data = importdata(data_file);
                [m, n] = size(temp_px4_data.textdata);

                if m == 1 %old data format
                    throw();
                end

                for i = 1:n
                    % any(), any 1 is exist
                    if any(strcmp(temp_px4_data.textdata{1,i},plotList))
                        if step == 1
                            temp_data = str2double(temp_px4_data.textdata(2:end,i));
                            eval(['px4_data.',temp_px4_data.textdata{1,i},'= temp_data;']);
                        else
                            for j = 2:floor((m-1)/step)
                                temp_data(j-1,i) = str2double(temp_px4_data.textdata{2+step*(j-2),i});
                            end
                            eval(['px4_data.',temp_px4_data.textdata{1,i},'= temp_data(:,i);']);
                        end

                    end
                end
            catch
                try%old data format
                    [m, n] = size(temp_px4_data.data);
                    for i = 1:n
                        if any(strcmp(temp_px4_data.textdata{1,i},plotList))
                            eval(['px4_data.',temp_px4_data.textdata{i},'= temp_px4_data.data(:,i);'])
                        end
                    end
                catch
                    hResolveErrorbox = warndlg('Old data format, resolve all data','Warnning!','modal');
                    px4_data = tdfread(data_file, ',');
                    delete(hResolveErrorbox);
                end

            end

            Hints(handles,'Conversion finished !');

            %delete .csv file only data is .px4log and save .mat file
            save([pathName,fileName(1:end-7),'.mat'],'px4_data');

        elseif strcmp(fileName(end-3:end),'.csv')   
            try
                temp_px4_data = importdata(strcat(pathName,fileName));
                [m, n] = size(temp_px4_data.textdata);

                if m == 1   %%old data format
                    throw();
                end

                for i = 1:n
                    if any(strcmp(temp_px4_data.textdata{1,i},plotList))
                        if step == 1
                            temp_data = str2double(temp_px4_data.textdata(2:end,i));
                            eval(['px4_data.',temp_px4_data.textdata{1,i},'= temp_data;']);
                        else
                            for j = 2:floor((m-1)/step)
                                temp_data(j-1,i) = str2double(temp_px4_data.textdata{2+step*(j-2),i});
                            end
                            eval(['px4_data.',temp_px4_data.textdata{1,i},'= temp_data(:,i);']);
                        end
                    end
                end
            catch
                try%old data format
                    [m, n] = size(temp_px4_data.data);
                    for i = 1:n
                        if any(strcmp(temp_px4_data.textdata{1,i},plotList))
                            eval(['px4_data.',temp_px4_data.textdata{i},'= temp_px4_data.data(:,i);'])
                        end
                    end
                catch
                    hResolveErrorbox = warndlg('No data struct match, trying resolve all data','Warnning!','modal');
                    px4_data = tdfread(data_file, ',');
                    delete(hResolveErrorbox);
                end

            end
            save([pathName,fileName(1:end-4),'.mat'],'px4_data');
        else
            load(fileIndex);
        end
    end
    
    if isfield(px4_data,'TIME_StartTime')
        Next_StartTime = px4_data.TIME_StartTime(2:end);
        Next_StartTime(end + 1) = 0;
        TIME_Period = (Next_StartTime - px4_data.TIME_StartTime)*1e-6;
        TIME_Period(end) = nan;
        px4_data.TIME_Period = TIME_Period;
    end
    
    assignin('base', 'px4_data', px4_data); %%Send to workspace
    %extract double variable form px4_data
    Hints(handles,[handles.fileName,'Extracting variable !']);
    
    varAllNames = fieldnames(px4_data);
    handles.px4_data = px4_data;
    guidata(hObject, handles);
    varNames = [];
    varAllNums = length(varAllNames);
    for i = 1:varAllNums
        tempValue = eval(['px4_data.',varAllNames{i}]);
        if strcmp(class(tempValue),'double')
            %NaN or not
            step = length(tempValue)/10;
            for index = 1:10
               if ~isnan(tempValue(floor(index*step)))
                   break;
               end
            end
            if index~= 10 %data is not nan
                varNames{end+1} = varAllNames{i};
            end
        end
    end
    
    delete(hMsgbox);
    hVarGroupChildren = get(handles.VariableGroup,'Children');
    if ~isempty(hVarGroupChildren)
        delete(hVarGroupChildren);
    end
    cla(handles.AxesPlot);
    handles.varNamesAll = varNames;
    guidata(hObject, handles);

    handles = redrawNameGroup(handles,'',handles.varNamesAll);
    
    Hints(handles,[handles.fileName,'variable inport finished !']);
    handles.fileImported = 1;
    guidata(hObject, handles);
else
    %
end

function step = getStep(handles)
value = get(handles.popuStep,'Value');
string = get(handles.popuStep,'String');

strValue = string{value};

step = str2num(strValue(1:2));


% --- Executes on button press in tagPlotList.
function tagPlotList_Callback(hObject, eventdata, handles)
% hObject    handle to tagPlotList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, pathName] = uigetfile(...
        {'*.plot',...
        'Data Files (*.plot)'},...
        'Open file',...
        '../plot');

if ~isequal(pathName,0) && ~isequal(fileName,0)
    fileIndex = strcat(pathName,fileName);
    handles.plotFileName = fileIndex;
end
Hints(handles,['Plot list is ',fileName]);

guidata(hObject, handles);


%used to extract optional plot name list
function plotList = extractPlotList(plotFileName)
plotNameList = importdata(plotFileName);
plotList = [];
templen = 1;

for i = 1:length(plotNameList)
    defalutPlotValue = plotNameList{i};
    
    index = 1;
    while strcmp(defalutPlotValue(index),char(9)) || strcmp(defalutPlotValue(index),' ');
        index = index + 1;
    end
    
    defalutPlotValue = defalutPlotValue(index:end);
    
    if ~strcmp(defalutPlotValue(1),'#')
        index = findstr(defalutPlotValue,'#');  %if there are some comments
        if isempty(index)
            index = length(defalutPlotValue);
        else
            index = index-1;
            defalutPlotValue = defalutPlotValue(1:index);
        end
        
        while strcmp(defalutPlotValue(index),char(9)) || strcmp(defalutPlotValue(index),' ');
            index = index - 1;
        end
        defalutPlotValue = defalutPlotValue(1:index);
        plotList{templen} = defalutPlotValue;
        templen = templen + 1;
    end
end



function handles = redrawNameGroup(handles,topVarNames,varNames)
%mode = 'init', first init of Variable group
%mode = 'creat',delete old filter group and create a new filter group
%mode = 'show',delete old filter group and show Name group
%topVarNames = varNames(1:6);
radioHeight = handles.radioHeight;

varNums = length(varNames);
varTopNmus = length(topVarNames);

%     newNameGroup = 'nameGroup';
%     newSlider = 'nameSlider';
%     topNameGroup = 'topNameGroup';
    
varGroupPos = get(handles.VariableGroup,'Position');
newSliderPos = [varGroupPos(3)-handles.sliderWidth,...
                0,...
                handles.sliderWidth,...
                varGroupPos(4)];
newTopNameGroupPos = [varGroupPos(1),...
                      varGroupPos(4) - varTopNmus*radioHeight,...
                      varGroupPos(3),...
                      varTopNmus*radioHeight];
newNameGroupPos = [newTopNameGroupPos(1),...
                   newTopNameGroupPos(2) - varNums*radioHeight,...
                   newTopNameGroupPos(3),...
                   varNums*radioHeight];
if newNameGroupPos(2) > 0
   newNameGroupPos(2) = 0;
   newNameGroupPos(4) = varGroupPos(4) - newTopNameGroupPos(4);
end

hNameSlider = findall(handles.VariableGroup,'Tag','nameSlider','Style','slider');               
hNameGroupAll = findall(handles.VariableGroup,'Tag','nameGroupAll','Type','uipanel');
hTopNameGroup = findall(handles.VariableGroup,'Tag','topNameGroup','Type','uipanel');
hFilterGroup = findall(handles.VariableGroup,'Tag','filterGroup','Type','uipanel');

%     if xor(isempty(hNameGroup),xor(isempty(hTopNameGroup), isempty(hNameSlider)))
%         delete(hNameGroup);
%         delete(hTopNameGroup);
%         delete(hNameSlider); 
%     end

if isempty(hNameGroupAll)
    hNameGroupAll = uipanel(handles.VariableGroup,...
             'Units','pixels',...
             'Position',newNameGroupPos,...
             'Tag','nameGroupAll',...
             'BackgroundColor',handles.colorBackground);
    hFilterGroup = uipanel(handles.VariableGroup,...
             'Units','pixels',...
             'Position',newNameGroupPos,...
             'Tag','filterGroup',...
             'Visible','off',...
             'BackgroundColor',handles.colorBackground,...
             'shadowColor',handles.colorBackground,...
             'HighlightColor',handles.colorBackground);
    %         'BackgroundColor',handles.colorBackground)
    %create radio uicontrol of variable
    for i = 1:varNums
        radioPos = [10,...
                    newNameGroupPos(4) - i*radioHeight,...
                    newNameGroupPos(3) - 20,...
                    radioHeight];
        hRadio = uicontrol('Parent',hNameGroupAll,...
           'Units','pixel',...
           'Style','radiobutton',...
           'FontSize',10,...
           'Position',radioPos,...
           'FontName','Monospaced',...
           'UserData',radioPos,...%save position information in userdata
           'String',varNames{i},...
           'Callback',@(hObject,eventdata)Px4DataResolve('radioSelection_CreateFcn',hObject,eventdata,guidata(hObject)));
    end
end

radios = findall(hFilterGroup,'Style','radiobutton');
if ~isempty(radios) 
    for i = 1:length(radios)
        originPos = get(radios(i),'UserData');
        set(radios(i),'Parent',hNameGroupAll,'Position',originPos);
    end
end

filter = get(handles.edtFilter,'UserData');
if filter == 1
    hNameGroup = hFilterGroup;
    set(get(hNameGroupAll,'Children'),'Visible','off');
    set(hNameGroup,'Visible','on','Position',newNameGroupPos);
    for i = 1:varNums
        radioPos = [10,...
                    newNameGroupPos(4) - i*radioHeight,...
                    newNameGroupPos(3) - 20,...
                    radioHeight];
        hRadio = findall(hNameGroupAll,...
                'String',varNames{i},'Style','radiobutton');
        
        set(hRadio,'Parent',hNameGroup,'Position',radioPos,'Visible','on');
    end
else
    hNameGroup = hNameGroupAll;
    set(get(hNameGroup,'Children'),'Visible','on');
    set(hFilterGroup,'Visible','off');
end

handles.nameGroup = hNameGroup;
nameGroupPos = get(hNameGroup,'Position');%adjust
if nameGroupPos(2)+nameGroupPos(4)<= newTopNameGroupPos(2) || newNameGroupPos(2)+newNameGroupPos(4) >= varNums*radioHeight
    set(hNameGroup,'Position',newNameGroupPos);
    
    for i = 1:varNums
        radioPos = [10,...
                    newNameGroupPos(4) - i*radioHeight,...
                    newNameGroupPos(3) - 20,...
                    radioHeight];
        hRadio = findall(hNameGroupAll,...
                'String',varNames{i},'Style','radiobutton');

        set(hRadio,'Parent',hNameGroup,'Position',radioPos,'Visible','on');
    end
end

if ~isempty(hTopNameGroup)
    hTopNameGroupChildren = get(hTopNameGroup,'Children');
    delete(hTopNameGroupChildren);
end


if isempty(hTopNameGroup)
    hTopNameGroup = uipanel(handles.VariableGroup,....
                     'Units','pixels',...
                     'Position',newTopNameGroupPos,...
                     'Tag','topNameGroup',...
                     'BackgroundColor',[0.800	0.820	0.851],...
                     'UserData',[]);
    %                 'BackgroundColor',handles.colorBackground)
else
    set(hTopNameGroup,'Position',newTopNameGroupPos);
end
%create radio uicontrol of variable in top name group
for i = 1:varTopNmus
    radioPos = [10,...
                newTopNameGroupPos(4) - i*radioHeight,...
                newTopNameGroupPos(3) - 20,...
                radioHeight];
    color = get(findall(handles.AxesPlot,'Tag',topVarNames{i}),'Color');
    uicontrol(hTopNameGroup,...
           'Units','pixel',...
           'Style','radiobutton',...
           'FontSize',10,...
           'Position',radioPos,...
           'FontName','Monospaced',...
           'String',topVarNames{i},...
           'Foregroundcolor',color,...
           'Value',1,...
           'Callback',@(hObject,eventdata)Px4DataResolve('radioSelection_CreateFcn',hObject,eventdata,guidata(hObject)));
end

%adjust verticle slider
if newNameGroupPos(2) >=0
    sliderRate2 = 100000;
elseif 1/(-newNameGroupPos(2)/(newNameGroupPos(2)+newNameGroupPos(4))) > 100000
    sliderRate2 = 100000;
else
    sliderRate2 = 1/(-newNameGroupPos(2)/(newNameGroupPos(2)+newNameGroupPos(4)));
end

maxNumName = floor((newNameGroupPos(2)+newNameGroupPos(4))/radioHeight);
moreVarNum = varNums - maxNumName;
if moreVarNum < 0
    sliderMax = 0.00001;
    sliderRate1 = 1;
elseif maxNumName/(varNums - maxNumName) >= 1
    sliderMax = varNums - maxNumName;
    sliderRate1 = 1;
else
    sliderMax = varNums - maxNumName+1;
    sliderRate1 = maxNumName/(varNums - maxNumName);
end

if isempty(hNameSlider)
    hNameSlider = uicontrol('Parent',handles.VariableGroup,...
        'Style','slider',...
        'Units','pixels',...
        'Position',newSliderPos,...
        'Min',0,...
        'Max',sliderMax,...
        'Value',sliderMax,...
        'Tag','nameSlider',...
        'SliderStep',[sliderRate1 sliderRate2+0.0000001],...
        'callback',@(hObject,eventdata)Px4DataResolve('slider_Callback',hObject,eventdata,guidata(hObject)));
elseif filter == 1
    
    set(hNameSlider,'Position',newSliderPos,...
                    'Min',0,...
                    'Max',sliderMax,...
                    'Value',sliderMax,...
                    'SliderStep',[sliderRate1 sliderRate2+0.0000001]);
else
    set(hNameSlider,'Position',newSliderPos,...
                    'Min',0,...
                    'SliderStep',[sliderRate1 sliderRate2+0.0000001]);
end


handles.topNameGroup = hTopNameGroup;
handles.nameGroupAll = hNameGroupAll;
handles.nameGroup = hNameGroup;
handles.nameSlider = hNameSlider;
handles.varNames = varNames;
guidata(handles.VariableGroup, handles);   






% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if handles.fileImported == 0
    return
end
hNameSlider = handles.nameSlider;
hTopNameGroup = handles.topNameGroup;
hNameGroup = handles.nameGroup;
maxValue = get(hObject,'Max');

value = get(hNameSlider,'Value');
if value > maxValue
    value = maxValue;
end

varableMoveNum = maxValue - floor(value);
radioHeight = handles.radioHeight;

nameGroupPos = get(hNameGroup,'Position');
topNameGroupPos = get(hTopNameGroup,'Position');

nameGroupPos = get(hNameGroup,'Position');
topNameGroupPos = get(hTopNameGroup,'Position');

varNums = length(handles.varNames);
    nameGroupPos(2) = topNameGroupPos(2) - (varNums - varableMoveNum)*radioHeight;
    
    if nameGroupPos(2) > 0
        nameGroupPos(2) = 0;
    end

    set(hNameGroup,'Position',nameGroupPos);

    if value < 0
        value = 0;
    end



% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function radioSelection_CreateFcn(hObject, eventdata, handles)
px4_data = handles.px4_data;
colorList = handles.colorList;
colorListLength = length(colorList);
value = get(hObject,'Value');
if ~isfield(handles,'lastColorIndex')
    lastColorIndex = 0;
else
    lastColorIndex = handles.lastColorIndex;
end

varName = get(hObject,'String');

popuMode = get(handles.popuMode,'Value');
xyVariable = get(handles.popuMode,'UserData');
hTopNameGroup = findall(handles.VariableGroup,'Tag','topNameGroup','Type','uipanel');
topVarNameList = get(hTopNameGroup,'UserData');
if popuMode == 1

    lengthList = length(topVarNameList);
    if value == 1
        topVarNameList{lengthList + 1} = varName;
        if lengthList >= 10
            
            warndlg('Max items is 10, the first item will be deleted!','Warnning!','replace');
            %delete line when counter > 10
            hLines = findall(handles.AxesPlot,'Type','line','Tag',topVarNameList{1});
            delete(hLines);
            radiosSis = findall(handles.VariableGroup,'String',topVarNameList{1},'Style','radiobutton');
            set(radiosSis,'Foregroundcolor',[0 0 0],'Value',0);
            
            topVarNameList = topVarNameList(2:end);
        end
        var = eval(['px4_data.',varName,';']);  
        lastColorIndex = mod((lastColorIndex),colorListLength) + 1;
            handles.lastColorIndex = lastColorIndex; %used to store the index of color in colorList;
            
            if strcmp(varName,'TIME_Period');
                hLine = line('Parent',handles.AxesPlot,...
                                 'Color',colorList(lastColorIndex,1:end),...
                                 'XData',px4_data.TIME_StartTime*1e-6,...
                                 'YData',var,'Tag',varName,...
                                 'Marker','.',...
                                 'LineStyle','none');
            else
                hLine = line('Parent',handles.AxesPlot,...
                                 'Color',colorList(lastColorIndex,1:end),...
                                 'XData',px4_data.TIME_StartTime*1e-6,...
                                 'YData',var,'Tag',varName);
            end
            set(hObject,'Foregroundcolor',colorList(lastColorIndex,1:end));
        
    else
        index = find(strcmp(varName,topVarNameList));
        if lengthList == 1
            topVarNameList = [];
        else
            if index == 1
                topVarNameList = topVarNameList(2:end);
            elseif index == lengthList
                topVarNameList = topVarNameList(1:end-1);
            else
                tempList = topVarNameList(1:index-1);
                topVarNameList = [tempList,topVarNameList(index+1:end)];
            end
        end
        hLines = findall(handles.AxesPlot,'Type','line','Tag',varName);
        delete(hLines);
        radiosSis = findall(handles.VariableGroup,'String',varName,'Style','radiobutton');
        set(radiosSis,'Foregroundcolor',[0 0 0],'Value',0);
    end
    set(hTopNameGroup,'UserData',topVarNameList);
    handles = redrawNameGroup(handles,topVarNameList,handles.varNames);
else
    if popuMode == 2
        cutChar = '__';
    else
        cutChar = ' — ';
    end
    xyVariable = get(handles.popuMode,'UserData');
    lengthXYVar = length(xyVariable);
    
    if value == 1
        xyVariable{lengthXYVar+1} = varName;
        if lengthXYVar >= 10
            warndlg('Max pairs of X_Y is 5, the first pair will be deleted!','Warnning!','replace');
            
            %delete line when pairs counter > 5
            hLines = findall(handles.AxesPlot,'Type','line','Tag',[xyVariable{1},cutChar,xyVariable{2}]);
            delete(hLines);
            radioSis = findall(handles.VariableGroup,'String',[xyVariable{1},cutChar,xyVariable{2}]);
            radioSis(length(radioSis)+1,1) = findall(handles.VariableGroup,'String',xyVariable{1});
            radioSis(length(radioSis)+1,1) = findall(handles.VariableGroup,'String',xyVariable{2});
            set(radioSis,'Foregroundcolor',[0 0 0],'Value',0);
            
            xyVariable = xyVariable(3:end);
        end
        
        %draw lines 
        if mod(length(xyVariable),2) == 0
            lastColorIndex = mod((lastColorIndex),colorListLength) + 1;
            handles.lastColorIndex = lastColorIndex;
            
            if popuMode == 2
                xValue = eval(['px4_data.',xyVariable{end-1},';']);
                yValue = eval(['px4_data.',xyVariable{end},';']);
            else
                yValue = eval(['px4_data.',xyVariable{end-1},'-','px4_data.',xyVariable{end},';']);
                xValue = px4_data.TIME_StartTime*1e-6;
            end
            hLine = line('Parent',handles.AxesPlot,...
                 'Color',colorList(lastColorIndex,1:end),...
                 'XData',xValue,...
                 'YData',yValue,...
                 'Tag',[xyVariable{end-1},cutChar,xyVariable{end}]);
            set(findall(handles.VariableGroup,'String',xyVariable{end-1},'Style','radiobutton'),...
                'Foregroundcolor',colorList(lastColorIndex,1:end));
            set(findall(handles.VariableGroup,'String',xyVariable{end},'Style','radiobutton'),...
                'Foregroundcolor',colorList(lastColorIndex,1:end));
        end
    else
        indexTop = find(strcmp(varName,topVarNameList));
        
        if indexTop %topVarNameList may like X__Y form
           itemsNames = regexp(varName,cutChar,'split');      
           index = find(strcmp(itemsNames(1),xyVariable));
        else 
           index = find(strcmp(varName,xyVariable));
        end
        %delete x-y lines and clear radio

        if mod(index,2) == 0 %even
            hLines = findall(handles.AxesPlot,'Type','line','Tag',[xyVariable{index-1},cutChar,xyVariable{index}]);
            delete(hLines);
            set(findall(handles.VariableGroup,'String',xyVariable{index-1},'Style','radiobutton'),...
                'Foregroundcolor',[0 0 0],'value',0);
            set(findall(handles.VariableGroup,'String',xyVariable{index},'Style','radiobutton'),...
                'Foregroundcolor',[0 0 0],'value',0);
            if length(xyVariable) == 2 
                xyVariable = [];
            elseif index == 2
                xyVariable = xyVariable(3:end);
            elseif index == length(xyVariable)
                xyVariable = xyVariable(1:end-2);
            else
                tempList = xyVariable(1:index-2);
                xyVariable = [tempList,xyVariable(index+1:end)];
            end
        else %old
            set(findall(handles.VariableGroup,'String',xyVariable{index},'Style','radiobutton'),...
                'Foregroundcolor',[0 0 0],'value',0);
            if index < length(xyVariable) %not the last item
                set(findall(handles.VariableGroup,'String',xyVariable{index+1},'Style','radiobutton'),...
                    'Foregroundcolor',[0 0 0],'value',0);
                hLines = findall(handles.AxesPlot,'Type','line','Tag',[xyVariable{index},cutChar,xyVariable{index+1}]);
                delete(hLines);
            end
            if length(xyVariable) == 1
                xyVariable = [];
            elseif index == 1
                xyVariable = xyVariable(3:end);
            elseif index == length(xyVariable)
                xyVariable = xyVariable(1:end-1);
            else
                tempList = xyVariable(1:index-1);
                xyVariable = [tempList,xyVariable(index+2:end)];
            end
        end
    end
    set(handles.popuMode,'UserData',xyVariable);
    
    topVarNameList = [];
    topVarNum = floor((length(xyVariable))/2);
    for i = 1:topVarNum
        topVarNameList{i} = [xyVariable{2*i-1},cutChar,xyVariable{2*i}];
    end
    set(handles.topNameGroup,'UserData',topVarNameList);
    handles = redrawNameGroup(handles,topVarNameList,handles.varNames);

end

guidata(handles.VariableGroup, handles);



% --- Executes on button press in pbtPopFigure.
function pbtPopFigure_Callback(hObject, eventdata, handles)
% hObject    handle to pbtPopFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'figureNum')
    figureNum = 1;
else
    figureNum = handles.figureNum + 1;
end
handles.figureNum = figureNum;
figPopPos = [200 100 640 350];

hFigure = figure('Color',handles.colorBackground,...
                        'HandleVisibility','on',...
                        'Name',['Px4DataResolve: PopFigure',num2str(figureNum)],...
                        'PaperPosition',[0 0 1 1],...
                        'Position',figPopPos,...
                        'Tag','popFigure',...
                        'NumberTitle','off',...
                        'Units','pixels',...
                        'SizeChangedFcn',@(hObject,eventdata)Px4DataResolve('popFigureSizeChangedFcn',hObject,eventdata,guidata(hObject)));
axesPosition = [60 40 figPopPos(3)-80 figPopPos(4)-80];
hAxes = axes('Parent',hFigure,...
             'Units','pixels',...
             'Position',axesPosition,...
             'Color',handles.colorBackground,...
         	 'XGrid','on',...
             'YGrid','on');
hlines = findall(handles.AxesPlot,'Type','line','Visible','on');
if ~isempty(hlines)
    set(hlines,'Parent',hAxes);
    linesNums = length(hlines);

    backColor = handles.colorBackground;
    popuMode = get(handles.popuMode,'Value');
    
    if popuMode == 1
        step = 180;
        textLength = 120;
    else
        step = 300;
        textLength = 240;
    end
    
    panelLength = step*ceil(linesNums/2);
    panelPos = [60 figPopPos(4)-40, panelLength, 40];

    hPanel = uipanel(hFigure,...
                       'Units','pixels',...
                       'Position',panelPos,...
                       'FontName','Monospaced',...
                       'BackgroundColor',backColor,...
                       'HighlightColor',backColor,...
                       'Tag','popLagend',...
                       'ShadowColor',backColor);
    for i = 1:linesNums
        color = get(hlines(end+1-i),'Color'); %end+1-i from last to first
        if mod(i,2)==1
            legendPos = [step/2*(i-1), 29, 40, 1];
        else
            legendPos = [step/2*(i-2), 11, 40, 1];
        end
        huipanel = uipanel(hPanel,'units','pixels','Position',legendPos,...
            'BackgroundColor',color,'HighlightColor',color,'ShadowColor',color);
        name = get(hlines(end+1-i),'Tag');
        namePos = [legendPos(1) + 50, legendPos(2) - 10, textLength, 20];

        htext = uicontrol(hPanel,'Style','text','Units','pixels','Position',...
            namePos,'String',name,'BackgroundColor',backColor,...
            'FontName','Monospaced','ForegroundColor',color,'HorizontalAlignment','left');
    end
end
             
pbtClean_Callback(handles.pbtClean, eventdata, handles)
guidata(hObject, handles);

function popFigureSizeChangedFcn(hObject, eventdata, handles)
% call when pop Figure size is changed
figPos = get(hObject,'Position');

hPanel = findall(hObject,'Tag','popLagend');
if ~isempty(hPanel)
    panelPos = get(hPanel,'Position');
    panelPos(2) = figPos(4)-39;

    set(hPanel, 'Position',panelPos);
end

hxyName = findall(hObject,'Tag','xyName');
if ~isempty(hxyName)
    xyNamePos = get(hxyName,'Position');
    xyNamePos(2) = figPos(4)-29;
    xyNamePos(3) = figPos(3);
    set(hxyName, 'Position',xyNamePos);
end

if figPos(3)>= 540 && figPos(4) >= 250
    axesPos = [60 40 figPos(3)-80, figPos(4)-80];
    set(findall(hObject,'Type','axes'),'Position',axesPos);
end


function Hints(handles,hints)
    set(handles.Px4DataResolve,'Name',['Px4DataResolve',': ',hints]);



% --- Executes on scroll wheel click while the figure is in focus.
function Px4DataResolve_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to Px4DataResolve (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)

%scroll up :eventdata -1 ;down eventdata 1
if handles.fileImported == 0
    return
end

currentPoint = get(hObject,'CurrentPoint');

hNameSlider = handles.nameSlider;
hTopNameGroup = handles.topNameGroup;
hNameGroup = handles.nameGroup;
nameGroupPos = get(hNameGroup,'Position');

if nameGroupPos(1) < currentPoint(1) < nameGroupPos(1)+nameGroupPos(3)...
    && nameGroupPos(2) < currentPoint(2) < nameGroupPos(2)+nameGroupPos(4)
    step = 6;
    if eventdata.VerticalScrollCount == 1
        scrollStep = step;
    elseif eventdata.VerticalScrollCount == -1
        scrollStep = -step;
    else
        scrollStep = 0;
    end
 
    maxValue = get(hNameSlider,'Max');
    value = get(hNameSlider,'Value') - scrollStep;
    if value > maxValue
        value = maxValue;
    end
    
    varableMoveNum = maxValue - floor(value);
    radioHeight = handles.radioHeight;
    
    nameGroupPos = get(hNameGroup,'Position');
    topNameGroupPos = get(hTopNameGroup,'Position');

    varNums = length(handles.varNames);
    nameGroupPos(2) = topNameGroupPos(2) - (varNums - varableMoveNum)*radioHeight;
    
    if nameGroupPos(2) > 0
        nameGroupPos(2) = 0;
    end

    set(hNameGroup,'Position',nameGroupPos);

    if value < 0
        value = 0;
    end
    set(hNameSlider,'Value',value);
end

% --- Executes when Px4DataResolve is resized.
function Px4DataResolve_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to Px4DataResolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


figPos = get(hObject,'Position');
optInitPos = handles.InitPos.optGroupPos;
figInitPos = handles.InitPos.figPos;

if figPos(3)>= 490 && figPos(4) >= 175
    optionPos = [0, figPos(4)-optInitPos(4), optInitPos(3),optInitPos(4)];
    varPos = [0, 0, optInitPos(3),figPos(4)-optInitPos(4)];
    plotPos = [optInitPos(3), 0, figPos(3)-optInitPos(3), figPos(4)];
    axesPos = [60 40 plotPos(3)-80, plotPos(4)-60];
    
    set(handles.OptionGroup,'Position',optionPos);
    set(handles.VariableGroup,'Position',varPos);
    set(handles.AxesGroup,'Position',plotPos);
    set(handles.AxesPlot,'Position',axesPos);
    
    if handles.fileImported == 0
        return
    end
    
    hTopNameGroup = handles.topNameGroup;
    topVarNames = get(hTopNameGroup,'UserData');

    handles = redrawNameGroup(handles,topVarNames,handles.varNames);
%     guidata(hObject, handles);
end
        

% --- Executes when user attempts to close Px4DataResolve.
function Px4DataResolve_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Px4DataResolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(findall(0,'Tag','popFigure'));
delete(hObject);


% --- Executes on selection change in popuMode.
function popuMode_Callback(hObject, eventdata, handles)
% hObject    handle to popuMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popuMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popuMode
pbtClean_Callback(handles.pbtClean, eventdata, handles);
set(hObject,'UserData',[]);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edtFilter.
function edtFilter_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edtFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','on','String','');

% --- Executes during object creation, after setting all properties.
function edtFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtFilter_Callback(hObject, eventdata, handles)
% hObject    handle to edtFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtFilter as text
%        str2double(get(hObject,'String')) returns contents of edtFilter as a double

if handles.fileImported == 0
    return
end
set(hObject,'Enable','off');

filterName = get(hObject,'String');
if isempty(filterName)
    varFilterNames = handles.varNamesAll;
    set(hObject,'UserData',0);
else
    set(hObject,'UserData',1);
    filterLen = length(filterName);
    variableNames =  handles.varNamesAll;
    variableNums = length(variableNames);
    varFilterNames = [];
    for i = 1:variableNums
        variableName = variableNames{i};
        varLen = length(variableName);
        if varLen >= filterLen %search filterName in varName
            for j = 1:(varLen-filterLen+1)
                if strcmpi(variableName(j:j+filterLen-1),filterName)
                    varFilterNames{end + 1} = variableName;
                    break;
                end
            end
        end
    end
end



if isempty(varFilterNames)
    warndlg('No variable match !','warning','modal');
else
    %before creat new group, save ploted variable, used to replot when
    %jump out filter
    hTopNameGroup = findall(handles.VariableGroup,'Tag','topNameGroup','Type','uipanel');
    topVarNames = get(hTopNameGroup,'UserData');
    handles = redrawNameGroup(handles,topVarNames,varFilterNames);
    handles.Px4.filterNames = varFilterNames;
    guidata(hObject, handles);    
end
