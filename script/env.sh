#!/bin/bash

DPT_SCRIPT_PATH=$(dirname $(readlink -f "$0"))
CONFIG_NAME=".config"
CONFIG_PATH="${DPT_SCRIPT_PATH}/${CONFIG_NAME}"

CONFIG_MENU_ITEMS=("BOARD_TYPE" "KERNEL_PATH" "OUTPUT_PATH")
CONFIG_NUM_ITEMS=${#CONFIG_MENU_ITEMS[@]}
CONFIG_CURRENT_SELECTION=0 

is_valid_model() {
	local BOARD_NAME=("duo" "duo256m" "duos")
    local PARAM1=$1
    local check_param=false
	for element in "${BOARD_NAME[@]}"; do
    	if [[ "$PARAM1" == "$element" ]]; then
        	check_param=true
        	break
    	fi
	done
	if [[ "$check_param" == true ]]; then
    	return 0
    else 
    	return 1
	fi
}

is_valid_path() {
    local path="$1"
    if [[ ! "$path" =~ ^/[-_.a-zA-Z0-9/]*$ ]]; then
        return 1
    fi
    
    if [ -d "$path" ]; then
        return 0  
    elif [ -f "$path" ]; then
        return 1
    else
        return 1 
    fi
}

print_config_menu() {
    clear
    printf "# Please select the option you want to configure -(Q/q Exit)-\n\n"
    for i in "${!CONFIG_MENU_ITEMS[@]}"; do
        if [ $i -eq $CONFIG_CURRENT_SELECTION ]; then
            printf "%-15s <==\n" "${CONFIG_MENU_ITEMS[i]}"
        else
            printf "%-15s\n" "${CONFIG_MENU_ITEMS[i]}"
        fi
    done
}

function change_config()
{	
	if [ ! -f "${CONFIG_PATH}" ]; then
		printf "## The configuration file '.config' cannot be found. Please close the terminal, then try again!\n"
		return 1
	fi
	
	while true; do
		print_config_menu
		
		read -rsn1 input
    	case $input in
			A) # (Notice \E[A)
				if [ $CONFIG_CURRENT_SELECTION -gt 0 ]; then
					((CONFIG_CURRENT_SELECTION--))
				fi
				;;
			B) # (Notice \E[B)
				if [ $CONFIG_CURRENT_SELECTION -lt $((CONFIG_NUM_ITEMS - 1)) ]; then
					((CONFIG_CURRENT_SELECTION++))
				fi
				;;
			"")
				case $CONFIG_CURRENT_SELECTION in
					0) 
						printf "# Please specify the board type. \n"
						printf "# The models supported are duo, duo256m and duos.(The default model is duo256m)\n\n"
						
						while IFS= read -r line; do
							if [[ "$line" == "DPT_BOARD_TYPE: "* ]]; then
								BOARD_TYPE="${line#DPT_BOARD_TYPE: }"
								break
							fi
						done < "${CONFIG_PATH}"
						
						if [ ! -z "${BOARD_TYPE}" ]; then
							printf "# The model of duo previously selected is:{${BOARD_TYPE}} \n\n"
						fi
						
						while true; do
							echo -n "Please input board type(You can just input enter, the model used is the default model): "
							read user_input
							if [ -z "$user_input" ]; then
								BOARD="duo256m"
								break 
							fi
    	
							if is_valid_model "$user_input"; then
								BOARD="${user_input}"
								break  
							else
								printf "## The board type you inputted is invalid. Please try again! \n\n"
							fi
						done
						
						if [ ! -z "${BOARD_TYPE}" ]; then
							sed -i "s#^DPT_BOARD_TYPE: .*#DPT_BOARD_TYPE: ${BOARD}#" "${CONFIG_PATH}"
							printf "# The current board type you specify is:${BOARD} \n\n" 							
							printf "# Modified successfully \n\n" 
						else 
							echo "DPT_BOARD_TYPE: ${BOARD}" >> "${CONFIG_PATH}"
							printf "# The current board type you specify is:${BOARD} \n\n" 
							printf "# Configured successfully \n\n" 
						fi

						export DPT_BOARD_TYPE="${BOARD}"

						;;
					1) 
						printf "# Please specify the duo directory under RT-Thread directory. \n"
						printf "# For example:'/home/{username}/xxx/.../xxx/rt-thread/bsp/cvitek' \n\n"
	
						while IFS= read -r line; do
							if [[ "$line" == "DPT_PATH_KERNEL: "* ]]; then
								KERNEL_PATH="${line#DPT_PATH_KERNEL: }"
								break
							fi
						done < "${CONFIG_PATH}"

						if [ ! -z "${KERNEL_PATH}" ]; then
							printf "# The previously selected directory for duo is:'${KERNEL_PATH}' \n\n"
						fi
		
						while true; do
							echo -n "Please input duo directory: "
							read user_input
							if [ -z "$user_input" ]; then
								printf "## The directory you inputted is invalid. Please try again! \n\n"
								continue 
							fi
    	
							if is_valid_path "$user_input"; then
								KERNEL_DIR="${user_input}"
								break  
							else
								printf "## The directory you inputted is invalid. Please try again! \n\n"
							fi
						done
						
						if [ ! -z "${KERNEL_PATH}" ]; then
							sed -i "s#^DPT_PATH_KERNEL: .*#DPT_PATH_KERNEL: ${KERNEL_DIR}#" "${CONFIG_PATH}"
							printf "# The current duo directory you specify is:${KERNEL_DIR} \n\n" 							
							printf "# Modified successfully \n\n" 
						else 
							echo "DPT_PATH_KERNEL: ${KERNEL_DIR}" >> "${CONFIG_PATH}"
							printf "# The current duo directory you specify is:${KERNEL_DIR} \n\n" 
							printf "# Configured successfully \n\n" 
						fi

						export DPT_PATH_KERNEL=$(realpath "${KERNEL_DIR}")

						;;
					2) 
						printf "# Please specify the output directory. \n\n"

						while IFS= read -r line; do
							if [[ "$line" == "DPT_PATH_OUTPUT: "* ]]; then
								OUTPUT_PATH="${line#DPT_PATH_OUTPUT: }"
								break
							fi
						done < "${CONFIG_PATH}"						
						
						if [ ! -z "${OUTPUT_PATH}" ]; then
							printf "# The previously selected output directory is:'${OUTPUT_PATH}' \n\n"
						fi
						
						while true; do
							echo -n "Please input the output directory(You can just input enter, the output directory default is '.../duo-pkgtool/output'): "
							read user_input
							if [ -z "$user_input" ]; then
								OUT_PATH=$(realpath "${DPT_SCRIPT_PATH}/../output")
								break 
							fi
    	
							if is_valid_path "$user_input"; then
								OUT_PATH="${user_input}"
								break  
							else
								printf "## The directory you inputted does not exist. Please try again! \n\n"
							fi
						done

						if [ ! -z "${OUTPUT_PATH}" ]; then
							sed -i "s#^DPT_PATH_OUTPUT: .*#DPT_PATH_OUTPUT: ${OUT_PATH}#" "${CONFIG_PATH}"
							printf "# The current output directory you specify is:${OUT_PATH} \n\n" 							
							printf "# Modified successfully \n\n" 
						else 
							echo "DPT_PATH_OUTPUT: ${OUT_PATH}" >> "${CONFIG_PATH}"
							printf "# The current output directory you specify is:${OUT_PATH} \n\n" 
							printf "# Configured successfully \n\n" 
						fi
						 
						if [[ "${OUT_PATH}" == $(realpath "${DPT_SCRIPT_PATH}/../output") ]] && [ ! -d $OUT_PATH ]; then
							mkdir -p $OUT_PATH
							if [ $? -ne 0 ]; then
								echo "Error: Failed to create directory '$OUT_PATH'."
								return 1
							fi
						fi

						export DPT_PATH_OUTPUT=$(realpath "${OUT_PATH}")

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

