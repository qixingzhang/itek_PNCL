# ITEK_PNCL
iTEK PNCL camera driver

## Build
* Build block design
    ```
    vivado -mode batch -source ./scripts/block_design.tcl -notrace
    ```

* Build bitstream
    ```
    vivado -mode batch -source ./scripts/bitstream.tcl -notrace
    ```
