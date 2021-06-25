#!/bin/bash

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo '`getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=ht:s:b:p
LONGOPTS=help,type:,size:,background:,preview

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

h=n t="png" s=64 b=2 p=n

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -h|--help)
            h=y
            shift
            ;;
        -s|--size)
            s=$2
            shift 2
            ;;
        -b|--background)
            b=$2
            shift 2
            ;;
        -t|--type)
            t=$2
            shift 2
            ;;
        -p|--preview)
            p=y
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ $h == y ]; then
    echo ""
    echo "This script will generate assortment of icons."
    echo "Usage:"
    echo "  bash ./3DPrinting_Icons_Inkscape.sh -s 64 -t png -b 2 -p"
    echo "Options: "
    echo "  -s, --size"
    echo "      Size of resulting icon, maximum is 256."
    echo "  -t, --type"
    echo "      Output image format, by extension."
    echo "  -b, --bachground"
    echo "      Icon background type, available options are:"
    echo "      0 - none, 1 - solid white, 2 - solid beige"
    echo "  -p, --preview"
    echo "      Generate preview sheet of all icons in .png format,"
    echo "      icons of 96x96px in six columns."
    echo "  -h, --help"
    echo "      Display this message."
    echo "Default options:"
    echo "  64px, png, background 2, no preview"
    echo ""
exit
fi

declare -a icon_name
declare -a icon

# PRINTING
icon_name+=("printing_flow")   icon+=("g3836;g110")
icon_name+=("printing_speed")  icon+=("g3836;g1014")
icon_name+=("printing_tune")  icon+=("g3836;layer53")
icon_name+=("printing_cool_v1")    icon+=("g3836;g1360")
icon_name+=("printing_cool_v2")    icon+=("g3836;g3868")

# HOTENDS
icon_name+=("hotend")   icon+=("g927")
icon_name+=("hotend_temp")  icon+=("g927;layer3")
icon_name+=("hotend1_temp") icon+=("g927;layer3;g919")
icon_name+=("hotend2_temp") icon+=("g927;layer3;layer1")
icon_name+=("hotend3_temp") icon+=("g927;layer3;g10252")
icon_name+=("hotend_spool")  icon+=("g927;layer45")
icon_name+=("hotend1_spool") icon+=("g1622;layer46;g919")
icon_name+=("hotend2_spool") icon+=("g1622;layer46;layer1")
icon_name+=("hotend3_spool") icon+=("g1622;layer46;g10252")

# BED
icon_name+=("bed")  icon+=("g3942") 
icon_name+=("bed_leveling") icon+=("g3942;g935")
icon_name+=("bed_temp_v0")  icon+=("g3942;layer3")
icon_name+=("bed_temp_v1")  icon+=("g3942;layer3;layer4")
icon_name+=("bed_temp_v2")  icon+=("g3942;layer3;g911")
icon_name+=("bed_z_offset")  icon+=("g1622;layer47;g3942")

# CHAMBER
icon_name+=("chamber")  icon+=("layer2")
icon_name+=("chamber_temp") icon+=("layer2;layer3")
icon_name+=("chamber_light") icon+=("layer2;layer18")
icon_name+=("chamber_light_on") icon+=("layer2;layer18;layer19")
icon_name+=("chamber_light_off") icon+=("layer2;layer21;layer20")
icon_name+=("chamber_fan_v1")  icon+=("layer2;layer22")
icon_name+=("chamber_fan_v1_on")  icon+=("layer2;layer22;layer19")
icon_name+=("chamber_fan_v1_off")  icon+=("layer2;layer22;layer20")
icon_name+=("chamber_fan_v1_speed")  icon+=("layer2;layer22;layer24")
icon_name+=("chamber_fan_v2")  icon+=("layer2;layer23")
icon_name+=("chamber_fan_v2_on")  icon+=("layer2;layer23;layer19")
icon_name+=("chamber_fan_v2_off")  icon+=("layer2;layer23;layer20")
icon_name+=("chamber_fan_v2_speed")  icon+=("layer2;layer23;layer24")

