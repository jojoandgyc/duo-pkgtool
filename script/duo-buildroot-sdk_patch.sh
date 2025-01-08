#!/bin/bash
# Parameter 1  duo-buildroot-sdk path  (optional)
# Parameter 2  board name  (optional)
my_duo_buildroot_sdk_path=$1             
my_duo_board=$2                
my_chip="my_chip"    
my_chip_series="my_chip_series"    

duo_compile_switch=0
duo256m_compile_switch=0
duos_compile_switch=0


# Patch file
fip_v2_patch="./patch/fip_v2_change.patch"
milkv_setup_patch="./patch/milkv_setup_change.patch"
boards_cv180x_patch="./patch/cv180x_change.patch"
boards_cv181x_patch="./patch/cv181x_change.patch"

target_fip_v2_file="${my_duo_buildroot_sdk_path}/build/scripts/fip_v2.mk"
target_milkv_setup_file="${my_duo_buildroot_sdk_path}/build/milkvsetup.sh"
boards_cv180x_dir="${my_duo_buildroot_sdk_path}/build/boards/cv180x/"
boards_cv181x_dir="${my_duo_buildroot_sdk_path}/build/boards/cv181x/"


#  Check path exist
if [ -z "$1" ] ; then

    if  [ -f "../duo-buildroot-sdk/" ] ; then
        echo "already exists duo-buildroot-sdk folder"
        my_duo_buildroot_sdk_path="../duo-buildroot-sdk/"
        
    elif [ -d "../duo-buildroot-sdk/" ]; then
        my_duo_buildroot_sdk_path="../duo-buildroot-sdk/"
        echo "Please provide duo_buildroot_sdk project path"
        pushd .. || exit
        git clone https://github.com/milkv-duo/duo-buildroot-sdk.git
        if [ $? -ne 0 ]; then
            echo "Failed to clone duo-buildroot-sdk"
            echo "Or you can pass in  duo-buildroot-sdk absolute path"
            exit 1
        fi
        popd || exit
        my_duo_buildroot_sdk_path="../duo-buildroot-sdk/"
    fi
    
fi

#  Use file patch
diff -q "${target_fip_v2_file}" "${target_fip_v2_file}.orig"
if [ $? -eq 0 ]; then
    echo "fip_v2_patch applied successfully"
else
    echo "Files different add patch"
    patch -p1 "${target_fip_v2_file}" "${fip_v2_patch}"
fi

diff -q "${target_milkv_setup_file}" "${target_milkv_setup_file}.orig"
if [ $? -eq 0 ]; then
    echo "milkv_setup_patch applied successfully"
else
    echo "Files different add patch"
    patch -p1 "${target_milkv_setup_file}" "${milkv_setup_patch}"
fi

# Use dir patch 
diff -q "${boards_cv180x_dir}/cv1800b_milkv_duo_sd/u-boot/cvi_board_init.c" "${boards_cv180x_dir}/cv1800b_milkv_duo_sd/u-boot/cvi_board_init.c.orig"
if [ $? -eq 0 ]; then
    echo "fip_v2_patch applied successfully"
else
    echo "Files different add patch"
    patch -p1 "${boards_cv180x_dir}" "${boards_cv180x_patch}"
fi

diff -q "${boards_cv181x_dir}/cv1813h_milkv_duos_sd/u-boo/cvi_board_init.c" "${boards_cv181x_dir}/cv1813h_milkv_duos_sd/u-boo/cvi_board_init.c.orig"
if [ $? -eq 0 ]; then
    echo "fip_v2_patch applied successfully"
else
    echo "Files different add patch"
    patch -p1 "${boards_cv181x_dir}" "${boards_cv181x_patch}"
fi

#  copy duo-buildroot-sdk files
if [[ -z "$my_duo_board" ]]; then
    echo "Compile all boards"
    
fi

