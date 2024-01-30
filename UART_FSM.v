module uart_tx_fsm (
    input wire clk,
    input wire rst,
    input wire ser_done,
    input wire data_valid,
    input wire par_en,
    output reg ser_en,
    output reg [1:0] mux_sel,
    output reg busy);

reg busy_m;
reg [2:0] present_state,next_state;

/***************** Encoding_FSM *******************/
localparam [2:0] idle   = 3'b000,
                 start  = 3'b001,
                 data   = 3'b010,
                 parity = 3'b011,
                 stop   = 3'b100;
/***************************************************/
/************* state_transition_fsm ****************/
//sequential part _fsm
always@(posedge clk or negedge rst)
begin
  if(!rst)
  begin
    present_state <= idle;
  end
  else
  begin
    present_state <= next_state;
  end
end
/***********output and next state logic_fsm********/
//combination part_fsm
always@(*)
begin
    present_state = 0;
    next_state    = 0;
    case (present_state)
        idle:begin
            busy_m    = 1'b0;
            ser_en  = 1'b0;
            mux_sel = 2'b01; //tx_out = 1 in idle
            if (data_valid) 
                next_state = start;
                else 
                next_state = idle;
                        
            end 
        start:begin
            busy_m    = 1'b1;
            ser_en  = 1'b0;
            mux_sel = 2'b00;
            next_state = data;
            end
        data:begin
            busy_m    = 1'b1;
            ser_en  = 1'b1;
            mux_sel = 2'b10;
            if (ser_done)
                begin
                ser_en = 1'b0;
                if (par_en) begin
                    next_state = parity;
                            end
                else        begin
                    next_state = stop;
                            end    
                end    
            else begin
                ser_en = 1'b1;
                next_state = data;
                end         
                           
            end
        parity:begin
            busy_m    = 1'b1;
            ser_en  = 1'b0;
            mux_sel = 2'b11;
            next_state = stop;
            end
        stop:begin
            busy_m    = 1'b1;
            ser_en  = 1'b0;
            mux_sel = 2'b01;
            next_state = stop;
            end
        default:begin
            busy_m  = 1'b0;
            ser_en  = 1'b0;
            mux_sel = 2'b01; 
                end

    endcase
end
/*****************************************************/

/************ ASYNC_rst and regiter output************/
always @(posedge clk or negedge rst) 
begin
    if (!rst) 
        begin
        busy <= 1'b0;    
        end
    else
        begin
        busy <= busy_m;
        end    
end

/*****************************************************/

endmodule