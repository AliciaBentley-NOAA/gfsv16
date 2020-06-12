#!/bin/bash
# Author: Alicia Bentley
#####################################
# Script for submitting jobs on Hera
#   that download data from HPSS
#####################################

echo path: ${DATA_PATH}/${CASE}/${CYCLE}/analyses
echo fhr_inc: ${FHR_INC}
echo fhr_start: ${FHR_START}
echo fhr_end: ${FHR_END}

mkdir -p ${DATA_PATH}/${CASE}/${CYCLE}/analyses
'cp' ${SCRIPTS_PATH}/htar_st4_anl.ncl ${DATA_PATH}/${CASE}/${CYCLE}/analyses/.
cd ${DATA_PATH}/${CASE}/

cat > ${DATA_PATH}/${CASE}/${CYCLE}/analyses/htar_st4_anl.csh <<EOF
#!/bin/csh
#SBATCH --account=ovp
#SBATCH --job-name=st4_htar
#SBATCH --output=st4_anl_htar.%j.out
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=3:30:00

cd ${DATA_PATH}/${CASE}/${CYCLE}/analyses

/bin/rm -rf ../htar_st4_anl_${CYCLE}_done

echo ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' ${DATA_PATH}/${CASE}/${CYCLE}/analyses/htar_st4_anl.ncl 

ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' ${DATA_PATH}/${CASE}/${CYCLE}/analyses/htar_st4_anl.ncl
#sleep 5

touch ../htar_st4_anl_${CYCLE}_done

exit

EOF



sbatch ${DATA_PATH}/${CASE}/${CYCLE}/analyses/htar_st4_anl.csh
sleep 5

exit

