module top_edge(
                CLK,    // CLK is overall clock
                RSTn,   // RSTn is reset button
                EN,     // EN is enable signal indicate we can do something
                Filter_en,  // Filter_en is switch of type of filter
                H_sync, // H_sync is horizontal synchronization signal of current pixel
                V_sync, // V_sync is vertical synchronization signal of current pixel
                DATA_in,    // DATA_in is color information of current pixel
                    
                EN_out, // EN_out is output of delayed EN
                H_sync_out, // H_sync_out is output of delayed H_sync
                V_sync_out, // V_sync_out is output of delayed V_sync
                DATA_out    // DATA_out is output of filtered data
               );

input CLK, RSTn, EN, H_sync, V_sync;
input [1:0] Filter_en;
input [15:0] DATA_in;

output EN_out,H_sync_out,V_sync_out;
output [15:0] DATA_out;

reg [15:0] DATA_out_delay1;
reg [15:0] DATA_out_delay2;
reg [15:0] DATA_out_delay3;
reg [15:0] DATA_out_delay4;
reg [15:0] DATA_out_delay5;
// these registers are for storing delayed data

reg signed [9:0] delay1_red;
reg signed [9:0] delay2_red;
reg signed [9:0] delay3_red;
reg signed [9:0] delay4_red;
reg signed [9:0] delay5_red;
// these registers are for storing delayed red data which is multiplied which coefficient. 10-bit is enough for storing computed value

reg signed [9:0] delay1_green;
reg signed [9:0] delay2_green;
reg signed [9:0] delay3_green;
reg signed [9:0] delay4_green;
reg signed [9:0] delay5_green; 
// these registers are for storing delayed green data which is multiplied which coefficient. 10-bit is enough for storing computed value

reg signed [9:0] delay1_blue;
reg signed [9:0] delay2_blue;
reg signed [9:0] delay3_blue;
reg signed [9:0] delay4_blue;
reg signed [9:0] delay5_blue; 
// these registers are for storing delayed blue data which is multiplied which coefficient. 10-bit is enough for storing computed value

reg signed [9:0] DATA_out_Red; 
// this register is for storing filtered red data

reg signed [9:0] DATA_out_Red1; 
// this register is for storing filtered red data which doesn’t have any negative values

reg signed [9:0] DATA_out_Red2; 
// this register is for storing filtered red data which doesn’t have any negative values and large values


reg signed [9:0] DATA_out_Green; 
// this register is for storing filtered green data

reg signed [9:0] DATA_out_Green1; 
// this register is for storing filtered green data which doesn’t have any negative values

reg signed [9:0] DATA_out_Green2; 
// this register is for storing filtered green data which doesn’t have any negative values and large values


reg signed [9:0] DATA_out_Blue; 
// this register is for storing filtered blue data

reg signed [9:0] DATA_out_Blue1; 
// this register is for storing filtered blue data which doesn’t have any negative values

reg signed [9:0] DATA_out_Blue2; 
// this register is for storing filtered blue data which doesn’t have any negative values and large values


reg [15:0] DATA_out_buffer;
// this register is assigned which DATA_out

reg EN_out_delay1;
reg EN_out_delay2;
reg EN_out_delay3;
reg EN_out_delay4;

reg H_sync_out_delay1;
reg H_sync_out_delay2;
reg H_sync_out_delay3;
reg H_sync_out_delay4;

reg V_sync_out_delay1;
reg V_sync_out_delay2;
reg V_sync_out_delay3;
reg V_sync_out_delay4; 

//Data Output Writer
always@(posedge CLK or negedge RSTn)
begin
    if(~RSTn)
    begin
        DATA_out <= 0;
        H_sync_out <= 0;
        V_sync_out <= 0;
        EN_out <= 0;
    end
    else
    begin        
        DATA_out <= DATA_out_buffer
        V_sync_out <= V_sync_buffer;
        H_sync_out <= H_sync_buffer;
        EN_out <= EN_out_buffer;
    end
end

