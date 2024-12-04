#/bin/sh
set -e

PROJECT_PATH=$1
IMAGE_NAME=$2

if [ -z "$PROJECT_PATH" ] || [ -z "$IMAGE_NAME" ]; then
	echo "Usage: $0 <PROJECT_DIR> <IMAGE_NAME>"
	exit 1
fi

CURRENT_PATH=$(pwd)
OUT_PATH="${CURRENT_PATH}/../output"
CVITEK_PATH="${PROJECT_PATH}/.."
echo ${OUT_PATH}

. function.sh

get_board_type

echo "start compress the Big one of kernels..."

PREBUILT_PATH="${CURRENT_PATH}/../prebuilt/${BOARD_TYPE}"

lzma -c -9 -f -k ${PROJECT_PATH}/${IMAGE_NAME} > ${PREBUILT_PATH}/dtb/${BOARD_TYPE}/Image.lzma

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

pushd ${CVITEK_PATH}
./mkimage -f ${PREBUILT_PATH}/dtb/${BOARD_TYPE}/multi.its -r ${OUT_PATH}/${BOARD_TYPE}/boot.${STORAGE_TYPE}
popd

if [ -f "${PREBUILT_PATH}/dtb/${BOARD_TYPE}/Image.lzma" ]; then
	rm -rf "${PREBUILT_PATH}/dtb/${BOARD_TYPE}/Image.lzma"
fi
