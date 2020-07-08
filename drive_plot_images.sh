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

export CASE='Barbara2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export PLOT_FCST=true
export PLOT_LLVL=true
export PLOT_PPCP=true
export PLOT_REFL=true 
export PLOT_SNOD=false     # leave false unless you have asked for NOHRSC snowfall analyses from Alicia
export PLOT_WEASD=false    # leave false unless you have asked for NOHRSC snowfall analyses from Alicia

#for cycle in 2019121000
for cycle in 2019062712 2019062800 2019062812 2019062900 2019062912 2019063000 2019063012 2019070100 2019070112 2019070200 2019070212 2019070300 2019070312 2019070400 2019070412 2019070500 2019070512 2019070600 2019070612 2019070700 2019070712
do

for domain in us hi epactc
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
