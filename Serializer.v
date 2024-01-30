module serializer #(parameter width=8) (
    input wire clk,
    input wire rst,
    input wire busy,
    input wire enable,
    input wire data_valid,
    input reg [width-1:0] data,
    output reg ser_done,
    output wire ser_out
);
reg [2:0] counter;
reg  [width-1:0] data_in;

assign ser_out =data_in[0];
/******************serializing data and isolating input data******************/
always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        data_in <= 'b0;
    end
    else if(data_valid && !busy)  //to avoid data_valid during transimetting
    begin
        data_in <= data; 
    end
    else
    begin
        data_in <= data_in >>1; //right logic shift
    end
    
end
/*************************************************************************/

/*************************Counter****************************************/
always @(posedge clk or negedge rst)
begin
    if (!rst) 
    begin
        counter <= 'b0;
    end
    else 
    begin
        if (enable) 
        begin
        counter <= counter + 1;
        ser_done <= 'b0;
        end 
        else if (counter == 3'b111)
        begin
        ser_done <= 'b1;
        counter <=0 ;    
        end
        else 
        begin
        counter <=0 ;
        ser_done <= 'b0;   
        end
    end

end
/*************************************************************************/

endmodule