#!/bin/bash
# Author: Alicia Bentley
# Modified: 4 June 2020
#
###################################################
# Script to get download necessary data from HPSS #
###################################################

#==============================================  BEGIN CHANGES  ================================================

export SCRIPTS_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'
export DATA_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'

export CASE='Karen2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export GET_RET=true
export GET_GFS=true
export GET_RAP=true
export GET_ST4=true

#for cycle in 2019092900
for cycle in 2019091600 2019091612 2019091700 2019091712 2019091800 2019091812 2019091900 2019091912 2019092000 2019092012 2019092100 2019092112 2019092200 2019092212 2019092300 2019092312 2019092400 2019092412 2019092500 2019092512 2019092600
do

export CYCLE=${cycle}

#===============================================  END CHANGES  =================================================

echo "*********************"
if [ $GET_RET = true ]; then
   echo "Create/submit script to download ${CYCLE} GFSv16 RETRO and OPS GFS forecast data"
   ${SCRIPTS_PATH}/create_htar_retros_prod.sh
   sleep 5
fi


echo "*********************"
if [ $GET_GFS = true ]; then
   echo "Create/submit script to download GFS analysis data"
   ${SCRIPTS_PATH}/create_htar_gfs_anl.sh
   sleep 5
fi


echo "*********************"
if [ $GET_RAP = true ]; then
   echo "Create/submit script to download RAP analysis data"
   ${SCRIPTS_PATH}/create_htar_rap_anl.sh
   sleep 5
fi


echo "*********************"
if [ $GET_ST4 = true ]; then
   echo "Create/submit script to download Stage-IV analysis data"
   ${SCRIPTS_PATH}/create_htar_st4_anl.sh
   sleep 5
fi


done

exit