//Input Data Store
always@(posedge CLK or negedge RSTn)
begin
    if(~RSTn)
    begin
        DATA_out_delay1 <= 0;
        DATA_out_delay2 <= 0;
        DATA_out_delay3 <= 0;
        DATA_out_delay4 <= 0;
        DATA_out_delay5 <= 0;

        H_sync_out_delay1 <= 0;
        H_sync_out_delay2 <= 0;
        V_sync_out_delay1 <= 0;
        V_sync_out_delay2 <= 0;

        EN_out_delay1 <= 0;
        EN_out_delay2 <= 0;
        EN_out_delay3 <= 0;

    end
    else 
    begin
        DATA_out_delay1 <= data_in;
        DATA_out_delay2 <= DATA_out_delay1;
        DATA_out_delay3 <= DATA_out_delay2;
        DATA_out_delay4 <= DATA_out_delay3;
        DATA_out_delay5 <= DATA_out_delay4;

        H_sync_out_delay1 <= H_sync;
        H_sync_out_delay2 <= H_sync_out_delay1;
        H_sync_out_delay3 <= H_sync_out_delay2;
        H_sync_out_delay4 <= H_sync_out_delay3;
        
        V_sync_out_delay1 <= V_sync;
        V_sync_out_delay2 <= V_sync_out_delay1;
        V_sync_out_delay3 <= V_sync_out_delay2;
        V_sync_out_delay4 <= V_sync_out_delay3;
        
        EN_out_delay1 <= EN;
        EN_out_delay2 <= EN_out_delay1;
        EN_out_delay3 <= EN_out_delay2;
        EN_out_delay4 <= EN_out_delay3;
    end 
end


