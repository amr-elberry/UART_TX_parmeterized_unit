module uart_tx_top #(parameter DATA_WIDTH = 8) (
    input wire CLK,
    input wire RST,
    input wire [DATA_WIDTH-1:0] P_DATA,
    input wire PARITY_ENABLE,
    input wire PARITY_TYPE,
    input wire DATA_VALID,
    output wire TX_OUT,
    output wire BUSY
);
/*******************internal signal*****************/
wire seriz_done;
wire seriz_en;
wire seriz_data;
wire par_bit;
wire [1:0] muxy_sel; 
/***************************************************/
/***********************fsm_instantion**************/
uart_tx_fsm u0_fsm (
    .clk(CLK),
    .rst(RST),
    .ser_done(seriz_done),
    .data_valid(DATA_VALID),
    .par_en(PARITY_ENABLE),
    .ser_en(seriz_en),
    .mux_sel(muxy_sel),
    .busy(BUSY)
);
/***************************************************/
/****************serializer_instantion**************/
serializer #(.width(DATA_WIDTH)) u0_ser (
    .clk(CLK),
    .rst(RST),
    .busy(BUSY),
    .enable(seriz_en),
    .data_valid(DATA_VALID),
    .data(P_DATA),
    .ser_done(seriz_done),
    .ser_out(seriz_data)
);
/***************************************************/
/***********************mux_instantion**************/
mux u0_mux (
    .clk(CLK),
    .rst(RST),
    .in_1(1'b0),
    .in_2(1'b1),
    .in_3(seriz_data),
    .in_4(par_bit),
    .mux_sel(muxy_sel),
    .tx_out(TX_OUT)
);
/***************************************************/
/***********************mux_instantion**************/
parity_calc #(.width(DATA_WIDTH)) u0_parity_calc (
    .clk(CLK),
    .rst(RST),
    .data(P_DATA),
    .data_valid(DATA_VALID),
    .parity_type(PARITY_TYPE),
    .parity_enable(PARITY_ENABLE),
    .parity_bit(par_bit),
    .busy(BUSY)
);
/***************************************************/
endmodule