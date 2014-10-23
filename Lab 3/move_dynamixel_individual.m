function CommStatus = move_dynamixel_individual(position);
    %% Setting up the dynamixel
    loadlibrary('dynamixel', 'dynamixel.h');
    DEFAULT_PORTNUM = 3;
    DEFAULT_BAUDNUM = 1;
    res = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, ...
        DEFAULT_BAUDNUM);

    %% Some important definitions
    P_GOAL_POSITION = 30;
    P_PRESENT_POSITION = 36;
    BROADCAST_ID = 254;
    INST_SYNC_WRITE = 131;
    NUM_ACTUATOR = 3;
    PACKET_SIZE = 7;

    %% Control!
    for i = 1:NUM_ACTUATOR
        id(1, i) = i;
    end

    % Make syncwrite packet
    calllib('dynamixel','dxl_set_txpacket_id',BROADCAST_ID);
    calllib('dynamixel','dxl_set_txpacket_instruction',INST_SYNC_WRITE);
    calllib('dynamixel','dxl_set_txpacket_parameter',0,P_GOAL_POSITION);
    calllib('dynamixel','dxl_set_txpacket_parameter',1,2);
    for i = 0:1:NUM_ACTUATOR-1
        i
        calllib('dynamixel','dxl_set_txpacket_parameter',2+3*i,id(i+1));
        GoalPos = position;
        Position(i+1) = int32(GoalPos);
        low = calllib('dynamixel','dxl_get_lowbyte',GoalPos);
        calllib('dynamixel','dxl_set_txpacket_parameter',2+3*i+1,low);
        high = calllib('dynamixel','dxl_get_highbyte',GoalPos);
        calllib('dynamixel','dxl_set_txpacket_parameter',2+3*i+2,high);
    end
    calllib('dynamixel','dxl_set_txpacket_length',(2+1)*NUM_ACTUATOR+4);
    calllib('dynamixel','dxl_txrx_packet');


    % Check if it failed
    CommStatus = int32(calllib('dynamixel','dxl_get_result'));
    if CommStatus > 1
        CommStatus
    end

    %% Closing dynamixel connections
    calllib('dynamixel','dxl_terminate');
    unloadlibrary('dynamixel');

    %% Tidy Up
    clear
end