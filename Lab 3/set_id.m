%% Setting up the dynamixel
loadlibrary('dynamixel', 'dynamixel.h');
DEFAULT_PORTNUM = 3;
DEFAULT_BAUDNUM = 1;
res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, ...
    DEFAULT_BAUDNUM)
%% Closing dynamixel connections
calllib('dynamixel','dxl_terminate');
unloadlibrary('dynamixel');

%% Tidy Up
clear