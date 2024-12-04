#!/bin/bash

function get_board_type()
{
	BOARD_CONFIG=("CONFIG_BOARD_TYPE_MILKV_DUO" "CONFIG_BOARD_TYPE_MILKV_DUO_SPINOR" "CONFIG_BOARD_TYPE_MILKV_DUO_SPINAND" "CONFIG_BOARD_TYPE_MILKV_DUO256M" "CONFIG_BOARD_TYPE_MILKV_DUO256M_SPINOR" "CONFIG_BOARD_TYPE_MILKV_DUO256M_SPINAND" "CONFIG_BOARD_TYPE_MILKV_DUOS")
	BOARD_VALUE=("milkv-duo" "milkv-duo-spinor" "milkv-duo-spinand" "milkv-duo256m" "milkv-duo256m-spinor" "milkv-duo256m-spinand" "milkv-duos-sd")
	STORAGE_VAUE=("sd" "spinor" "spinand" "sd" "spinor" "spinand" "sd")

	for ((i=0;i<${#BOARD_CONFIG[@]};i++))
	do
		config_value=$(grep -w "${BOARD_CONFIG[i]}" ${PROJECT_PATH}/.config | cut -d= -f2)
		if [ "$config_value" == "y" ]; then
			BOARD_TYPE=${BOARD_VALUE[i]}
			STORAGE_TYPE=${STORAGE_VAUE[i]}
			break
		fi
	done
    export BOARD_TYPE=${BOARD_TYPE}
    export STORAGE_TYPE=${STORAGE_TYPE}
}

function do_combine()
{
	BLCP_IMG_RUNADDR=0x05200200
	BLCP_PARAM_LOADADDR=0
	NAND_INFO=00000000
	NOR_INFO='FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
	FIP_COMPRESS=lzma

	FSBL_BUILD_PLAT=${PREBUILT_PATH}/fsbl
	OPENSBI_BUILD_PATH=${PREBUILT_PATH}/opensbi
	UBOOT_BUILD_PATH=${PREBUILT_PATH}/uboot
	
	CHIP_CONF_PATH=${FSBL_BUILD_PLAT}/chip_conf.bin
	DDR_PARAM_TEST_PATH=${FSBL_BUILD_PLAT}/ddr_param.bin
	BLCP_PATH=${FSBL_BUILD_PLAT}/empty.bin

	MONITOR_PATH=${OPENSBI_BUILD_PATH}/fw_dynamic.bin
	LOADER_2ND_PATH=${UBOOT_BUILD_PATH}/u-boot-raw.bin
	
	if [ ! -x "${FSBL_BUILD_PLAT}/fiptool.py" ]; then
		echo "File '${FSBL_BUILD_PLAT}/fiptool.py' is not executable. Adding executable permission..."
		chmod +x "${FSBL_BUILD_PLAT}/fiptool.py"
 	fi
 	
	echo "Combining fip.bin..."
	. ${FSBL_BUILD_PLAT}/blmacros.env && \
	${FSBL_BUILD_PLAT}/fiptool.py -v genfip \
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

