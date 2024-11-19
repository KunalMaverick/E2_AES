module TTR_KeyExpansion #(
    parameter nk = 4,  // Number of key words (for AES-128, nk=4)
    parameter nr = 10  // Number of rounds (for AES-128, nr=10)
)(
    input wire          clk,
    input wire          reset,
    input wire [127:0]  key,          // Initial 128-bit key
    output reg [127:0]  expanded_key, // Final expanded key
    output reg          valid
);
    // Internal signals to hold the expanded keys for each run
    reg [127:0] result1, result2, result3;
    reg [1:0] state;                  // State for state machine
    reg [1:0] run_count;              // Counter for AES key expansion runs
    reg start;                        // Control signal to trigger key expansion

    // Output register from keyExpansion (w will hold the expanded key)
    wire [127:0] w;

    // Instantiate the keyExpansion module
    keyExpansion #(nk, nr) key_expansion_instance (
        .key(key),
        .w(w)  // w will hold the expanded key
    );

    // State Machine to manage the three key expansion runs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            run_count <= 0;
            valid <= 0;
            start <= 1;
        end else begin
            case (state)
                2'b00: begin
                    // First key expansion run
                    result1 <= w;             // Store the first run result
                    run_count <= run_count + 1;
                    state <= 2'b01;
                end
                2'b01: begin
                    // Second key expansion run
                    result2 <= w;             // Store the second run result
                    run_count <= run_count + 1;
                    state <= 2'b10;
                end
                2'b10: begin
                    // Third key expansion run
                    result3 <= w;             // Store the third run result
                    valid <= 1;               // Mark the result as valid
                    state <= 2'b11;
                end
                2'b11: begin
                    // End state, stop further execution
                    start <= 0;
                end
            endcase
        end
    end

    // Majority voting logic to select the final expanded key
    always @(*) begin
        if (valid) begin
            // Compare the results and use majority voting
            if ((result1 == result2) || (result1 == result3)) begin
                expanded_key = result1;
            end else if (result2 == result3) begin
                expanded_key = result2;
            end else begin
                expanded_key = result3;
            end
        end else begin
            expanded_key = 128'h0;  // Default to 0 if not valid
        end
    end

endmodule
