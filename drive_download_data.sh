#!/bin/bash
# Author: Alicia Bentley
# Modified: 4 June 2019
#
###################################################
# Script to get download necessary data from HPSS #
###################################################

#==============================================  BEGIN CHANGES  ================================================

export SCRIPTS_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'
export DATA_PATH='/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16'

export CASE='Dorian2019'
export FHR_START=0
export FHR_END=240
export FHR_INC=6

export GET_RET=true
export GET_GFS=true
export GET_RAP=true
export GET_ST4=true

for cycle in 2019082700 2019082712 2019082800 2019082812 2019082900 2019082912 2019083000 2019083012 2019083100 2019083112 2019090100 2019090112 2019090200 2019090212 2019090300 2019090312 2019090400 2019090412 2019090500 2019090512 2019090600
#for cycle in 2020072918
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
