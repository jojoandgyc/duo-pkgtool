#!/bin/bash

function genbc_sd()
{
	source ~/.bashrc
	
	if [ -z "${RT_DUO_BKERNEL}" ]; then
		echo "## please build firstly and check the environment variable RT_DUO_BKERNEL before using duo-sdk !!"
		return 1
	else 
		IMNAME=rtthread.bin
		
		if [ ! -f "${RT_DUO_BKERNEL}/${IMNAME}" ]; then
			echo "## please build Big core firstly and check the RT-Thread root dir !!"
			return 1
		fi
		
		pushd ${DUO_SCRIPT_DIR}
			bash mksdimg.sh ${RT_DUO_BKERNEL} ${IMNAME}
		popd
 	fi
}

function gensc_fip()
{
	source ~/.bashrc
	
 	if [ -z "${RT_DUO_SKERNEL}" ]; then
		echo "## please build firstly and check the environment variable RT_DUO_SKERNEL before using duo-sdk !!"
		return 1
	else 
		IMNAME=rtthread.bin
		
		if [ ! -f "${RT_DUO_SKERNEL}/${IMNAME}" ]; then
			echo "## please build Small core firstly and check the RT-Thread root dir !!"
			return 1
		fi
		
		pushd ${DUO_SCRIPT_DIR}
			bash combine-fip.sh ${RT_DUO_SKERNEL} ${IMNAME}
		popd
 	fi
}

BOARD=$1

BKERNEL_TMP="$DUO_SCRIPT_DIR/device/${BOARD}/bkernel"
SKERNEL_TMP="$DUO_SCRIPT_DIR/device/${BOARD}/skernel"

if [ ! -f "$BKERNEL_TMP/tmp" ]; then
	if [ -z "${RTT_ROOT}" ]; then
		echo "## please check the environment variable RTT_ROOT before using duo-sdk !!"
		return 1
	else 
		BUILD_FILE_PATH="$RTT_ROOT/bsp/cvitek/cv18xx_risc-v/rtconfig.py"
		if [ -f $BUILD_FILE_PATH ]; then
    		rm -rf $BUILD_FILE_PATH
    		cp -rf "${BKERNEL_TMP}/rtconfig.py" $BUILD_FILE_PATH
    	else 
    		echo "Make sure RTT_ROOT points to the correct directory"
    		return 1
		fi
		touch "$BKERNEL_TMP/tmp"
		if [ $? -ne 0 ]; then
			echo "Failed to create file tmp in directory '${BKERNEL_TMP}'."
			return 1
		fi
		echo ${RTT_ROOT} >> "$BKERNEL_TMP/tmp"
		echo "The large core directory is configured successfully, and the duo-sdk can work"
	fi
else 
	check=false
	while IFS= read -r line; do
    	if [ "$line" == "$RTT_ROOT" ]; then
        	check=true
        	break
    	fi
	done < ${BKERNEL_TMP}/tmp
	
	if [[ "$check" == false ]]; then
		BUILD_FILE_PATH="$RTT_ROOT/bsp/cvitek/cv18xx_risc-v/rtconfig.py"
		if [ -f $BUILD_FILE_PATH ]; then
    		rm -rf $BUILD_FILE_PATH
    		cp -rf "${BKERNEL_TMP}/rtconfig.py" $BUILD_FILE_PATH
    	else
    		echo "Make sure RTT_ROOT points to the correct directory"
    		return 1
		fi
		echo ${RTT_ROOT} >> "$BKERNEL_TMP/tmp"
		if [ $? -ne 0 ]; then
			echo "Failed to write file tmp in directory '${BKERNEL_TMP}'."
			return 1
		fi
		echo "The new large core directory is configured successfully"
	fi
fi

if [ ! -f "$SKERNEL_TMP/tmp" ]; then
	if [ -z "${RTT_ROOT}" ]; then
		echo "## please check the environment variable RTT_ROOT before using duo-sdk !!"
		return 1
	else 
		BUILD_FILE_PATH="$RTT_ROOT/bsp/cvitek/c906_little/rtconfig.py"
		if [ -f $BUILD_FILE_PATH ]; then
    		rm -rf $BUILD_FILE_PATH
    		cp -rf "${SKERNEL_TMP}/rtconfig.py" $BUILD_FILE_PATH
    	else 
    		echo "Make sure RTT_ROOT points to the correct directory"
    		return 1
		fi
		touch "$SKERNEL_TMP/tmp"
		if [ $? -ne 0 ]; then
			echo "Failed to create file tmp in directory '${SKERNEL_TMP}'."
			return 1
		fi
		echo ${RTT_ROOT} >> "$SKERNEL_TMP/tmp"	
		echo "The small core directory is configured successfully, and the duo-sdk can work"
	fi
else
	check=false
	while IFS= read -r line; do
    	if [ "$line" == "$RTT_ROOT" ]; then
        	check=true
        	break
    	fi
	done < ${SKERNEL_TMP}/tmp
	
	if [[ "$check" == false ]]; then
		BUILD_FILE_PATH="$RTT_ROOT/bsp/cvitek/c906_little/rtconfig.py"
		if [ -f $BUILD_FILE_PATH ]; then
    		rm -rf $BUILD_FILE_PATH
    		cp -rf "${SKERNEL_TMP}/rtconfig.py" $BUILD_FILE_PATH
    	else 
    		echo "Make sure RTT_ROOT points to the correct directory"
    		return 1
		fi
		echo ${RTT_ROOT} >> "$SKERNEL_TMP/tmp"
		if [ $? -ne 0 ]; then
			echo "Failed to write file tmp in directory '${SKERNEL_TMP}'."
			return 1
		fi
		echo "The new small core directory is configured successfully"
	fi	
fi

export OUTPUT_DIR="$DUO_SDK_DIR/output"
if [ ! -d $OUTPUT_DIR ]; then
    mkdir -p $OUTPUT_DIR
	if [ $? -ne 0 ]; then
    	echo "Error: Failed to create directory '$OUTPUT_DIR'."
    	return 1
	fi
fi

print_usage


