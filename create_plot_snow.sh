#!/bin/bash
# Author: Alicia Bentley
#####################################
# Script for submitting jobs on Hera
#   that download data from HPSS
#####################################

echo cycle: ${CYCLE}
echo domain: ${DOMAIN}

mkdir -p ${IMAGES_PATH}'/'${CASE}'/images/'${CYCLE}
'cp' ${SCRIPTS_PATH}/plot*.ncl ${DATA_PATH}/${CASE}/${CYCLE}/.
cd ${DATA_PATH}/${CASE}/

##########################################

if [[ $DOMAIN = "new" ]]; then

REGIONNAME="NC"
minlat=29.0
maxlat=37.5
minlon=-86.5
maxlon=-72.5

echo "submitting ${REGIONNAME} domain script for ${CYCLE}"

cat > ${DATA_PATH}/${CASE}/${CYCLE}/plot_snow_${REGIONNAME}_${CYCLE}.csh <<EOF
#!/bin/csh
#SBATCH --account=ovp
#SBATCH --job-name=${REGIONNAME}_snow_${CYCLE}
#SBATCH --output=plot_${REGIONNAME}_${CYCLE}.%j.out
#SBATCH -q batch
#SBATCH --nodes=1
#SBATCH --time=3:00:00

cd ${DATA_PATH}/${CASE}/${CYCLE}/

/bin/rm -rf ../plot_${CYCLE}_${REGIONNAME}_done

ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_6hsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_6hweasd.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_24hsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_24hweasd.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_totalsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'regionname="${REGIONNAME}"' 'minlat="${minlat}"' 'maxlat="${maxlat}"' 'minlon="${minlon}"' 'maxlon="${maxlon}"'  'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' 'cycle_number="${CYCLE_NUMBER}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_totalweasd.ncl


touch ../plot_${CYCLE}_${REGIONNAME}done

exit

EOF

sbatch ${DATA_PATH}/${CASE}/${CYCLE}/plot_snow_${REGIONNAME}_${CYCLE}.csh
sleep 5


#################################################

else

echo "submitting ${DOMAIN} domain script for ${CYCLE}"

cat > ${DATA_PATH}/${CASE}/${CYCLE}/plot_snow_${DOMAIN}_${CYCLE}.sh <<EOF
#!/bin/bash
#SBATCH --account=ovp
#SBATCH --job-name=${DOMAIN}_snow_${CYCLE}
#SBATCH --output=plot_${DOMAIN}_${CYCLE}.%j.out
#SBATCH -q batch
#SBATCH --nodes=1
#SBATCH --time=6:00:00

cd ${DATA_PATH}/${CASE}/${CYCLE}/

/bin/rm -rf ../plot_${CYCLE}_${DOMAIN}_done

ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_6hsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_6hweasd.ncl  
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_24hsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_24hweasd.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_totalsnod.ncl
ncl 'scriptyyyymmddhh="${CYCLE}"' 'eventname="${CASE}"' 'scriptregion="${DOMAIN}"' 'fhr_inc="${FHR_INC}"' 'fhr_start="${FHR_START}"' 'fhr_end="${FHR_END}"' 'images_path="${IMAGES_PATH}"' ${DATA_PATH}/${CASE}/${CYCLE}/plot_gfs_lambert_totalweasd.ncl

touch ../plot_${CYCLE}_${DOMAIN}_done

exit

EOF

sbatch ${DATA_PATH}/${CASE}/${CYCLE}/plot_snow_${DOMAIN}_${CYCLE}.sh
sleep 5

fi

exit
