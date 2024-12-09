#!/bin/bash

function get_board_type()
{
	if [ ! -d "${PREBUILT_PATH}/common" ]; then
		printf "## The prebuilt directory is incomplete and cannot be used properly !!\n"
		exit 1
	fi

	local BOARD=$1
 	local VENDOR="milkv"
 	
 	local tmp_check=false
	local result_array=()
 	
 	printf "\n# The model of duo you selected is {${BOARD}} \n\n"
 	
	for dir in "$PREBUILT_PATH"/*/; do
    	if [[ "$(basename "$dir")" == "common" ]]; then
    	    continue
    	fi
 
    	dirname=$(basename "$dir")

    	if [[ "$dirname" == "${VENDOR}-"* ]]; then
    	    dirname="${dirname#${VENDOR}-}"
    	fi
 
    	result_array+=("$dirname")
	done
	
	if [ ${#result_array[@]} -eq 0 ]; then
		printf "## ${VENDOR}'s duo series is not currently supported !\n"
		exit 1
	else 	
		printf "# ${VENDOR}'s duo series currently only supports: \n\n"
		
		for element in "${result_array[@]}"; do
			printf " <${element}>\n"
		done
 	fi
 	
	for value in "${result_array[@]}"; do
    	if [[ "$value" == "$BOARD" ]]; then
			tmp_check=true
			break
    	fi
	done
	
	printf "\n"
	
	if [[ "$tmp_check" == false ]]; then
		printf "## The model of duo you have selected is not currently supported.\n"
		printf "## You can try other models, and you can try changing the model of duo by configuring the 'BOARD_TYPE' option of the 'change_config' command, and then try again !!\n"
		exit 1
	fi
	
	export BOARD_TYPE="${VENDOR}-${BOARD}"
	export STORAGE_TYPE="sd"
}

function do_combine()
{
	BLCP_IMG_RUNADDR=0x05200200
	BLCP_PARAM_LOADADDR=0
	NAND_INFO=00000000
	NOR_INFO='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
	FIP_COMPRESS=lzma

	FSBL_BUILD_PLAT=${PREBUILT_PATH}/${BOARD_TYPE}/fsbl
	OPENSBI_BUILD_PATH=${PREBUILT_PATH}/${BOARD_TYPE}/opensbi
	UBOOT_BUILD_PATH=${PREBUILT_PATH}/${BOARD_TYPE}/uboot
	
	CHIP_CONF_PATH=${FSBL_BUILD_PLAT}/chip_conf.bin
	DDR_PARAM_TEST_PATH=${FSBL_BUILD_PLAT}/ddr_param.bin
	BLCP_PATH=${FSBL_BUILD_PLAT}/empty.bin

	MONITOR_PATH=${OPENSBI_BUILD_PATH}/fw_dynamic.bin
	LOADER_2ND_PATH=${UBOOT_BUILD_PATH}/u-boot-raw.bin
	
	COMMON_DIR="${PREBUILT_PATH}/common"
	if [ ! -x "${COMMON_DIR}/fiptool.py" ]; then
		echo "File '${COMMON_DIR}/fiptool.py' is not executable. Adding executable permission..."
		chmod +x "${COMMON_DIR}/fiptool.py"
 	fi
 	
	echo "Combining fip.bin..."
	. ${FSBL_BUILD_PLAT}/blmacros.env && \
	${COMMON_DIR}/fiptool.py -v genfip \
	${FSBL_BUILD_PLAT}/fip.bin \
	--MONITOR_RUNADDR="${MONITOR_RUNADDR}" \
	--BLCP_2ND_RUNADDR="${BLCP_2ND_RUNADDR}" \
	--CHIP_CONF=${CHIP_CONF_PATH} \
	--NOR_INFO=${NOR_INFO} \
	--NAND_INFO=${NAND_INFO} \
	--BL2=${FSBL_BUILD_PLAT}/bl2.bin \
	--BLCP_IMG_RUNADDR=${BLCP_IMG_RUNADDR} \
	--BLCP_PARAM_LOADADDR=${BLCP_PARAM_LOADADDR} \
	--BLCP=${BLCP_PATH} \
	--DDR_PARAM=${DDR_PARAM_TEST_PATH} \
	--BLCP_2ND=${BLCP_2ND_PATH} \
	--MONITOR=${MONITOR_PATH} \
	--LOADER_2ND=${LOADER_2ND_PATH} \
	--compress=${FIP_COMPRESS}

	mv -f ${FSBL_BUILD_PLAT}/fip.bin ${OUT_PATH}/${BOARD_TYPE}/fip.bin
}

