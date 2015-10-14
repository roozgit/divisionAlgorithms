function varargout = binDivision(varargin)
% BINDIVISION MATLAB code for binDivision.fig
%      BINDIVISION, by itself, creates a new BINDIVISION or raises the existing
%      singleton*.
%
%      H = BINDIVISION returns the handle to a new BINDIVISION or the handle to
%      the existing singleton*.
%
%      BINDIVISION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BINDIVISION.M with the given input arguments.
%
%      BINDIVISION('Property','Value',...) creates a new BINDIVISION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before binDivision_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to binDivision_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help binDivision

% Last Modified by GUIDE v2.5 09-Oct-2015 23:17:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @binDivision_OpeningFcn, ...
                   'gui_OutputFcn',  @binDivision_OutputFcn, ...
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


% --- Executes just before binDivision is made visible.
function binDivision_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to binDivision (see VARARGIN)

% Choose default command line output for binDivision
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes binDivision wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = binDivision_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function QValue_Callback(hObject, eventdata, handles)
% hObject    handle to QValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QValue as text
%        str2double(get(hObject,'String')) returns contents of QValue as a double


% --- Executes during object creation, after setting all properties.
function QValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MValue_Callback(hObject, eventdata, handles)
% hObject    handle to MValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MValue as text
%        str2double(get(hObject,'String')) returns contents of MValue as a double


% --- Executes during object creation, after setting all properties.
function MValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pbStart.
function pbStart_Callback(hObject, eventdata, handles)
% hObject    handle to pbStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles to edit boxes and static text boxes
Medit = handles.MValue;
Qedit = handles.QValue;
Mtxt = handles.MRegister;
Qtxt = handles.QRegister;
Atxt= handles.ARegister;
resTxt = handles.resText;
quoTxt = handles.finalQ;
remTxt = handles.finalA;

%Get decimal values for Q, M
Mdec = str2num(get(Medit,'String'));
Qdec = str2num(get(Qedit,'String'));

if isempty(Mdec) || isempty(Qdec)
    msgbox('Please enter value in edit box');
    return
end

%div by zero check
if Mdec==0
    msgbox('Division by zero error');
    return
end

%Overflow checks. Since Q,M are registers, it is assumed that they have to
%be able to hold negative numbers too
if ( abs(Qdec)-abs(Mdec)*(2^8) )>0 || (abs(Qdec) > 2^15-1) || (abs(Mdec) > 2^7-1)
    msgbox('Overflow condition detected');
    return
end

%Signs calculation
remSign = sign(Qdec);
quoSign = sign(Qdec)*sign(Mdec);

qbin = repBinary(abs(Qdec),16); %16 bit binary conversion for q

%AQ register is formed by dividing the dividend into two 8-bit registers
areg = qbin(1:8);
qreg = qbin(9:16);
mreg = repBinary(abs(Mdec),8);  %register for M
set(Mtxt,'String',num2str(mreg));
set(Atxt,'String', num2str(areg));
set(Qtxt,'String', num2str(qreg));

thandle = handles.divTable; %Handle for division table display
%set table coloumn width
Wid  = cell(1, 16);
Wid(:) = {20};
shandle = handles.stpTable;
set(thandle, 'ColumnWidth',Wid);

%Acquire restoring algorithm matrix by calling restoringDiv function
restoringMat = restoringDiv(areg,qreg,mreg);
thandle.Data = restoringMat{1,1};   %Actual restoring steps
shandle.Data = restoringMat{1,2};   %Descriptions table filling

%convert results to decimal and display the final (Signed) results.
quotient = restoringMat{1,1}(25,9:16);
remainder = restoringMat{1,1}(25,1:8);
quotientDecimal = bi2de(quotient, 'left-msb');
remainderDecimal = bi2de(remainder, 'left-msb');

set(quoTxt,'String',num2str(quotient));
set(remTxt,'String',num2str(remainder));
set(resTxt,'String',strcat(num2str(quoSign*quotientDecimal),'R',num2str(remSign*remainderDecimal)));

%create restoring diagram
decres=zeros(1,16);

%The restoring matrix has 25 rows each step consisting of 3 rows. We only
%need two of those rows for the diagram.
for i = 1:8
    decres(2*i-1)=bi2de(restoringMat{1,1}(3*i-1,1:16-i),'left-msb');
    if restoringMat{1,1}(3*i,1) == 0
        decres(2*i)=bi2de(restoringMat{1,1}(3*i,1:16-i),'left-msb');
    else
        decres(2*i)=-2^(16-i)+bi2de(restoringMat{1,1}(3*i,1:16-i),'left-msb');
    end
end

% We also need the final row (row 25) for the final remainder
if restoringMat{1,1}(25,1) == 0
        decres(17)=bi2de(restoringMat{1,1}(25,1:8),'left-msb');
    else
        decres(17)=-2^8+bi2de(restoringMat{1,1}(25,1:8),'left-msb');
end

figure;
plot(decres','-o')

%Display remainder values at each step besides points
for inds=1:17;
    text(inds+.2,decres(inds),num2str(decres(inds)));
end
xlim([1 18]);
title(strcat('Restoring remainder calcualtion for:', num2str(abs(Qdec)),'/',num2str(abs(Mdec))));