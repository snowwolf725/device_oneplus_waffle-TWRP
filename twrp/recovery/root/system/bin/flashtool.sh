#!/sbin/sh
##setup variable 
export OUTFD=$4;

#package=$(dirname $ZIPFILE)/update.zip
package=$1

show_progress() {
  echo "progress $1 $2" >> /proc/self/fd/$OUTFD; 
}

ui_print() {
  until [ ! "$1" ]; do
    echo "ui_print $1
      ui_print" >> /proc/self/fd/$OUTFD;
    shift;
  done;
}

abort(){
  until [ ! "$1" ]; do
    echo "ui_print $1
      ui_print" >> /proc/self/fd/$OUTFD;
    shift;
  done;
  exit 1
}

grep_cmdline() {
  local REGEX="s/^$1=//p"
  { echo $(cat /proc/cmdline)$(sed -e 's/[^"]//g' -e 's/""//g' /proc/cmdline) | xargs -n 1; \
    sed -e 's/ = /=/g' -e 's/, /,/g' -e 's/"//g' /proc/bootconfig; \
  } 2>/dev/null | sed -n "$REGEX"
}

get_slot(){
   # Check A/B slot
  SLOT=`grep_cmdline androidboot.slot_suffix`
  if [ -z $SLOT ]; then
    SLOT=`grep_cmdline androidboot.slot`
    [ -z $SLOT ] || SLOT=_${SLOT}
  fi
  [ "$SLOT" = "normal" ] && unset SLOT
  [ -z $SLOT ] || 
  echo $SLOT
}

choose() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while true; do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

check() {
    local device_img="$1"
    local new_img="$2"
    
    device_arb=$(arbscan "$device_img" | grep ARB)
    new_arb=$(arbscan "$new_img" | grep ARB)
    
    if [ "$device_arb" == "$new_arb" ]; then
        ui_print "Device $device_arb"
        ui_print "New    $new_arb"
        ui_print "ARB Index match"
    else
        ui_print "Device $device_arb"
        ui_print "New    $new_arb"
        ui_print "ARB Index not match"
        ui_print ""
        ui_print "Please select an option"
        ui_print "Volume Up) Install OTA without updating xbl and related partitions"
        ui_print "Volume Down) Force installation"
        
        if choose; then
          ui_print "press up"
          rm $tmpdir/payload/abl.img
          rm $tmpdir/payload/xbl.img
          rm $tmpdir/payload/xbl_config.img
          rm $tmpdir/payload/xbl_ramdump.img
          mv $tmpdir/payload/xbl_config.old $tmpdir/payload/xbl_config.img
          cat /dev/block/by-name/xbl_ramdump$slot > $tmpdir/payload/xbl_ramdump.img
          cat /dev/block/by-name/xbl$slot > $tmpdir/payload/xbl.img
          cat /dev/block/by-name/abl$slot > $tmpdir/payload/abl.img
        else
          ui_print "press down"
        fi
        
    fi
}

