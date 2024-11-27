#!/bin/bash

KERNEL_PATH=$1
CORE_TYPE=$2

if [ "${CORE_TYPE}" == "bcore" ]; then
	BKERNEL_PATH=${KERNEL_PATH}
	if grep -q "^export RT_DUO_BKERNEL=" ~/.bashrc; then
		CURRENT_VALUE=$(grep "^export RT_DUO_BKERNEL=" ~/.bashrc | sed "s/^export RT_DUO_BKERNEL=//")
		if [ "${CURRENT_VALUE}" != "${BKERNEL_PATH}" ]; then
			sed -i "s#^export RT_DUO_BKERNEL=.*#export RT_DUO_BKERNEL=\\\"${BKERNEL_PATH}\\\"#" ~/.bashrc
		fi	
	else
		echo "export RT_DUO_BKERNEL=\"${BKERNEL_PATH}\"" >> ~/.bashrc
	fi
elif [ "${CORE_TYPE}" == "score" ]; then
	SKERNEL_PATH=${KERNEL_PATH}
	if grep -q "^export RT_DUO_SKERNEL=" ~/.bashrc; then
		CURRENT_VALUE=$(grep "^export RT_DUO_SKERNEL=" ~/.bashrc | sed "s/^export RT_DUO_SKERNEL=//")
		if [ "${CURRENT_VALUE}" != "${SKERNEL_PATH}" ]; then
			sed -i "s#^export RT_DUO_SKERNEL=.*#export RT_DUO_SKERNEL=\\\"${SKERNEL_PATH}\\\"#" ~/.bashrc
		fi	
	else
		echo "export RT_DUO_SKERNEL=\"${SKERNEL_PATH}\"" >> ~/.bashrc
	fi
fi 
