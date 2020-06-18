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

export CASE='Karen2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export PLOT_FCST=true
export PLOT_LLVL=true
export PLOT_PPCP=true
export PLOT_REFL=false    # leave reflectivity false unless going back and adding for select cases

#for cycle in 2019091000
for cycle in 2019091600 2019091612 2019091700 2019091712 2019091800 2019091812 2019091900 2019091912 2019092000 2019092012 2019092100 2019092112 2019092200 2019092212 2019092300 2019092312 2019092400 2019092412 2019092500 2019092512 2019092600
do

for domain in us pr
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
if [ $PLOT_REFL = true ]; then
   echo "Create/submit script to plot ${CYCLE} GFSv15/v16 comp. refl. forecasts!"
   ${SCRIPTS_PATH}/create_plot_refl.sh
   sleep 3
fi


done
done

exit
