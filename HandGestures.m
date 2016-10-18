function varargout = HandGestures(varargin)

% global variables for storing states
global default_switch;
global default_temperature;
global default_mode;
global default_wind;

global switch_status;
global temperature_status;
global menu_item;
global mode_option_item;
global wind_option_item;

% set the default status, when start display them
default_switch = 0;
default_temperature = 35;
default_mode = 0; % 'Cold', 'Warm', 'Freeze'
default_wind = 0; % 'Strong', 'Medium', 'Weak'

% record current status, so that change when get an order
switch_status = default_switch;
temperature_status = default_temperature;
mode_option_item = default_mode;
wind_option_item = default_wind;
menu_item = 0;

order = varargin(1);
out = set_status(order{1});
disp1 = out(1);
drawnow();
uicontrol('Style','Listbox',...
'String',disp1{1},...
'Position',[100 100 200 200]);
uicontrol('Style','text',...
'String',out(2),...
'Position',[350 100 200 200]);
%pause(1);

end


function varoutput = set_status(order)

% global variables for storing states
global default_switch;
global default_temperature;
global default_mode;
global default_wind;

global switch_status;
global temperature_status;
global menu_item;
global mode_option_item;
global wind_option_item;

mode = {'Cold', 'Warm', 'Freeze'};
wind = {'Strong', 'Medium', 'Weak'};
operation = {'On/Off', 'Up', 'Down', 'Left', 'Right'};

% get the start/stop commander

if (order == 0)
    % current is off, then start the display
    if (switch_status == 0)
        switch_status = 1;
        menu_item = 0;  % set current menu to be 'temperature'
        % now set all the display%%%%%
    % current is on, then stop the display
    else
        switch_status = 0;
        % record all of our display into default
        default_temperature = temperature_status;
        default_mode = mode_option_item;
        default_wind = wind_option_item;
    end
elseif (order == 1) % Up
   check_switch_status();    % check if it's on, otherwise don't do
   menu_item = mod(menu_item - 1 + 3, 3);
elseif (order == 2) % Down
    check_switch_status();
    menu_item = mod(menu_item+1, 3);
elseif (order == 3) % Left
    check_switch_status();
    if (menu_item == 0)
        temperature_status = temperature_status - 1;
    elseif (menu_item == 1)
        mode_option_item = mod(mode_option_item + 2, 3);
    elseif (menu_item == 2)
        wind_option_item = mod(wind_option_item + 2, 3);
    end
elseif (order == 4) % right
    check_switch_status();
    if (menu_item == 0)
        temperature_status = temperature_status + 1;
    elseif (menu_item == 1)
        mode_option_item = mod(mode_option_item + 1, 3);
    elseif (menu_item == 2)
        wind_option_item = mod(wind_option_item + 1, 3);
    end
end


operation_str = sprintf('Operation is %s', cell2mat(operation(order+1)));

if (switch_status == 0)
    varoutput_str = sprintf('switch = %d',switch_status);
    varoutput = {switch_status};
else
    varoutput_str = sprintf('switch = %d, temperature = %d, mode = %s, wind = %s',switch_status, temperature_status, cell2mat(mode(mode_option_item+1)), cell2mat(wind(wind_option_item+1)));
    varoutput = {switch_status, temperature_status, cell2mat(mode(mode_option_item+1)), cell2mat(wind(wind_option_item+1))};
end
disp(operation_str);
disp(varoutput_str); 

varoutput = {varoutput, cell2mat(operation(order+1))};
end

function var = check_switch_status()
global switch_status;

if (switch_status == 0)
    disp('Warning: it is closed, please open first and then switch menus');
    %exit();
end
end

% This function mocks the output of other modules
% 0 - double push
% 1 - Up
% 2 - Down
% 3 - Left
% 4 - Right
function varout = mockOutput()
    varout = 0;
end