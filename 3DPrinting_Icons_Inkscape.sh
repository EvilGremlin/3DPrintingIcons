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

# icon STUFF
icon_name+=("print_flow")   icon+=("g3836;g110")
icon_name+=("print_speed")  icon+=("g3836;g1014")
icon_name+=("print_cool_v1")    icon+=("g3836;g1360")
icon_name+=("print_cool_v2")    icon+=("g3836;g3868")

# HOTENDS STUFF
icon_name+=("hotend")   icon+=("g927")
icon_name+=("hotend_temp")  icon+=("g927;layer3")
icon_name+=("hotend1_temp") icon+=("g927;layer3;g919")
icon_name+=("hotend2_temp") icon+=("g927;layer3;layer1")

# BED STUFF
icon_name+=("bed")  icon+=("g3942") 
icon_name+=("bed_leveling") icon+=("g3942;g935")
icon_name+=("bed_temp_v0")  icon+=("g3942;layer3")
icon_name+=("bed_temp_v1")  icon+=("g3942;layer3;layer4")
icon_name+=("bed_temp_v2")  icon+=("g3942;layer3;g911")  

# CHAMBER STUFF
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

# MOVEMENT STUFF
icon_name+=("move_X")  icon+=("layer6;layer8")
icon_name+=("move_Y")  icon+=("layer6;g1615")
icon_name+=("move_Z")  icon+=("layer6;g1607")
icon_name+=("move_E")  icon+=("g927;layer9")
icon_name+=("move_E1")  icon+=("g927;layer9;g919")
icon_name+=("move_E2")  icon+=("g927;layer9;layer1")
icon_name+=("home_X")  icon+=("layer13;layer14")
icon_name+=("home_X1")  icon+=("layer13;g1456")
icon_name+=("home_X2")  icon+=("layer13;g1450")
icon_name+=("home_Y")  icon+=("layer13;layer15")
icon_name+=("home_"Y1)  icon+=("layer13;g1468")
icon_name+=("home_Y2")  icon+=("layer13;g1462")
icon_name+=("home_Z")  icon+=("layer13;layer16")
icon_name+=("home_all")  icon+=("layer13;layer17")

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
icon_name+=("stepper")  icon+=("layer29")

#icon_name+=("")  icon+=("")

declare -a bgs

bgs+=("layer34")    # 0 empty 
bgs+=("layer33")    # 1 plain white
bgs+=("layer5")     # 2 plain beige

bg=${bgs[$b]}

wd="/dev/shm/3dpitmp"
#mkdir -pv ./3DPIcons/tmp
mkdir -pv $wd
mkdir -pv ./3DPIcons/$s-$t
#cp -fv ./3DPrinting_Icons_Inkscape.svg $wd/source.svg
#
#inkscape --with-gui --verb "LayerShowAll;FileSave;FileQuit" $wd/source.svg
#
#inkscape --export-type="png"  --export-id="$bg" \
#         --export-width=256 --export-height=256 --export-id-only --export-area-page --export-background-opacity=0\
#         --export-filename="$wd/$bg.png" $wd/source.svg
#
#for ((i=0; i<${#icon[@]};i++))
#    do
#    echo "prnting  ${icon[$i]}"
#    echo "icon name ${icon_name[$i]}"
#      ids=${icon[$i]}
#      fname=${icon_name[$i]}
#     cp $wd/$bg.png $wd/tmp_$fname.png
#     IFS=$';'
#      for j in $ids
#      do
#        echo $j
#        inkscape --export-type="png"  --export-id="$j" \
#                 --export-width=256 --export-height=256 --export-id-only --export-area-page --export-background-opacity=0 \
#                 --export-filename="$wd/$j.png" $wd/source.svg
#
#        magick composite -gravity center $wd/$j.png $wd/tmp_$fname.png $wd/tmp_$fname.png
#        magick convert $wd/tmp_$fname.png -resize "$s"x"$s" -antialias ./3DPIcons/$s-$t/$fname.$t
#    done
#    unset IFS
#    
#done
echo "$p"

if [ "$p" == "y" ]; then
    shopt -s nullglob
    src=($wd/tmp_*)
    magick montage "${src[@]}" -geometry 96x96+5+5 -tile 6x -shadow -background none ./3DPIcons/$s-$t/preview.png
fi

#rm -rfv $wd


# Template for future, when Inkscape hopefully will work as expected
#
#for ((i=0; i<${#icon[@]};i++))
#    do
#      ids=${icon[$i]}
#      fname=${icon_name[$i]}
#        inkscape --export-type="$t"  --export-id="$bg;$ids" \
#                 --export-width="${s}" --export-height="${s}" --export-id-only --export-area-page\
#                 --export-filename="./3DPIcons/$s/$fname.$t" \
#                ./3Dicon_Icons_Inkscape.svg
#done



