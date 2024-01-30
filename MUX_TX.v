module mux (
    input wire       clk,
    input wire       rst,
    input wire       in_1,
    input wire       in_2,
    input wire       in_3,
    input wire       in_4,
    input wire [1:0] mux_sel,
    output reg       tx_out );

reg mux_out ;

always @(*) 
begin
    case (mux_sel)
    2'b00:mux_out = in_1;
    2'b01:mux_out = in_2;
    2'b10:mux_out = in_3;
    2'b11:mux_out = in_4; 
    endcase    
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        tx_out <= 'b0;
        mux_out <= in_2;
    end
    else
    begin
        tx_out <= mux_out;
    end
    
end
endmodule