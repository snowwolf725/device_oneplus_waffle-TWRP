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
BUILD_BROKEN_NINJA_USES_ENV_VARS    += SDCLANG_AE_CONFIG SDCLANG_CONFIG SDCLANG_SA_ENABLE
#BUILD_BROKEN_PLUGIN_VALIDATION      := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

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
AB_OTA_PARTITIONS += boot init_boot vendor_boot recovery dtbo \
    abl aop aop_config bluetooth cpucp cpucp_dtb devcfg dsp \
    engineering_cdt featenabler hyp imagefv keymaster modem \
    oplusstanvbk qupfw shrm splash tz uefi uefisecapp \
    xbl xbl_config xbl_ramdump \
    vbmeta vbmeta_system vbmeta_vendor \
    system system_ext system_dlkm product vendor vendor_dlkm \
    my_bigball my_carrier my_company my_engineering my_heytap \
    my_manifest my_preload my_product my_region my_stock odm 

# Crypto
BOARD_USES_METADATA_PARTITION   := true
TW_INCLUDE_CRYPTO               := true

# Debug
#TWRP_EVENT_LOGGING := true
TARGET_USES_LOGD                := true
TWRP_INCLUDE_LOGCAT             := true
TARGET_RECOVERY_DEVICE_MODULES  += debuggerd
TARGET_RECOVERY_DEVICE_MODULES  += strace
#TARGET_RECOVERY_DEVICE_MODULES += twrpdec
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/strace
#RECOVERY_BINARY_SOURCE_FILES   += $(TARGET_RECOVERY_ROOT_OUT)/sbin/twrpdec

# File systems
TARGET_USERIMAGES_USE_F2FS := true
TW_USE_DMCTL               := true

# Kernel
#BOARD_KERNEL_PAGESIZE       := 4096
TARGET_RECOVERY_KERNEL_MODULES := false
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_KERNEL_IMAGE_NAME := kernel
BOARD_RAMDISK_USE_LZ4 := true
#TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/$(BOARD_KERNEL_IMAGE_NAME)

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED  := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE      := 104857600

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE :=17179869184
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 17175674880
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm odm

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE         := ext4
TARGET_COPY_OUT_ODM                     := odm
TARGET_COPY_OUT_VENDOR                  := vendor
TARGET_COPY_OUT_VENDOR_DLKM             := vendor_dlkm
BOARD_USES_VENDOR_DLKMIMAGE             := true
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

# Platform
# Define hardware platform
PRODUCT_PLATFORM             := pineapple
QCOM_BOARD_PLATFORMS         += $(PRODUCT_PLATFORM)
TARGET_BOARD_PLATFORM        := $(PRODUCT_PLATFORM)
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_BOARD_PLATFORM)

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

#BOARD_RECOVERY_IMAGE_PREPARE += \
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
RECOVERY_SDCARD_ON_DATA      := true
TARGET_USES_MKE2FS           := true
#TW_ENABLE_FS_COMPRESSION    := true
#TW_INCLUDE_FUSE_EXFAT       := true
#TW_INCLUDE_FUSE_NTFS        := true
#TW_INCLUDE_NTFS_3G          := true
TW_NO_EXFAT_FUSE             := true

# Version
PLATFORM_VERSION                := 99.87.36
PLATFORM_VERSION_LAST_STABLE    := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH         := 2099-12-31
VENDOR_SECURITY_PATCH           := $(PLATFORM_SECURITY_PATCH)
TW_DEVICE_VERSION               := OnePlus 12

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Bootloader
TARGET_NO_BOOTLOADER := false
TARGET_USES_UEFI := true
TARGET_USES_REMOTEPROC := true

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_KERNEL-GKI_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_USERDATAIMAGE_PARTITION_SIZE := 233871900672
BOARD_PERSISTIMAGE_PARTITION_SIZE := 67108864
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_METADATAIMAGE_PARTITION_SIZE := 16777216
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)

BUILD_BROKEN_USES_BUILD_HOST_SHARED_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_STATIC_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_EXECUTABLE := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# Recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hidl.allocator@1.0 \
    android.hidl.memory@1.0 \
    android.hidl.memory.token@1.0 \
    libdmabufheap \
    libhidlmemory \
    libion \
    libnetutils \
    vendor.display.config@1.0 \
    vendor.display.config@2.0 \
    libdebuggerd_client
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Extras
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

TW_INCLUDE_RESETPROP := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_OVERRIDE_SYSTEM_PROPS := \
    "ro.build.product;ro.build.fingerprint=ro.vendor.build.fingerprint;ro.build.version.incremental"
TW_OVERRIDE_PROPS_ADDITIONAL_PARTITIONS := vendor
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.allocator@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hidl.memory.token@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdmabufheap.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libhidlmemory.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libnetutils.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libdebuggerd_client.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config
    
# Build partition tools (lptools,lpdump)
TW_ENABLE_ALL_PARTITION_TOOLS := true

# Encryption
BOARD_USES_QCOM_FBE_DECRYPTION := true

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

