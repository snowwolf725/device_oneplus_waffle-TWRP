#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oneplus/waffle

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name (automatically taken from this file's suffix)
PRODUCT_RELEASE_NAME := $(lastword $(subst /, ,$(lastword $(subst _, ,$(firstword $(subst ., ,$(MAKEFILE_LIST)))))))

# Custom vendor used in build tree (automatically taken from this file's prefix)
CUSTOM_VENDOR := $(lastword $(subst /, ,$(firstword $(subst _, ,$(firstword $(MAKEFILE_LIST))))))

## Device identifier
PRODUCT_DEVICE := $(PRODUCT_RELEASE_NAME)
PRODUCT_NAME := $(CUSTOM_VENDOR)_$(PRODUCT_DEVICE)
PRODUCT_BRAND := $(CUSTOM_VENDOR)
PRODUCT_SYSTEM_DEVICE := OP595DL1
PRODUCT_MODEL := CPH2573
PRODUCT_MANUFACTURER := $(PRODUCT_BRAND)

# Assert
TARGET_OTA_ASSERT_DEVICE := $(PRODUCT_RELEASE_NAME)

# Theme
TW_STATUS_ICONS_ALIGN := center
