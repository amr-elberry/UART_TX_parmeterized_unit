module parity_calc #(parameter width = 8)(
    input wire clk,
    input wire rst,
    input wire busy,
    input reg [width-1:0] data,
    input wire data_valid,
    input wire parity_type,
    input wire parity_enable,
    output reg parity_bit
);

reg [width-1:0] data_in;

/****************isolating input data*******************/
always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        data_in <= 'b0;
    end
    else if (data_valid && !busy) //latched signal 
    begin
        data_in <= data;
    end    
end
/********************************************************/
always @(posedge clk or negedge rst ) 
begin
    if (!rst) 
    begin
        parity_bit <= 'b0;
    end
    else 
    begin
        if (parity_enable) 
        begin
            case (parity_type)
            1'b0:parity_bit <= ^data_in ;  //even parity
            1'b1:parity_bit <= ~^data_in ; //odd parity 
            endcase
        end
    end
    
end
endmodule