#!/bin/sh

set -u

MASTER_NUM=9
SLAVE_NUM=15

master_idx_name() {
    case $1 in
      "0") echo "CPU";;
      "1") echo "CS_TRACE";;
      "2") echo "AMB2";;
      "3") echo "AMB3";;
      "4") echo "INIC";;
      "5") echo "XOR0";;
      "6") echo "XOR1";;
      "7") echo "PCIE";;
      "8") echo "GIC";;
      *) echo "UNK";;
    esac
}

slave_idx_name() {
    case $1 in
      "0") echo "RES0";;
      "1") echo "AMB3";;
      "2") echo "PCIE";;
      "3") echo "CPU_ACP";;
      "4") echo "AMB2";;
      "5") echo "MG0_CM3_SRAM";;
      "6") echo "MG1_CM3_SRAM";;
      "7") echo "MG2_CM3_SRAM";;
      "8") echo "ROM";;
      "9") echo "SRAM";;
      "10") echo "GIC";;
      "11") echo "RES1";;
      "12") echo "DDR";;
      "13") echo "INIC";;
      *) echo "UNK";;
    esac
}

# $1 - master idx                                                         
# $2 - slave idx                                                          
addr_dec_dump() {                                                         
	local master_idx=$1                                                   
	local slave_idx=$2                                                    
	local offset=$((0x80400000 + 0x00010000 * master_idx + 0x18 * slave_idx))

	printf "\tattrs: 0x%x\n" `devmem $((offset+0x100))`                   
	printf "\tsize: 0x%x\n" `devmem $((offset+0x104))`                    
	printf "\tbase high: 0x%x\n" `devmem $((offset+0x108))`               
	printf "\tbase low: 0x%x\n" `devmem  $((offset+0x10c))`               
	printf "\tremap: 0x%x\n" `devmem $((offset+0x110))`                   
	printf "\taxi attrs: 0x%x\n" `devmem $((offset+0x114))`               
}                                                                         

# $1 - master idx                                                         
addr_err_dump() {
    local master_idx=$1
    local offset=$((0x80400000 + 0x00010000 * master_idx))

    printf "\t%s: 0x%x\n" $(master_idx_name $master_idx) `devmem $((offset+0x100))`                   
}

echo "Illegal address access:"
echo "-----------------------"
echo ""

for m in $(seq 0 8)
do
    addr_err_dump $m
done
echo ""

echo "Addres Map:"
echo "-----------"
echo ""

for m in $(seq 0 8)
do
    for s in $(seq 0 13)
    do
        echo "$(master_idx_name $m) -> $(slave_idx_name $s)"
        addr_dec_dump $m $s
	echo ""
    done
done