# MOVEMENT
icon_name+=("move_X")  icon+=("layer6;layer8")
icon_name+=("move_Y")  icon+=("layer6;g1615")
icon_name+=("move_Z")  icon+=("layer6;g1607")
icon_name+=("move_E")  icon+=("g927;layer9")
icon_name+=("move_E1")  icon+=("g927;layer9;g919")
icon_name+=("move_E2")  icon+=("g927;layer9;layer1")
icon_name+=("move_E_wheel")  icon+=("g927;layer9;layer66")
icon_name+=("move_E_up")  icon+=("g927;layer68;layer66")
icon_name+=("move_E_down")  icon+=("g927;layer67;layer66")
icon_name+=("home_X")  icon+=("layer13;layer14")
icon_name+=("home_X1")  icon+=("layer13;g1456")
icon_name+=("home_X2")  icon+=("layer13;g1450")
icon_name+=("home_Y")  icon+=("layer13;layer15")
icon_name+=("home_"Y1)  icon+=("layer13;g1468")
icon_name+=("home_Y2")  icon+=("layer13;g1462")
icon_name+=("home_Z")  icon+=("layer13;layer16")
icon_name+=("home_all")  icon+=("layer13;layer17")
icon_name+=("move_all")  icon+=("layer43")

# MACHINE
icon_name+=("machine_prusa")  icon+=("layer30")
icon_name+=("machine_coreXY")  icon+=("layer31")
icon_name+=("machine_delta")  icon+=("layer32")

# MISC
icon_name+=("fan_v1")  icon+=("g1481")
icon_name+=("fan_v2")  icon+=("layer7")
icon_name+=("thermo")  icon+=("g1231")
icon_name+=("SD_v1")  icon+=("layer11")
icon_name+=("SD_v2")  icon+=("g1301")
icon_name+=("SD_v3")  icon+=("layer12")
icon_name+=("cogs_1")  icon+=("layer25")
icon_name+=("cogs_2")  icon+=("layer26")
icon_name+=("cog_1")  icon+=("layer27")
icon_name+=("cog_2")  icon+=("layer28")
icon_name+=("stepper_v1")  icon+=("layer29")
icon_name+=("stepper_v2")  icon+=("g12324")
icon_name+=("stepper_off")  icon+=("g12324;layer48")
icon_name+=("spool")  icon+=("layer44")
icon_name+=("psu")  icon+=("layer49")
icon_name+=("psu_on")  icon+=("layer49;layer50")
icon_name+=("psu_off")  icon+=("layer49;layer51")
icon_name+=("light_on")  icon+=("layer52;layer55;layer50")
icon_name+=("light_off")  icon+=("layer52;layer51")
icon_name+=("light_off_norays")  icon+=("layer52;layer51")
icon_name+=("light")  icon+=("layer52;layer55")
icon_name+=("light_cog")  icon+=("layer52;layer55;layer54")
icon_name+=("host_start_octoprint")  icon+=("layer69")

# ARROWS & COMMON CONTROLS
icon_name+=("up")  icon+=("layer57")
icon_name+=("down")  icon+=("g30023")
icon_name+=("left")  icon+=("g30029")
icon_name+=("right")  icon+=("g30047")
icon_name+=("up_left")  icon+=("g30870")
icon_name+=("up_right")  icon+=("g31952")
icon_name+=("down_left")  icon+=("g31960")
icon_name+=("down_right")  icon+=("g31968")
icon_name+=("prism")  icon+=("layer59")
icon_name+=("circle")  icon+=("layer58")
icon_name+=("ok_p")  icon+=("layer59;layer60")
icon_name+=("excl_p")  icon+=("layer59;layer65")
icon_name+=("plus_p")  icon+=("layer59;layer63")
icon_name+=("minus_p")  icon+=("layer59;layer64")
icon_name+=("check_p")  icon+=("layer59;layer62")
icon_name+=("cross_p")  icon+=("layer59;layer61")
icon_name+=("ok_c")  icon+=("layer58;layer60")
icon_name+=("excl_c")  icon+=("layer58;layer65")
icon_name+=("plus_c")  icon+=("layer58;layer63")
icon_name+=("minus_c")  icon+=("layer58;layer64")
icon_name+=("check_c")  icon+=("layer58;layer62")
icon_name+=("cross_c")  icon+=("layer58;layer61")

