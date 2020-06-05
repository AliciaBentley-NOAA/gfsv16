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

export CASE='test'
export FHR_START=0
export FHR_END=12
export FHR_INC=6

export GET_RET=true
export GET_ANL=true
export GET_RAP=false
export GET_ST4=false

for cycle in 2019090312
#for cycle in 2017082200 2017082300 2017082400 2017082500 2017082600 2017082700 2017082800 2017082900 2017083000 2017083100 2017090100
do

export CYCLE=${cycle}

#===============================================  END CHANGES  =================================================

if [ $GET_RET = true ]; then
   echo "Create/submit script to download ${CYCLE} GFSv16 RETRO and OPS GFS forecast data"
   ${SCRIPTS_PATH}/create_htar_retros_prod.sh
   sleep 5
fi


if [ $GET_ANL = true ]; then
   echo "Create/submit script to download GFS analysis data"
   ${SCRIPTS_PATH}/create_htar_gfs_anl.sh
   sleep 5
fi


if [ $GET_RAP = true ]; then
   echo "Create/submit script to download RAP analysis data"
   ${SCRIPTS_PATH}/create_htar_rap.sh
   sleep 5
fi


if [ $GET_ST4 = true ]; then
   echo "Create/submit script to download Stage-IV analysis data"
   ${SCRIPTS_PATH}/create_htar_st4.sh
   sleep 5
fi


done

exit
