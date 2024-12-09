#!/bin/bash
set -e

PROJECT_PATH=$1
IMAGE_NAME=$2
BOARD_TMP=$3
OUT_PATH=$4

if [[ -z "$PROJECT_PATH" ]] || [[ -z "$IMAGE_NAME" ]] || [[ -z "$BOARD_TMP" ]] || [[ -z "$OUT_PATH" ]]; then
	echo "Usage: $0 <PROJECT_PATH> <IMAGE_NAME> <<BOARD_TYPE>> <OUT_PATH>"
	exit 1
fi

CURRENT_PATH=$(pwd)
echo ${OUT_PATH}

PREBUILT_PATH="${CURRENT_PATH}/../prebuilt"
PREBUILT_PATH=$(realpath "${PREBUILT_PATH}")
echo "prebuilt_dir: ${PREBUILT_PATH}"

. function.sh

get_board_type ${BOARD_TMP}

BLCP_2ND_PATH=${PROJECT_PATH}/${IMAGE_NAME}
echo "BLCP_2ND_PATH: ${BLCP_2ND_PATH}"

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

if [ -e "${BLCP_2ND_PATH}" ] && [ -f "${BLCP_2ND_PATH}" ]; then
	do_combine
	if [ $? -ne 0 ]; then
		echo "Please check the prebuilt of duo-pkgtool, and try again!"
	fi
else 
	echo "Please check the output of small core, and try again!"
fi