##make super partition
mksuper(){
  Imgdir=$1
  outputimg=$2
  superpa="--metadata-size $metadatasize --super-name super --virtual-ab -block-size=4096 "
  for imag in $(basename -a "$Imgdir"/*.img);do
    image=$(echo "$imag" | sed 's/_a.img//g' | sed 's/_b.img//g'| sed 's/.img//g')
    img_size=$(wc -c <$Imgdir/$image.img)
    superpa+="--partition "$image"_a:readonly:$img_size:${super_group}_a --image "$image"_a=$Imgdir/$image.img "
  done

  superpa+="--device super:$supersize "
  superpa+="--metadata-slots 3 "
  superpa+="--group ${super_group}_a:$groupsize "
  superpa+="--group cow:0 "
  superpa+="-F --output $outputimg"
  lpmake $superpa
}
##flash image
flashImg(){
  Imgdir=$1
  for file in `ls $Imgdir`
    do
      name=$(basename $file .img)
      cat $Imgdir/$file > /dev/block/by-name/${name}_a
      cat $Imgdir/$file > /dev/block/by-name/${name}_a
    done
}


# super partition variable 
supersize=$(lpdump /dev/block/by-name/super | grep 'Size:' | awk '{print $2}')
groupsize=$(lpdump /dev/block/by-name/super | grep 'Maximum size:' | awk 'NR==2' | awk '{print $3}')
metadatasize=$(lpdump /dev/block/by-name/super |grep 'Metadata max size: ' |  awk '{print $4}')
super_group=qti_dynamic_partitions
tmpdir=/sdcard/tmp/tmp

ui_print "This package is an official package tool for TWRP assisted browsing"
ui_print "This tool cannot verify whether the scanned package is the corresponding model package"
ui_print "The author is not responsible for any situations caused by the use of this tool"
ui_print ""
slot=$(get_slot)
ui_print "Unpacking OTA zip.... "
ui_print ""
ui_print "Current slot: $slot"
ui_print " "
ui_print "=================================="
ui_print " " 
ui_print ""
ui_print "          FlashTool V3.9          "
ui_print " " 
ui_print ""
ui_print "=================================="
ui_print " "
ui_print "Unpacking OTA zip.... "

show_progress 0.1 10;

rm -rf $tmpdir
mkdir -p $tmpdir
## unzip ota
ui_print "Extracting OTA file"
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`

unzip -o "$package" "payload.bin" -d $tmpdir

endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
let sumTime=$endTime_s-$startTime_s
ui_print "Time spent on extracting OTA file : $startTime ---> $endTime  Total:$sumTime seconds"

show_progress 0.4 100;

## unpack payload.bin
ui_print "Extracting payload.bin"
 [ ! -s $tmpdir/payload.bin ] && abort "$tmpdir/payload.bin not exist."
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
[ ! -d $tmpdir ] && mkdir $tmpdir
rm -rf $tmpdir/payload
mkdir -p $tmpdir/payload
payload -o $tmpdir/payload $tmpdir/payload.bin 1>/dev/null || abort "File corrupted, please redownload."
## timer
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
let sumTime=$endTime_s-$startTime_s
ui_print "Time spent on extracting payload.bin : $startTime ---> $endTime  Total:$sumTime seconds"
rm -rf $tmpdir/payload.bin

show_progress 0.1 10;

##Check version 
unzip -o "$package" "payload_properties.txt" -d $tmpdir/
if grep -q "PJD110" "$tmpdir/payload_properties.txt"; then
    version="CN"
elif grep -q "CPH2573" "$tmpdir/payload_properties.txt"; then
    version="IN"
elif grep -q "CPH2581" "$tmpdir/payload_properties.txt"; then
    version="EU"
elif grep -q "CPH2583" "$tmpdir/payload_properties.txt"; then
    version="NA"
else
    ui_print "Unknown Version"
    version="UN"
fi

##pickup missing partition 
#unzip -j -o "$ZIPFILE" "bin/$version/my_company.img" -d $tmpdir/payload/
if [ ! -s $tmpdir/payload/my_company.img ] 
then
  ui_print "Pick-up missed partition (my_company)"
  ##pickup image from device 
  cp /system/payload/my_company.img $tmpdir/payload/my_company.img
  [ ! -s $tmpdir/payload/my_company.img ] && abort "my_company.img is not found"
fi

#unzip -j -o "$ZIPFILE" "bin/$version/my_preload.img" -d $tmpdir/payload/
if [ ! -s $tmpdir/payload/my_preload.img ] 
then
  ui_print "Pick-up missed partition (my_preload)"
  ##pickup image from device 
  cp /system/payload/my_preload.img $tmpdir/payload/my_preload.img
  [ ! -s $tmpdir/payload/my_preload.img ] && abort "my_preload.img not found"
fi

# delete persist, modemst1, modemst2, ocdt
if [ -s $tmpdir/payload/modemst1.img ] 
then
   rm $tmpdir/payload/modemst1.img
fi
if [ -s $tmpdir/payload/modemst2.img ] 
then
   rm $tmpdir/payload/modemst2.img
fi
if [ -s $tmpdir/payload/ocdt.img ] 
then
   rm $tmpdir/payload/ocdt.img
fi
if [ -s $tmpdir/payload/persist.img ] 
then
   rm $tmpdir/payload/persist.img
fi
if [ -s $tmpdir/payload/recovery.img ] 
then
   rm $tmpdir/payload/recovery.img
fi

##check ARB
cat /dev/block/by-name/xbl_config$slot > $tmpdir/payload/xbl_config.old
check "$tmpdir/payload/xbl_config.old" "$tmpdir/payload/xbl_config.img"

show_progress 0.1 10;

##create super
ui_print "Creating Super.img"
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
rm -rf $tmpdir/super
mkdir  $tmpdir/super
for img in my_bigball.img my_carrier.img my_company.img my_engineering.img my_heytap.img my_manifest.img my_preload.img my_product.img my_region.img my_stock.img odm.img product.img system.img system_dlkm.img system_ext.img vendor.img vendor_dlkm.img
do
  mv -f $tmpdir/payload/$img  $tmpdir/super
done
mksuper $tmpdir/super $tmpdir/super.img
rm -rf $tmpdir/super
##timer
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
let sumTime=$endTime_s-$startTime_s
ui_print "Time spent on  creating Super.img: $startTime ---> $endTime  Total:$sumTime seconds"
[ ! -s $tmpdir/super.img ] && abort "$tmpdir/super.img not exist!"

show_progress 0.1 5;

##flash image
ui_print "Flashing images"
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
flashImg $tmpdir/payload
##timer
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
let sumTime=$endTime_s-$startTime_s
ui_print "Time spent on flashing images: $startTime ---> $endTime  Total:$sumTime seconds"

show_progress 0.1 10;

ui_print "Flashing Super image"
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
cat $tmpdir/super.img > /dev/block/by-name/super
##timer
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
let sumTime=$endTime_s-$startTime_s
ui_print "Time spent on flashing Super image: $startTime ---> $endTime  Total:$sumTime seconds"

## set active slot
ui_print "Modify active slot"
bootctl set-active-boot-slot 0
resetprop ro.boot.slot_suffix _a
## disable avb
#ui_print "Disable avb"
#avbctl disable-verity --force
#avbctl disable-verification --force

##clean
ui_print "Cleaning tmp folder"
rm -rf /tmp
rm -rf  $tmpdir

show_progress 0.1 10;
