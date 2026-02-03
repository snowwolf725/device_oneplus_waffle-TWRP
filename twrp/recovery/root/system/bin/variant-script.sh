#!/system/bin/sh
# This script is needed to automatically set device props.

variant=$(getprop ro.boot.prjname)

echo "$variant"

case $variant in
    "22825")
        #China
        resetprop ro.product.device "OP5929L1"
        resetprop ro.product.vendor.device "OP5929L1"
        resetprop ro.product.odm.device "OP5929L1"
        resetprop ro.product.product.device "OP5929L1"
        resetprop ro.product.system_ext.device "OP5929L1"
        resetprop ro.product.product.model "ossi"
        resetprop ro.product.model "ossi"
        resetprop ro.product.system.model "ossi"
        resetprop ro.product.system_ext.model "ossi"
        resetprop ro.product.vendor.model "PJD110"
        resetprop ro.product.odm.model "PJD110"
        resetprop ro.boot.hardware.revision "CN"
        ;;
    *)
        resetprop ro.product.device "OP595DL1"
        resetprop ro.product.vendor.device "OP595DL1"
        resetprop ro.product.odm.device "OP595DL1"
        resetprop ro.product.product.device "OP595DL1"
        resetprop ro.product.system_ext.device "OP595DL1"
        resetprop ro.product.product.model "CPH2573"
        resetprop ro.product.model "CPH2573"
        resetprop ro.product.system.model "CPH2573"
        resetprop ro.product.system_ext.model "CPH2573"
        resetprop ro.product.vendor.model "CPH2573"
        resetprop ro.product.odm.model "CPH2573"
        resetprop ro.boot.hardware.revision "CN"
        ;;
esac
