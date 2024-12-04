#!/bin/bash

function mkpkg() {
	if [ -z "${DPT_PATH_KERNEL}" ]; then
		echo "## 请先配置环境变量DPT_PATH_KERNEL，它指向RT-Thread目录下duo系列的工作目录，例如‘.../bsp/cvitek’ !!"
		return 1
	fi
	
	if [ $# -eq 0 ]; then
		RT_DUO_BKERNEL="${DPT_PATH_KERNEL}/cv18xx_risc-v"
		BIMAGE=Image
		if [ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]; then
			echo "## 请先在环境变量DPT_PATH_KERNEL所指的目录成功编译risc-v的大核，然后再次尝试打包 !!"
			return 1
		fi
		
		pushd "${DUO_PKGTOOL_PATH}/script"
			bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE}
		popd
		
	elif [ $# -gt 1 ]; then
		echo "## 打包出错，命令的参数错误 !!"
		return 1
	else
		if [ "$1" == "-a" ]; then
			RT_DUO_BKERNEL="${DPT_PATH_KERNEL}/cv18xx_risc-v"
			BIMAGE=Image
			if [ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]; then
				echo "## 请先在环境变量DPT_PATH_KERNEL所指的目录成功编译risc-v的大核后，然后再次尝试打包 !!"
				return 1
			fi
			
			RT_DUO_SKERNEL="${DPT_PATH_KERNEL}/c906_little"
			SIMAGE=rtthread.bin
			if [ ! -f "${RT_DUO_SKERNEL}/${SIMAGE}" ]; then
				echo "## 请先在环境变量DPT_PATH_KERNEL所指的目录成功编译risc-v的小核后，然后再次尝试打包 !!"
				return 1
			fi
			
			pushd "${DUO_PKGTOOL_PATH}/script"
				bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE}
				bash combine-fip.sh ${RT_DUO_SKERNEL} ${SIMAGE}
			popd
			
		else
			echo "## 打包出错，命令的参数错误 !!"
			return 1
		fi
	fi	
	
}

export OUTPUT_DIR="${DUO_PKGTOOL_PATH}/output"
if [ ! -d $OUTPUT_DIR ]; then
    mkdir -p $OUTPUT_DIR
	if [ $? -ne 0 ]; then
    	echo "Error: Failed to create directory '$OUTPUT_DIR'."
    	return 1
	fi
fi

print_usage