# set my_chip
function set_chip() {
    if [[ "$my_duo_board" == "duo" ]]; then
        my_chip="cv1800b"
        my_chip_series="cv181x"
    elif [[ "$my_duo_board" == "duo256" ]]; then
        my_chip="cv1812cp"
        my_chip_series="cv181x"
    elif [[ "$my_duo_board" == "duos" ]]; then
        my_chip="cv1813h"
        my_chip_series="cv181x"
    else
        echo " default duo256 board "
        my_chip="cv1812cp"
        my_chip_series="cv181x"
    fi
    echo "my_chip is < $my_chip > series"
}

# copy files
function copy_file() {
    my_fsbl_dir="../prebuilt/milkv-${my_duo_board}/fsbl/"
    my_opensbi_dir="../prebuilt/milkv-${my_duo_board}/opensbi/"
    my_uboot_dir="../prebuilt/milkv-${my_duo_board}/uboot/"
    my_dtb_dir="../prebuilt/milkv-${my_duo_board}/dtb/"

    # Create target directory  
    mkdir -p ${my_fsbl_dir}
    mkdir -p ${my_opensbi_dir}
    mkdir -p ${my_uboot_dir}
    mkdir -p ${my_dtb_dir}

    # Copy files
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/build/${my_chip}_milkv_${my_duo_board}_sd/chip_conf.bin"  "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/build/${my_chip}_milkv_${my_duo_board}_sd/blmacros.env" "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/build/${my_chip}_milkv_${my_duo_board}_sd/bl2.bin" "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/test/empty.bin" "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/test/${my_chip_series}/ddr_param.bin" "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/fsbl/plat/${my_chip_series}/fiptool.py" "$my_fsbl_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/opensbi/build/platform/generic/firmware/fw_dynamic.bin" "$my_opensbi_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/u-boot-2021.10/build/${my_chip}_milkv_${my_duo_board}_sd/u-boot-raw.bin" "$my_uboot_dir"
    cp -v  "${my_duo_buildroot_sdk_path}/linux_5.10/build/${my_chip}_milkv_${my_duo_board}_sd/arch/riscv/boot/dts/cvitek/${my_chip}_milkv_${my_duo_board}_*.dtb" "$my_dtb_dir"
    echo "Finish"
}


# select compile board
if  my_duo_board -eq "duo" ; then
    duo_compile_switch=1
elif  my_duo_board -eq "duo256m" ; then
    duo256m_compile_switch=1
elif  my_duo_board -eq "duos" ; then
    duos_compile_switch=1
else
    echo "Compile all boards"
    duo_compile_switch=1
    duo256m_compile_switch=1
    duos_compile_switch=1
fi


## duo compile
if $duo_compile_switch -eq 1; then
    echo "duo_compile_switch is on"
    pushd ${my_duo_buildroot_sdk_path} || exit
    source device/milkv-duo-sd/boardconfig.sh
    source build/milkvsetup.sh
    defconfig cv1800b_milkv_duo_sd
    clean_all
    build_all
    popd || exit
    my_duo_board="duo"
    set_chip
    copy_file
fi

## duo256m compile
if $duo256m_compile_switch -eq 1; then
    echo "duo_compile_switch is on"
    pushd ${my_duo_buildroot_sdk_path} || exit
    source device/milkv-duo-sd/boardconfig.sh
    source build/milkvsetup.sh
    defconfig cv1800b_milkv_duo_sd
    clean_all
    build_all
    popd || exit
    my_duo_board="duo256m"
    set_chip
    copy_file
fi

## duos compile
if $duos_compile_switch -eq 1; then
    echo "duo_compile_switch is on"
    pushd ${my_duo_buildroot_sdk_path} || exit
    source device/milkv-duo-sd/boardconfig.sh
    source build/milkvsetup.sh
    defconfig cv1800b_milkv_duo_sd
    clean_all
    build_all
    popd || exit
    my_duo_board="duos"
    set_chip
    copy_file
fi

echo "Finish"
