#!/bin/bash

function print_usage()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo-pkgtool.\033[94m We can help you Pack RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    \33[92m 打包 \33[0m- 将大小核的编译结果分别打包成大小核的镜像。 \n"
  printf "        ex: $ mkpkg \n"
  printf "        \33[96mTip: 这个命令用于将大小核的编译结果进行打包。默认执行将打包大核，携带-a可以同时打包大核和小核。\033[0m \n"
  printf "        ex: $ mkpkg -a \n\n"
  printf "   ## 你可以在终端输入\033[95mhelp\033[0m来得到提示和更多信息:D \n"
  printf "   ## ex: $ help \n\n"
  printf "   \033[91m 注意: 目前板子的硬件配置信息是默认配置 !!\033[0m \n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}

function help()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo-pkgtool.\033[94m We can help you Pack RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    \33[92m 打包 \33[0m- 将大小核的编译结果分别打包成大小核的镜像。 \n"
  printf "        ex: $ mkpkg \n"
  printf "        \33[96mTip: 这个命令用于将大小核的编译结果进行打包。默认执行将打包大核，携带-a可以同时打包大核和小核。\033[0m \n"
  printf "        ex: $ mkpkg -a \n\n"
  printf "   ## 你可以在终端输入\033[95mhelp\033[0m来得到提示和更多信息:D \n"
  printf "   ## ex: $ help \n\n"
  printf "   \033[91m 注意: 目前板子的硬件配置信息是默认配置 !!\033[0m \n"
  printf "   \033[93m 此外，你还应当注意以下几点\033[0m \n"
  printf "    (1) # 在使用duo-sdk之前，应当配置好环境变量。\n"
  printf "    (2) # 每次使用duo-pkgtool工具前，应当执行env.sh。\n"
  printf "    (3) # 如DPT_PATH，DPT_PATH_KERNEL。其中DPT_PATH指向duo-pkgtool工具的根目录（形如 ‘.../duo-pkgtool’），DPT_PATH_KERNEL指向RT-Thread目录下的duo工作目录（形如 ‘.../bsp/cvitek’）\n"
  printf "    (4) # 输出目录在duo-sdk/output目录下。\n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}

if [ ! -z "${DPT_PATH}" ]; then
	if [ -d "${DPT_PATH}" ]; then
    	if [ ! -d "${DPT_PATH}/prebuilt" ] || [ ! -d "${DPT_PATH}/script" ]; then
    		echo "## duo-pkgtool所在目录不完全，无法正常使用，请更改为有效的duo-pkgtool路径或尝试重新下载duo-pkgtool工具。"
    		return 1
		else
    		echo "## duo-pkgtool工具检验完成，你可以尝试使用duo-pkgtool工具。"
		fi
    else 
    	echo "## duo-pkgtool的路径不存在。请检查环境变量DPT_PATH，请更改为有效的duo-pkgtool路径。"
    	return 1
	fi
	
	export DUO_PKGTOOL_PATH=${DPT_PATH}
	DUO_SCRIPT_PATH="${DUO_PKGTOOL_PATH}/script"
else
	echo "## 请检查环境变量DPT_PATH !!"
 	return 1
fi

source "${DUO_SCRIPT_PATH}/build.sh" 

