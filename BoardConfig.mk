#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES                      := true
BUILD_BROKEN_DUP_RULES                          := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES    := true

BUILD_BROKEN_NINJA_USES_ENV_VARS    += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION      := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# Architecture
TARGET_ARCH                 := arm64
TARGET_ARCH_VARIANT         := armv8-a-branchprot
TARGET_CPU_ABI              := arm64-v8a
TARGET_CPU_VARIANT          := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75

# A/B
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm

# Bootloader
PRODUCT_PLATFORM                := pineapple
TARGET_BOOTLOADER_BOARD_NAME    := pineapple

# Crypto
BOARD_USES_METADATA_PARTITION   := true
TW_INCLUDE_CRYPTO               := true

# Debug
TARGET_USES_LOGD                := true
TWRP_INCLUDE_LOGCAT             := true
TARGET_RECOVERY_DEVICE_MODULES  += debuggerd
TARGET_RECOVERY_DEVICE_MODULES  += strace
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/strace

# File systems
TARGET_USERIMAGES_USE_F2FS := true
TW_USE_DMCTL               := true

# Kernel
#BOARD_KERNEL_PAGESIZE       := 4096

BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_KERNEL_IMAGE_NAME := kernel
BOARD_RAMDISK_USE_LZ4 := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/$(BOARD_KERNEL_IMAGE_NAME)

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED  := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE      := 104857600

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE :=17179869184
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 17175674880
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM             := odm
TARGET_COPY_OUT_VENDOR          := vendor

# Platform
TARGET_BOARD_PLATFORM   := pineapple
QCOM_BOARD_PLATFORMS    += pineapple

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE    := true
TARGET_RECOVERY_PIXEL_FORMAT                := RGBX_8888
TW_INCLUDE_FASTBOOTD                        := true
TW_HAS_EDL_MODE                             := true

# Tool
TW_ENABLE_ALL_PARTITION_TOOLS := true
TW_INCLUDE_7ZA                := true
TW_INCLUDE_REPACKTOOLS        := true
TW_INCLUDE_RESETPROP          := true
TW_USE_TOOLBOX                := true
TW_INCLUDE_ZSTD               := true
TW_USE_DMCTL                  := true

i#BOARD_RECOVERY_IMAGE_PREPARE += \
    rm -f $(PRODUCT_OUT)/recovery/root/system/bin/unzip && \
    cp $(TARGET_DEVICE_DIR)/recovery/root/system/bin/unzip7aGaGaGaGaGaGza $(PRODUCT_OUT)/recovery/root/system/bin/unzip && \
    chmod 0755 $(PRODUCT_OUT)/recovery/root/system/bin/unzip

# TWRP display
TW_BRIGHTNESS_PATH            := "/sys/devices/platform/soc/ae00000.qcom,mdss_mdp/backlight/panel0-backlight/brightness"
TW_DEFAULT_BRIGHTNESS         := 1000
TW_FRAMERATE                  := 120
TW_MAX_BRIGHTNESS             := 1500
#TW_SCREEN_BLANK_ON_BOOT.     := true
TW_INPUT_BLACKLIST.           := "hbtp_vm"
TW_THEME                      := landscape_hdpi #portrait_hdpi
#TW_ROTATION                  := 0 
#RECOVERY_TOUCHSCREEN_SWAP_XY := true    
#RECOVERY_TOUCHSCREEN_FLIP_Y  := true 

# TWRP file system
RECOVERY_SDCARD_ON_DATA     := true
TARGET_USES_MKE2FS          := true
TW_ENABLE_FS_COMPRESSION    := true
TW_INCLUDE_FUSE_EXFAT       := true
TW_INCLUDE_FUSE_NTFS        := true
TW_INCLUDE_NTFS_3G          := true
TW_NO_EXFAT_FUSE            := true

# Version
PLATFORM_VERSION                := 99.87.36
PLATFORM_VERSION_LAST_STABLE    := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH         := 2099-12-31
VENDOR_SECURITY_PATCH           := $(PLATFORM_SECURITY_PATCH)
TW_DEVICE_VERSION               := OnePlus 12

# Verified Boot
BOARD_AVB_ENABLE := true


# Other TWRP Configurations
TARGET_RECOVERY_QCOM_RTC_FIX            := true
TW_CUSTOM_CPU_TEMP_PATH                 := "/sys/devices/virtual/thermal/thermal_zone45/temp"
TW_EXCLUDE_APEX                         := true
TW_EXCLUDE_DEFAULT_USB_INIT             := true
TW_EXTRA_LANGUAGES                      := true
TW_LOAD_VENDOR_MODULES                  := "adsp_loader_dlkm.ko rproc_qcom_common.ko q6_dlkm.ko qcom_q6v5.ko qcom_q6v5_pas.ko qcom_esoc.ko qcom_sysmon.ko qcom-hv-haptics.ko goodix_ts.ko haptic_feedback.ko oplus_chg_v2.ko oplus_bsp_tp_custom.ko oplus_bsp_tp_common.ko oplus_bsp_tp_notify.ko oplus_bsp_tp_tcm_oncell.ko oplus_bsp_tp_tcm_S3910.ko oplus_bsp_tp_syna_comnon.ko oplus_bsp_synaptics_tcm2.ko oplus_bsp_tp_ilitek7807s.ko oplus_bsp_tp_td4377_noflash.ko oplus_bsp_tp_gt9966.ko oplus_bsp_tp_gt9916.ko oplus_bsp_kshrink_slabd.ko oplus_bsp_tp_nt36528_noflash.ko qbridge.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI      := true
TW_NO_SCREEN_BLANK                      := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID  := true