if [ ! -f "${CONFIG_PATH}" ]; then
	
	printf "# \033[91mHello, here is duo-pkgtool, now configure information for you.\033[0m \n\n"
	
	touch "${CONFIG_PATH}"
	if [ $? -ne 0 ]; then
		echo "Failed to create file '${CONFIG_NAME}' in directory '${DPT_SCRIPT_PATH}'."
		return 1
	fi
	
	printf "# Please specify the board type. \n"
	printf "# The models supported are duo, duo256m and duos.(The default model is duo256m)\n\n"
	
	while true; do
    	echo -n "Please input board type(You can just input enter, the model used is the default model): "
    	read user_input
    	if [ -z "$user_input" ]; then
    		BOARD="duo256m"
			break 
    	fi
    	
    	if is_valid_model "$user_input"; then
        	BOARD="${user_input}"
        	break  
    	else
        	printf "## The board type you inputted is invalid. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_BOARD_TYPE: ${BOARD}" >> "${CONFIG_PATH}"
	printf "# The current board type you specify is:${BOARD} \n\n"
	
	printf "# Please specify the duo directory under RT-Thread directory. \n"
	printf "# For example:'/home/{username}/xxx/.../xxx/rt-thread/bsp/cvitek' \n\n"
	
	while true; do
    	echo -n "Please input duo directory: "
    	read user_input
    	if [ -z "$user_input" ]; then
    		printf "## The directory you inputted is invalid. Please try again! \n\n"
    		continue
    	fi
    	
    	if is_valid_path "$user_input"; then
        	KERNEL_DIR="${user_input}"
        	break  
    	else
        	printf "## The directory you inputted is invalid. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_PATH_KERNEL: ${KERNEL_DIR}" >> "${CONFIG_PATH}"
	printf "# The current duo directory you specify is:${KERNEL_DIR} \n\n"
	
	printf "# Please specify the output directory. \n\n"
	
	while true; do
    	echo -n "Please input the output directory(You can just input enter, the output directory default is '.../duo-pkgtool/output'): "
    	read user_input
    	if [ -z "$user_input" ]; then
    		OUT_PATH=$(realpath "${DPT_SCRIPT_PATH}/../output")
			break
    	fi
    	
    	if is_valid_path "$user_input"; then
        	OUT_PATH="${user_input}"
        	break  
    	else
        	printf "## The directory you inputted does not exist. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_PATH_OUTPUT: ${OUT_PATH}" >> "${CONFIG_PATH}"
	printf "# The current output directory you specify is:${OUT_PATH} \n\n"
	
