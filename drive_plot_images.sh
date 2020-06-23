#!/bin/bash
# Author: Alicia Bentley
#
###################################################
# Script to initiate the plotting for each case   #
###################################################

#==============================================  BEGIN CHANGES  ================================================

export SCRIPTS_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'
export DATA_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'
export IMAGES_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'

export CASE='easternNAbomb'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export PLOT_FCST=true
export PLOT_LLVL=true
export PLOT_PPCP=true
export PLOT_SNOD=false     # leave false unless you have asked for NOHRSC snowfall analyses from Alicia
export PLOT_WEASD=false    # leave false unless you have asked for NOHRSC snowfall analyses from Alicia
export PLOT_REFL=false     # leave false unless going back and adding comp. reflectivity for select cases

#for cycle in 2019121000
for cycle in 2019120600 2019120612 2019120700 2019120712 2019120800 2019120812 2019120900 2019120912 2019121000 2019121012 2019121100 2019121112 2019121200 2019121212 2019121300 2019121312 2019121400 2019121412 2019121500 2019121512 2019121600
do

for domain in us nwatl
do

export CYCLE=${cycle}
export DOMAIN=${domain}

#===============================================  END CHANGES  =================================================

echo "*********************"
if [ $PLOT_FCST = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 standard forecasts!"
   ${SCRIPTS_PATH}/create_plot_standard.sh
   sleep 3
fi


echo "*********************"
if [ $PLOT_LLVL = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 low-level forecasts!"
   ${SCRIPTS_PATH}/create_plot_lowlevel.sh
   sleep 3
fi


echo "*********************"
if [ $PLOT_PPCP = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 precip forecasts!"
   ${SCRIPTS_PATH}/create_plot_precip.sh
   sleep 3
fi


echo "*********************"
if [ $PLOT_SNOD = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 snow (SNOD) forecasts!"
   ${SCRIPTS_PATH}/create_plot_snod.sh
   sleep 3
fi


echo "*********************"
if [ $PLOT_WEASD = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 snow (WEASD) forecasts!"
   ${SCRIPTS_PATH}/create_plot_snow.sh
   sleep 3
fi


echo "*********************"
if [ $PLOT_REFL = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 comp. refl. forecasts!"
   ${SCRIPTS_PATH}/create_plot_refl.sh
   sleep 3
fi


done
done

exit
