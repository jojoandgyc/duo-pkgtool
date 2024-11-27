#!/bin/bash

function print_usage()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo_sdk.\033[94m We can help you Pack RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    (1)\33[96m 编译 \33[0m- 编译源码需要到RT-Thread的duo源码目录下。\n"
  printf "        ### 目前只支持大小核的risc-v版本。\033[93m cv18xx_risc-v/ -->大核源码目录\33[0m ;\033[31m c906_little/ -->小核源码目录\33[0m \n\n"
  printf "    (2)\33[92m 打包 \33[0m- 将大小核的编译结果分别打包成大小核的镜像。 \n"
  printf "        ex: $ genbc_sd  -->大核打包 \n"
  printf "        ex: $ gensc_fip  -->小核打包 \n\n"
  printf "   ## 你可以在终端输入\033[95mhelp\033[0m来得到提示和更多信息:D \n"
  printf "   ## ex: $ help \n\n"
  printf "   \033[91m 注意: 目前板子的硬件配置信息是默认配置 !!\033[0m \n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}

function print_err_choice()
{
  printf "  ------------------------------------------------------------------------------\n"
  printf "  \033[31m 输入错误:\033[0m \n"
  printf "  	### 第一个参数是\033[94mduo的型号\033[0m。\n"
  printf "  	### Models of duo can be \033[93mduo\033[0m,\033[93m duo256m\033[0m,\033[93m duos\033[0m。\n"
  printf "  	ex: $ source duo-sdk/script/env duo256m \n\n"
  printf "  ------------------------------------------------------------------------------\n"
}

function help()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo_sdk.\033[94m We can help you Pack RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    (1)\33[96m 编译 \33[0m- 编译源码需要到RT-Thread的duo源码目录下。\n"
  printf "        ### 目前只支持大小核的risc-v版本。\033[93m cv18xx_risc-v/ -->大核源码目录\33[0m ;\033[31m c906_little/ -->小核源码目录\33[0m \n\n"
  printf "    (2)\33[92m 打包 \33[0m- 将大小核的编译结果分别打包成大小核的镜像。 \n"
  printf "        ex: $ genbc_sd  -->大核打包 \n"
  printf "        ex: $ gensc_fip  -->小核打包 \n\n"
  printf "   ## 你可以在终端输入\033[95mhelp\033[0m来得到提示和更多信息:D \n"
  printf "   ## ex: $ help \n\n"
  printf "   \033[91m 注意: 目前板子的硬件配置信息是默认配置 !!\033[0m \n\n"
  printf "   \033[93m 此外，你还应当注意以下几点\033[0m \n"
  printf "    (1) # 在使用duo-sdk之前，应当配置好环境变量。\n"
  printf "    (2) # 其中最重要的是RTT_ROOT，这个是RT-Thread的源码的根目录路径，这将决定duo-sdk将服务于哪个RT-Thread目录。\n"
  printf "    (3) # 输出目录在duo-sdk/output目录下。\n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}

BOARD_NAME=("duo" "duo256m" "duos")

PARAM1=$1

check_first_param=false
for element in "${BOARD_NAME[@]}"; do
    if [[ "$PARAM1" == "$element" ]]; then
        check_first_param=true
        break
    fi
done

if [[ "$check_first_param" == false ]]; then
    print_err_choice
    return 1
fi

BOARD_MODEL="${PARAM1}"

export DUO_SCRIPT_DIR=$(dirname $(readlink -f "$0"))

export DUO_SDK_DIR="${DUO_SCRIPT_DIR}/.."

source "$DUO_SCRIPT_DIR/build.sh" ${BOARD_MODEL}

