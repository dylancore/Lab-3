function CommStatus = move_dynamixel(position, speed);
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
    PACKET_SIZE = 14;

    %% Control!
    for i = 1:NUM_ACTUATOR
        id(1, i) = i;
    end

    calllib('dynamixel','dxl_set_txpacket_id', BROADCAST_ID);
    calllib('dynamixel','dxl_set_txpacket_length', PACKET_SIZE);
    calllib('dynamixel','dxl_set_txpacket_instruction', INST_SYNC_WRITE);
    calllib('dynamixel','dxl_set_txpacket_parameter', 0, P_GOAL_POSITION);
    calllib('dynamixel','dxl_set_txpacket_parameter', 1, 4);

    for i = 0:(NUM_ACTUATOR-1)
        %ID
        calllib('dynamixel','dxl_set_txpacket_parameter',2+3*i, i+1);

        %Position
        lowByte = calllib('dynamixel','dxl_get_lowbyte', position);
        highByte = calllib('dynamixel','dxl_get_highbyte', position);
        calllib('dynamixel','dxl_set_txpacket_parameter',3, lowByte);
        calllib('dynamixel','dxl_set_txpacket_parameter',4, highByte);

        %Speed = 512
        lowByte = calllib('dynamixel','dxl_get_lowbyte', speed);
        highByte = calllib('dynamixel','dxl_get_highbyte', speed);
        calllib('dynamixel','dxl_set_txpacket_parameter',5, lowByte);
        calllib('dynamixel','dxl_set_txpacket_parameter',6, highByte);
    end

    % Transmit
    calllib('dynamixel','dxl_tx_packet'); 

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