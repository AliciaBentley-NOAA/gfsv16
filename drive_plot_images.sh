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

export CASE='Humberto2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export PLOT_FCST=true
export PLOT_LLVL=true
export PLOT_PPCP=true

#for cycle in 2019090800
for cycle in 2019090800 2019090812 2019090900 2019090912 2019091000 2019091012 2019091100 2019091112 2019091200 2019091212 2019091300 2019091312 2019091400 2019091412 2019091500 2019091512 2019091600 2019091612 2019091700 2019091712 2019091800
do

for domain in nwatl us
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

done
done

exit
