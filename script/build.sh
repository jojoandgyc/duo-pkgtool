#!/bin/bash

if [[ -z "${DPT_BOARD_TYPE}" ]] || [[ -z "${DPT_PATH_KERNEL}" ]] || [[ -z "${DPT_PATH_OUTPUT}" ]] || [[ -z "${DPT_PATH}" ]]; then
	printf "## Please run env.sh firstly, then try again !!\n"
	return 1
fi

function print_env()
{
	printf "  -------------------------------------------------------------------------------------------------------\n"
	printf "  Here is some\033[91m variable information \033[0mfor duo-pkgtool \n\n"
	printf "     The currently selected duo model is: {\033[93m${DPT_BOARD_TYPE}\033[0m}\n\n"
	printf "     The working directory of duo in the RT-Thread directory currently selected is: '\033[93m${DPT_PATH_KERNEL}\033[0m'\n\n"
	printf "     The currently selected output directory is: '\033[93m${DPT_PATH_OUTPUT}\033[0m'\n\n"
	printf "     The current duo-pkgtool directory is: '\033[93m${DPT_PATH}\033[0m'\n\n"
	
	printf "  ## If you want to change these configurations, you can use the '\033[92mchange_config\033[0m' command. \n"
	printf "  -------------------------------------------------------------------------------------------------------\n"
}

function print_usage()
{
	printf "  -------------------------------------------------------------------------------------------------------\n"
	printf "  \033[91m Hello, this is Duo-pkgtool.\033[94m We can help you Pack RT-Threads.\033[93m Here's how to use\033[0m \n"
	printf "    Usage:\n"
	printf "    \33[94m Packing \33[0m- pack the compilation results separately into images. \n"
	printf "        ex: $ mkpkg \n"
	printf "        \33[92mTip: You can choose according to your needs.\033[0m \n\n"
	printf "    \33[96m Config \33[0m- configure the basic information of duo-pkgtool. \n"
	printf "        ex: $ change_config \n"
	printf "        \33[92mTip: You can choose according to your needs.\033[0m \n\n"
	printf "   ## You can type\033[95m print_usage \033[0mto get tips, and you can type\033[95m print_env \033[0mto get more information :D \n"
	printf "   ## ex: $ print_usage \n\n"
	printf "   ## ex: $ print_env \n"
	printf "  -------------------------------------------------------------------------------------------------------\n"
}

PACK_MENU_ITEMS=("Packing the large core" "Packing the small core" "All of them")
PACK_NUM_ITEMS=${#PACK_MENU_ITEMS[@]}
PACK_CURRENT_SELECTION=0 

print_pack_menu() {
	clear
	printf "# Please choose what you would want to pack -(Q/q Exit)-\n\n"
	for i in "${!PACK_MENU_ITEMS[@]}"; do
		if [ $i -eq $PACK_CURRENT_SELECTION ]; then
			printf "%-15s <==\n" "${PACK_MENU_ITEMS[i]}"
		else
			printf "%-15s\n" "${PACK_MENU_ITEMS[i]}"
		fi
	done
}

function mkpkg() {
	
	while true; do
		print_pack_menu
		
		read -rsn1 input
		case $input in
			A) # (Notice \E[A)
				if [ $PACK_CURRENT_SELECTION -gt 0 ]; then
					((PACK_CURRENT_SELECTION--))
				fi
				;;
			B) # (Notice \E[B)
				if [ $PACK_CURRENT_SELECTION -lt $((PACK_NUM_ITEMS - 1)) ]; then
					((PACK_CURRENT_SELECTION++))
				fi
				;;
			"")
				case $PACK_CURRENT_SELECTION in
					0) 
						RT_DUO_BKERNEL="${DPT_PATH_KERNEL}/cv18xx_risc-v"
						BIMAGE=Image
						if [[ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]]; then
							printf "\n## Firstly, please compile successfully the duo directory of the RT-Thread directory you specified or check the duo kernel directory you specified is correct.\n"
							printf "## You can try changing the directory of duo by configuring the 'KERNEL_PATH' option of the 'change_config' command, and then try again !!\n"
							return 1
						fi
		
						pushd "${DPT_PATH}/script"
							bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
						popd

						;;
					1) 
						RT_DUO_SKERNEL="${DPT_PATH_KERNEL}/c906_little"
						SIMAGE=rtthread.bin
						if [[ ! -f "${RT_DUO_SKERNEL}/${SIMAGE}" ]]; then
							printf "\n## Firstly, please compile successfully the duo directory of the RT-Thread directory you specified or check the duo kernel directory you specified is correct.\n"
							printf "## You can try changing the directory of duo by configuring the 'KERNEL_PATH' option of the 'change_config' command, and then try again !!\n"
							return 1
						fi
						
						pushd "${DPT_PATH}/script"
							bash combine-fip.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
						popd
						
						;;
					2) 
						RT_DUO_BKERNEL="${DPT_PATH_KERNEL}/cv18xx_risc-v"
						BIMAGE=Image
						RT_DUO_SKERNEL="${DPT_PATH_KERNEL}/c906_little"
						SIMAGE=rtthread.bin
						if [[ ! -f "${RT_DUO_SKERNEL}/${SIMAGE}" ]] || [[ ! -f "${RT_DUO_BKERNEL}/${BIMAGE}" ]]; then
							printf "\n## Firstly, please compile successfully the duo directory of the RT-Thread directory you specified or check the duo kernel directory you specified is correct.\n"
							printf "## You can try changing the directory of duo by configuring the 'KERNEL_PATH' option of the 'change_config' command, and then try again !!\n"
							return 1
						fi
						
						pushd "${DPT_PATH}/script"
							bash mksdimg.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
							bash combine-fip.sh ${RT_DUO_BKERNEL} ${BIMAGE} ${DPT_BOARD_TYPE} ${DPT_PATH_OUTPUT}
						popd
			
						;;
				esac
				break
				;;
			Q|q) 
				printf "# Exit successfully \n\n"
				return 0
				;;
			*)
				;;
		esac
	done
	
}

print_usage