fi

while IFS= read -r line; do
    if [[ "$line" == "DPT_BOARD_TYPE: "* ]]; then
		BOARD_TYPE="${line#DPT_BOARD_TYPE: }"
		break
    fi
done < "${CONFIG_PATH}"

if [ ! -z "${BOARD_TYPE}" ]; then
	if ! is_valid_model "${BOARD_TYPE}"; then
		echo "## Please check the.config file or try deleting the.config file and try again. The configuration information is incorrect."
		return 1
	else 
		DPT_BOARD_TYPE=${BOARD_TYPE}
		echo "# The current board type you specify is: ${DPT_BOARD_TYPE}"
	fi
else 
	printf "## No board type information found. Now start reconfiguring \n"
	printf "# Please specify the board type. \n"
	printf "# The models supported are duo, duo256m and duos.(The default model is duo256m)\n\n"
	
	while true; do
    	echo -n "Please input board type(You can just input enter, the model used is the default model): "
    	read user_input
    	if [ -z "$user_input" ]; then
    		BOARD="duo256m"
			break 
    	fi
    	
    	if is_valid_model "$user_input"; then
        	BOARD="${user_input}"
        	break  
    	else
        	printf "## The board type you inputted is invalid. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_BOARD_TYPE: ${BOARD}" >> "${CONFIG_PATH}"
	printf "# The current board type you specify is:${BOARD} \n\n"
	DPT_BOARD_TYPE=${BOARD}
fi

while IFS= read -r line; do
    if [[ "$line" == "DPT_PATH_KERNEL: "* ]]; then
		KERNEL_PATH="${line#DPT_PATH_KERNEL: }"
		break
    fi
done < "${CONFIG_PATH}"