always@(posedge CLK or negedge RSTn)
begin
    if(~RSTn)
    begin
    // In here we initialize values
    
        data_out_en <= 0;

        DATA_out_buffer <= 0;

        V_sync_buffer <= 0;
        H_sync_buffer <= 0;
        EN_out_buffer <= 0;

        delay1_red <= 0;
        delay2_red <= 0;
        delay3_red <= 0;
        delay4_red <= 0;
        delay5_red <= 0;

        delay1_green <= 0;
        delay2_green <= 0;
        delay3_green <= 0;
        delay4_green <= 0;
        delay5_green <= 0;
        
        delay1_blue <= 0;
        delay2_blue <= 0;
        delay3_blue <= 0;
        delay4_blue <= 0;
        delay5_blue <= 0;

        DATA_out_Red <= 0;
        DATA_out_Green <= 0;
        DATA_out_Blue <= 0;

        DATA_out_Red1 <= 0;
        DATA_out_Green1 <= 0;
        DATA_out_Blue1 <= 0;

    end
    else
    begin
        if(EN)
        // In here we make filter. We filter the image when EN = 1.
        begin
            if(Filter_en == 2'b00)
            // If no filter (Filter_en == 0 is no filter) is selected, we just delay one clock, because, though we don't use filter, we store image data in register and send to LCD. Therefore one clock is needed.
            begin
                data_out_en <= 1;
                DATA_out_buffer <= DATA_in;
                EN_out_buffer <= EN;
                H_sync_buffer <= H_sync;
                V_sync_buffer <= V_sync;
            end
            else 
            begin

                // Color output data merger
                DATA_out_Red <= delay1_red+delay2_red+delay3_red+delay4_red+delay5_red;
                DATA_out_Green <= delay1_green+delay2_green+delay3_green+delay4_green+delay5_green;
                DATA_out_Blue <= delay1_blue+delay2_blue+delay3_blue+delay4_blue+delay5_blue;
           
                // Color merged data filter
                if(DATA_out_Red < 0)
                    DATA_out_Red1 <= 0;
                else if (DATA_out_Red >= 10'b0000100000) 
                    DATA_out_Red1 <= 10'b0111111111;;
                else
                    DATA_out_Red1 <= DATA_out_Red;

                if(DATA_out_Green < 0)
                    DATA_out_Green1 <= 0;
                else if (DATA_out_Green >= 10'b0001000000)
                    DATA_out_Green1 <= 10'b0111111111;
                else
                    DATA_out_Green1 <= DATA_out_Green;

                if(DATA_out_Blue < 0)
                    DATA_out_Blue1 <= 0;
                else if(DATA_out_Blue >= 10'b0000100000)
                    DATA_out_Blue1 <= 10'b0111111111;
                else
                    DATA_out_Blue1 <= DATA_out_Blue;

                // Output Deliverer
                DATA_out_buffer <= {DATA_out_Red1[4:0],DATA_out_Green1[5:0],DATA_out_Blue1[4:0]};
                EN_out_buffer <= EN_out_delay4;
                H_sync_buffer <= H_sync_out_delay4;
                V_sync_buffer <= V_sync_out_delay4;

            end            
            if(Filter_en == 2'b01) 
            // Edge filter. Coefficient of edge filter is [-1 -2 6 -2 -1]. Summation of coefficients is 0.
            begin
                delay1_red <= -1*{1'b0,DATA_out_delay1[15:11]};
                delay1_green <= -1*DATA_out_delay1[10:5];
                delay1_blue <= -1*{1'b0,DATA_out_delay1[4:0]};
                
                delay2_red <= -2*{1'b0,DATA_out_delay2[15:11]};
                delay2_green <= -2*DATA_out_delay2[10:5];
                delay2_blue <= -2*{1'b0,DATA_out_delay2[4:0]};
                
                delay3_red <= 6*{1'b0,DATA_out_delay3[15:11]};
                delay3_green <= 6*DATA_out_delay3[10:5];
                delay3_blue <= 6*{1'b0,DATA_out_delay3[4:0]};
                
                delay4_red <= -2*{1'b0,DATA_out_delay4[15:11]};
                delay4_green <= -2*DATA_out_delay4[10:5];
                delay4_blue <= -2*{1'b0,DATA_out_delay4[4:0]};
                
                delay5_red <= -1*{1'b0,DATA_out_delay5[15:11]};
                delay5_green <= -1*DATA_out_delay5[10:5];
                delay5_blue <= -1*{1'b0,DATA_out_delay5[4:0]};
            end
            else if(Filter_en == 2'b10) 
            // Sharp filter. Coefficient of edge filter is [-1 -2 7 -2 -1]. Summation of coefficients is 1. Because dominant coefficient (center one) is larger than edge filter
            begin
                delay1_red <= -1*{1'b0,DATA_out_delay1[15:11]};
                delay1_green <= -1*DATA_out_delay1[10:5];
                delay1_blue <= -1*{1'b0,DATA_out_delay1[4:0]};
                
                delay2_red <= -2*{1'b0,DATA_out_delay2[15:11]};
                delay2_green <= -2*DATA_out_delay2[10:5];
                delay2_blue <= -2*{1'b0,DATA_out_delay2[4:0]};
                
                delay3_red <= 7*{1'b0,DATA_out_delay3[15:11]};
                delay3_green <= 7*DATA_out_delay3[10:5];
                delay3_blue <= 7*{1'b0,DATA_out_delay3[4:0]};
                
                delay4_red <= -2*{1'b0,DATA_out_delay4[15:11]};
                delay4_green <= -2*DATA_out_delay4[10:5];
                delay4_blue <= -2*{1'b0,DATA_out_delay4[4:0]};
                
                delay5_red <= -1*{1'b0,DATA_out_delay5[15:11]};
                delay5_green <= -1*DATA_out_delay5[10:5];
                delay5_blue <= -1*{1'b0,DATA_out_delay5[4:0]};
            end
            else if(Filter_en == 2'b11) 
            // Blur filter. Given coefficient of edge filter is [0.1 0.2 0.4 0.2 0.1]. But we use [0.25 0.25 0.5 0.25 0.25], because important thing is summation of all coefficient is 1 and all coefficient are positive, and in RTL language dividing coefficient with square number of 2 is more convenient.
            begin
                delay1_red <= ({1'b0,DATA_out_delay1[15:11]}>>3);
                delay1_green <= ({DATA_out_delay1[10:5]}>>3);
                delay1_blue <= ({1'b0,DATA_out_delay1[4:0]}>>3);
                
                delay2_red <= ({1'b0,DATA_out_delay2[15:11]}>>3);
                delay2_green <= ({DATA_out_delay2[10:5]}>>3);
                delay2_blue <= ({1'b0,DATA_out_delay2[4:0]}>>3);
                
                delay3_red <= ({1'b0,DATA_out_delay3[15:11]}>>1);
                delay3_green <= ({DATA_out_delay3[10:5]}>>1);
                delay3_blue <= ({1'b0,DATA_out_delay3[4:0]}>>1);
                
                delay4_red <= ({1'b0,DATA_out_delay4[15:11]}>>3);
                delay4_green <= ({DATA_out_delay4[10:5]}>>3);
                delay4_blue <= ({1'b0,DATA_out_delay4[4:0]}>>3);
                
                delay5_red <= ({1'b0,DATA_out_delay5[15:11]}>>3);
                delay5_green <= ({DATA_out_delay5[10:5]}>>3);
                delay5_blue <= ({1'b0,DATA_out_delay5[4:0]}>>3);
            end            
        end
    end
end

endmodule