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

export CASE='Dorian2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export PLOT_FCST=true
export PLOT_LLVL=true
export PLOT_PPCP=true
export PLOT_REFL=true
export PLOT_SNOD=false     # leave false unless you have asked for NOHRSC snowfall analyses from Alicia
export PLOT_WEASD=false    # leave false unless you have asked for NOHRSC snowfall analyses from Alicia

#for cycle in 2020020212
for cycle in 2019082700 2019082712 2019082800 2019082812 2019082900 2019082912 2019083000 2019083012 2019083100 2019083112 2019090100 2019090112 2019090200 2019090212 2019090300 2019090312 2019090400 2019090412 2019090500 2019090512 2019090600
do

for domain in pr se nwatl us
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