icon_name+=("start_big")  icon+=("layer71")
icon_name+=("stop_big")  icon+=("layer72")
icon_name+=("pause_big")  icon+=("layer73")
icon_name+=("forward_v1_big")  icon+=("layer74")
icon_name+=("backward_v1_big")  icon+=("layer75")
icon_name+=("start_small_p")  icon+=("layer59;layer70")
icon_name+=("stop__small_p")  icon+=("layer59;layer76")
icon_name+=("pause_small_p")  icon+=("layer59;layer77")
icon_name+=("forward_v1_small_p")  icon+=("layer59;layer78")
icon_name+=("backward_v1_small_p")  icon+=("layer59;layer79")
icon_name+=("start_small_c")  icon+=("layer58;layer70")
icon_name+=("stop__small_c")  icon+=("layer58;layer76")
icon_name+=("pause_small_c")  icon+=("layer58;layer77")
icon_name+=("forward_v1_small_c")  icon+=("layer58;layer78")
icon_name+=("backward_v1_small_c")  icon+=("layer58;layer79")
icon_name+=("back_v1")  icon+=("layer80")
icon_name+=("back_v2")  icon+=("layer87")
icon_name+=("enter_v1")  icon+=("layer81")
icon_name+=("enter_v2")  icon+=("layer86")
icon_name+=("undo_v1")  icon+=("layer83")
icon_name+=("undo_v2")  icon+=("layer84")
icon_name+=("undo_v3")  icon+=("layer89")
icon_name+=("redo_v1")  icon+=("layer82")
icon_name+=("redo_v2")  icon+=("layer88")
icon_name+=("redo_v3")  icon+=("layer85")


#icon_name+=("")  icon+=("layer")

declare -a bgs
# 
bgs+=("layer34")    # 0 empty 
bgs+=("layer33")    # 1 plain white
bgs+=("layer5")     # 2 plain beige

bg=${bgs[$b]}

echo "Downloading ImageMagick as an AppImage because all deb packages are broken now..."
wget -c -O ./magick "https://download.imagemagick.org/ImageMagick/download/binaries/magick" 
chmod +x ./magick

wd="/dev/shm/3dpitmp"
#mkdir -pv ./3DPIcons/tmp
mkdir -pv $wd
mkdir -pv ./3DPIcons/$s-$t
cp -fv ./3DPrinting_Icons_Inkscape.svg $wd/source.svg

inkscape --batch-process --verb "LayerShowAll;FileSave;FileQuit" $wd/source.svg

inkscape --export-type="png"  --export-id="$bg" \
         --export-width=256 --export-height=256 --export-id-only --export-area-page --export-background-opacity=0\
         --export-filename="$wd/$bg.png" $wd/source.svg

for ((i=0; i<${#icon[@]};i++))
    do
    echo "prnting  ${icon[$i]}"
    echo "icon name ${icon_name[$i]}"
      ids=${icon[$i]}
      fname=${icon_name[$i]}
     cp $wd/$bg.png $wd/tmp_$fname.png
     IFS=$';'
      for j in $ids
      do
        echo $j
        inkscape --export-type="png"  --export-id="$j" \
                 --export-width=256 --export-height=256 --export-id-only --export-area-page --export-background-opacity=0 \
                 --export-filename="$wd/$j.png" $wd/source.svg

        ./magick composite -gravity center $wd/$j.png $wd/tmp_$fname.png $wd/tmp_$fname.png
        ./magick convert $wd/tmp_$fname.png -resize "$s"x"$s" -antialias ./3DPIcons/$s-$t/$fname.$t
    done
    unset IFS
    
done

if [ "$p" == "y" ]; then
    shopt -s nullglob
    src=($wd/tmp_*)
    ./magick montage "${src[@]}" -geometry 96x96+5+5 -tile 6x -shadow -background none ./3DPIcons/$s-$t/preview.png
fi

# function dropshadow () {
#     filename=$(basename -- "$1")
#     #extension="${filename##*.}"
#     basename="${filename%.*}"
#     #we want to enforce png (even if .jpg as input)
#     suffix="_shadow.png"
#     convert "$1" \( +clone -background black -shadow 50x10+5+5 \) +swap -background none -layers merge +repage "$basename$suffix"
# }

# Template for future, when Inkscape hopefully will work as expected
# 
# for ((i=0; i<${#icon[@]};i++))
#    do
#      ids=${icon[$i]}
#      fname=${icon_name[$i]}
#        inkscape --batch-process --export-type="$t"  --export-id="$bg;$ids" \
#                 --export-width="${s}" --export-height="${s}" --export-id-only --export-area-page\
#                 --export-filename="./3DPIcons/$s-$t/$fname.$t" \
#                ./3DPrinting_Icons_Inkscape.svg
# done


rm -rfv $wd