if [ ! -z "${KERNEL_PATH}" ]; then
	if ! is_valid_path "${KERNEL_PATH}"; then
		echo "## Please check the.config file or try deleting the.config file and try again. The configuration information is incorrect."
		return 1
	else 
		DPT_PATH_KERNEL=${KERNEL_PATH}
		echo "# The current duo directory you specify is: ${DPT_PATH_KERNEL}"
	fi
else 
	printf "## No duo directory information found. Now start reconfiguring \n"
	printf "# Please specify the duo directory under RT-Thread directory. \n"
	printf "# For example:'/home/{username}/xxx/.../xxx/rt-thread/bsp/cvitek'\n\n"
	
	while true; do
    	echo -n "Please input duo directory: "
    	read user_input
    	if [ -z "$user_input" ]; then
    		printf "## The directory you inputted is invalid. Please try again! \n\n"
    	fi
    	
    	if is_valid_path "$user_input"; then
        	KERNEL_DIR="${user_input}"
        	break  
    	else
        	printf "## The directory you inputted is invalid. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_PATH_KERNEL: ${KERNEL_DIR}" >> "${CONFIG_PATH}"
	printf "# The current duo directory you specify is:${KERNEL_DIR} \n\n"
	DPT_PATH_KERNEL=${KERNEL_DIR}
fi

while IFS= read -r line; do
    if [[ "$line" == "DPT_PATH_OUTPUT: "* ]]; then
		OUTPUT_PATH="${line#DPT_PATH_OUTPUT: }"
		break
    fi
done < "${CONFIG_PATH}"

if [ ! -z "${OUTPUT_PATH}" ]; then
	if [[ "${OUTPUT_PATH}" == $(realpath "${DPT_SCRIPT_PATH}/../output") ]] && [ ! -d $OUTPUT_PATH ]; then
		mkdir -p $OUTPUT_PATH
		if [ $? -ne 0 ]; then
			echo "Error: Failed to create directory '$OUTPUT_PATH'."
			return 1
		fi
	fi

	if ! is_valid_path "${OUTPUT_PATH}"; then
		echo "## Please check the.config file or try deleting the.config file and try again. The configuration information is incorrect."
		return 1
	else 
		DPT_PATH_OUTPUT=${OUTPUT_PATH}
		echo "# The current output directory you specify is: ${DPT_PATH_OUTPUT}"
	fi
else 
	printf "## No output directory information found. Now start reconfiguring \n"
	printf "# Please specify the output directory. \n\n"
	
	while true; do
    	echo -n "Please input the output directory(You can just input enter, the output directory default is '.../duo-pkgtool/output'): "
    	read user_input
    	if [ -z "$user_input" ]; then
    		OUT_PATH=$(realpath "${DPT_SCRIPT_PATH}/../output")
			break 
    	fi
    	
    	if is_valid_path "$user_input"; then
        	OUT_PATH="${user_input}"
        	break  
    	else
        	printf "## The directory you inputted does not exist. Please try again! \n\n"
    	fi
	done
	
	echo "DPT_PATH_OUTPUT: ${OUT_PATH}" >> "${CONFIG_PATH}"
	printf "# The current output directory you specify is:${OUT_PATH} \n\n"
	DPT_PATH_OUTPUT=${OUT_PATH}
fi

export DPT_BOARD_TYPE
export DPT_PATH_KERNEL=$(realpath "${DPT_PATH_KERNEL}")
export DPT_PATH_OUTPUT=$(realpath "${DPT_PATH_OUTPUT}")
export DPT_PATH=$(realpath "${DPT_SCRIPT_PATH}/..")

if [ -d "${DPT_PATH}" ]; then
    if [ ! -d "${DPT_PATH}/prebuilt" ] || [ ! -d "${DPT_PATH}/script" ]; then
    	echo "## The duo-pkgtool directory is not complete and cannot be used properly. Please use a valid duo-pkgtool or download duo-pkgtool again."
    	return 1
	else
    	echo "# duo-pkgtool check is complete, you can try using duo-pkgtool. "
	fi
else 
    echo "## The path to duo-pkgtool does not exist. Please try using a valid duo-pkgtool. "
    return 1
fi

source "${DPT_SCRIPT_PATH}/build.sh" 

