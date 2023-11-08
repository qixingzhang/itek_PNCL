all: block_design bitstream

block_design:
	vivado -mode batch -source ./scripts/block_design.tcl -notrace

bitstream:
	vivado -mode batch -source ./scripts/bitstream.tcl -notrace

clean:
	rm -rf vivado_project *.jou *.log *.str *.bit *.hwh
