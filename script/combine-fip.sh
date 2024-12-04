#!/bin/bash
set -e

PROJECT_PATH=$1
IMAGE_NAME=$2

if [ -z "$PROJECT_PATH" ] || [ -z "$IMAGE_NAME" ]; then
	echo "Usage: $0 <PROJECT_DIR> <IMAGE_NAME>"
	exit 1
fi

CURRENT_PATH=$(pwd)
export OUT_PATH="${CURRENT_PATH}/../output"
CVITEK_PATH="${PROJECT_PATH}/.."
echo ${OUT_PATH}

. function.sh

get_board_type
echo "board_type: ${BOARD_TYPE}"

export PREBUILT_PATH="${CURRENT_PATH}/../prebuilt/${BOARD_TYPE}"
echo "prebuilt_dir: ${PREBUILT_PATH}"

export BLCP_2ND_PATH=${PROJECT_PATH}/${IMAGE_NAME}
echo "BLCP_2ND_PATH: ${BLCP_2ND_PATH}"

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

if [ -e "${BLCP_2ND_PATH}" ] && [ -f "${BLCP_2ND_PATH}" ]; then
	do_combine
	if [ $? -ne 0 ]; then
		echo "Please check the prebuilt of duo, and try again!"
	fi
else 
	echo "Please check the output of small core, and try again!"
fi

