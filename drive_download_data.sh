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

export CASE='Humberto2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export GET_RET=true
export GET_GFS=true
export GET_RAP=true
export GET_ST4=true

#for cycle in 2019091800
for cycle in 2019090800 2019090812 2019090900 2019090912 2019091000 2019091012 2019091100 2019091112 2019091200 2019091212 2019091300 2019091312 2019091400 2019091412 2019091500 2019091512 2019091600 2019091612 2019091700 2019091712 2019091800
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