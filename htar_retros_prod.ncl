; ===========================================
; Download data for GEFS retrospectives
; Created by: Alicia M. Bentley
; Last updated: 4 December 2019
; ===========================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
; ===========================================
begin

print("======================")
print("Forecast script has started!")
print("======================")

; Define casename
  if (isdefined("eventname")) then
        print("Eventname defined on command line: "+eventname)
        casename = eventname
  else
        print("No eventname defined on command line")
        casename = "eventname"
  end if

;==================================================================

; Pre-defined domain definitions
  minlatlist=(/15.0,35.0,25.0,31.0,40.0,25.5,35.0,42.0,41.0,34.0,40.0,34.0,24.5,12.5,10,20,1,-40,15/)
  maxlatlist=(/60.0,75.0,50.0,43.0,50.0,37.5,44.0,50.0,49.5,43.0,48.0,42.5,35.0,35,27,47.5,60,-1,62.5/)
  minlonlist=(/-135.0,160.0,-120,-125.0,-125.0,-108.0,-108.0,-110.0,-97.0,-97.0,-81.0,-86.0,-92.0,-105,-81,-95,110,137.5,-167.5/)
  maxlonlist=(/-60.0,250.0,-72.5,-105.0,-107.0,-90.0,-92.0,-95.0,-80.5,-83.0,-66.5,-72.0,-76.0,-72.5,-55,-57.5,179,192.5,-115/)
  regionlist=(/"us","ak","uszoom","sw","nw","t","cp","np","mw","ov","ne","ma","se","gom","pr","nwatl","wpac","spac","epac"/)
  if (isdefined("scriptregion")) then
     if (scriptregion .eq. "new")
        print("New domain requested. Script will fail if the following variables are not defined with command line arguments: regionname, minlat, minlon, maxlat, maxlon.")
        scriptregion=regionname
     else
        print("Domain defined on command line")
        scriptregion=str_lower(scriptregion)
     end if
  else
     scriptregion="us"
  end if
  do c=0,dimsizes(regionlist)-1
    if (regionlist(c).eq.scriptregion) then
      minlat=minlatlist(c)
      minlon=minlonlist(c)
      maxlat=maxlatlist(c)
      maxlon=maxlonlist(c)
    end if
  end do
 
; =================================================================

; Obtaining the date of the forecast requested 
  scriptyear=toint(str_get_cols(scriptyyyymmddhh,0,3))
  scriptmonth=toint(str_get_cols(scriptyyyymmddhh,4,5))
  scriptday=toint(str_get_cols(scriptyyyymmddhh,6,7))
  scripthour=toint(str_get_cols(scriptyyyymmddhh,8,9))
  timeunits="hours since 1800-01-01 00:00"
  datemodel=ut_inv_calendar(scriptyear,scriptmonth,scriptday,scripthour,0,0,timeunits,0)
  datestart=ut_inv_calendar(scriptyear,scriptmonth,scriptday,scripthour,0,0,timeunits,0)

; =================================================================


; Define start and end dates for changing ops GFS tarfile naming conventions on HPSS
  gefs_cdate = cd_inv_calendar(2019,8,20,00,00,00,timeunits,0)      ; Specify date formating changed
  if (datemodel .ge. gefs_cdate) then
        print("idate is after GEFS moved to Dell")
        gefstar = "gpfs_dell2_nco_ops_com_gens_prod_gefs"
  else if (datemodel .lt. gefs_cdate) then
        print("idate is before GEFS moved to Dell")
        gefstar = "com2_gens_prod_gefs"
  end if
  end if

;;; Define start and end dates of retro streams so HPSS directories are named correctly
  retro1_sdate  = cd_inv_calendar(2017,1,1,00,00,00,timeunits,0)      ; Specify start date of date range (sdate)
  retro1_edate = cd_inv_calendar(2017,12,31,18,00,00,timeunits,0)       ; Specify end date of date range (edate)

  retro2_sdate = cd_inv_calendar(2018,1,1,00,00,00,timeunits,0)      ; Specify start date of date range (sdate)
  retro2_edate = cd_inv_calendar(2018,12,31,18,00,00,timeunits,0)      ; Specify end date of date range (edate)

  retro3_sdate = cd_inv_calendar(2019,1,1,00,00,00,timeunits,0)      ; Specify start date of date range (sdate)
  retro3_edate = cd_inv_calendar(2019,12,31,18,00,00,timeunits,0)      ; Specify end date of date range (edate)

  if (datemodel .ge. retro1_sdate) .and. (datemodel .le. retro1_edate) then
     prod_dir = "/NCEPPROD/hpssprod/runhistory/rh2017"
     archive_dir = "/NCEPDEV/emc-ensemble/2year/emc.enspara/fv3gefs/RETRO/2017"
     WCOSS_dir = "/gpfs/hps2/nco/storage/fv3gefs/RETRO/2017"

  else if (datemodel .ge. retro2_sdate) .and. (datemodel .le. retro2_edate) then
     prod_dir = "/NCEPPROD/hpssprod/runhistory/rh2018"
     archive_dir = "/NCEPDEV/emc-ensemble/2year/emc.enspara/fv3gefs/RETRO/2018"
     WCOSS_dir = "/gpfs/hps2/nco/storage/fv3gefs/RETRO/2018"

  else if (datemodel .ge. retro3_sdate) .and. (datemodel .le. retro3_edate) then
     prod_dir = "/NCEPPROD/hpssprod/runhistory/rh2019"
     archive_dir = "/NCEPDEV/emc-ensemble/2year/emc.enspara/fv3gefs/RETRO/2019"
     WCOSS_dir = "/gpfs/hps2/nco/storage/fv3gefs/RETRO/2019"

  end if
  end if
  end if

;===================================================================

;;; Check to see if starting forecast hour was defined with command line argument
  if (isdefined("fhr_start")) then
     print("Starting forecast defined on command line")
     fhrb = toint(fhr_start)
     startdate1=datemodel+fhrb
     startdate1@units=timeunits
     startints=ut_calendar(startdate1,0)
     datestart=ut_inv_calendar(toint(startints(:,0)),toint(startints(:,1)),toint(startints(:,2)),toint(startints(:,3)),0,0,timeunits,0)
  else
     datestart=ut_inv_calendar(scriptyear,scriptmonth,scriptday,scripthour,0,0,timeunits,0)
  end if




;;; Check to see if ending forecast hour was defined with command line argument
  if (isdefined("fhr_end")) then
     print("Ending forecast defined on command line")
     fhr_diff = toint(fhr_end) - toint(fhr_start) 
     fhre = toint(fhr_diff)
  else
     fhre=toint(0)
  end if

  enddate1=datestart+fhre
  enddate1@units=timeunits
  endints=ut_calendar(enddate1,0)

  dateend=ut_inv_calendar(toint(endints(:,0)),toint(endints(:,1)),toint(endints(:,2)),toint(endints(:,3)),0,0,timeunits,0)
  datemodel@units=timeunits




;;; Check to see if forecast hour increment was defined with command line argument
  if (isdefined("fhr_inc")) then
     print("Forecast hour increment defined on command line")
     fhri = toint(fhr_inc)
  else
     fhri=6
  end if

  fdates=ispan(toint(datestart),toint(dateend),fhri)
  fhours=ispan(toint(datestart)-toint(datemodel),toint(dateend)-toint(datemodel),fhri)


  do h=0,dimsizes(fdates)-1
    ;print((/fhours(h)/))
    thisdate=fdates(h)
    thisdate@units=timeunits
    modelstrings=tostring(ut_calendar(thisdate,-3))
    ms=tostring(ut_calendar(datemodel,-3))
    ;model date
    yearm=str_get_cols(ms,0,3)
    monthm=str_get_cols(ms,4,5)
    daym=str_get_cols(ms,6,7)
    hourm=str_get_cols(ms,8,9)
    mdhm=str_get_cols(ms,4,9)
    ymm=str_get_cols(ms,0,5)
    ymdm=str_get_cols(ms,0,7)
    ;date of forecast hour
    year=str_get_cols(modelstrings,0,3)
    month=str_get_cols(modelstrings,4,5)
    day=str_get_cols(modelstrings,6,7)
    hour=str_get_cols(modelstrings,8,9)
    mdh=str_get_cols(modelstrings,4,9)
    ymd=str_get_cols(modelstrings,0,7)
    monthind=toint(month)
    months=(/"","January","February","March","April","May","June","July","August","September","October","November","December"/)

  print(" ")
  print("Int: YYYYMMDDHH (FXXX): "+ymdm+hourm+" (F"+sprinti("%0.3i",fhours(h))+")")
; ==========================================================================

;Obtaining GEFSv16 forecast files
          print("Downloading GFSv16 forecast file from HPSS...")

          retro_cdate5 = cd_inv_calendar(2020,5,19,00,00,00,timeunits,0)      ; Specify date formating changed
          retro_cdate4 = cd_inv_calendar(2020,4,1,00,00,00,timeunits,0)      ; Specify date formating changed
          retro_cdate3 = cd_inv_calendar(2019,12,1,00,00,00,timeunits,0)      ; Specify date formating changed
          retro_cdate2 = cd_inv_calendar(2019,9,1,00,00,00,timeunits,0)      ; Specify date formating changed
          retro_cdate1 = cd_inv_calendar(2019,6,1,00,00,00,timeunits,0)      ; Specify date formating changed

          print("thisdate: "+modelstrings)

          if (thisdate .ge. retro_cdate5) then
                print("Initialized in v16rt2 stream (realtime)!")

                cmd = "htar -xvf /NCEPDEV/emc-global/5year/emc.glopara/WCOSS_D/gfsv16/v16rt2/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          else if (thisdate .ge. retro_cdate4) .and. (thisdate .lt. retro_cdate5) then
                print("Initialized in v16retro4e!")

                cmd = "htar -xvf /NCEPDEV/emc-global/5year/emc.glopara/WCOSS_D/gfsv16/v16retro4e/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          else if (thisdate .ge. retro_cdate3) .and. (thisdate .lt. retro_cdate4) then
                print("Initialized in v16retro3e!")
          
                cmd = "htar -xvf /NCEPDEV/emc-global/5year/glopara/HERA/gfsv16/v16retro3e/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)
          
                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)
          
;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          else if (thisdate .ge. retro_cdate2) .and. (thisdate .lt. retro_cdate3) then
                print("Initialized in v16retro2e!")

                cmd = "htar -xvf /NCEPDEV/emc-global/5year/emc.glopara/WCOSS_D/gfsv16/v16retro2e/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          else if (thisdate .ge. retro_cdate1) .and. (thisdate .lt. retro_cdate2) then
                print("Initialized in v16retro1e!")
          
                cmd = "htar -xvf /NCEPDEV/emc-global/5year/emc.glopara/WCOSS_D/gfsv16/v16retro1e/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          else if (thisdate .lt. retro_cdate1) then
                print("Initialized in v16retro0e!")
          
                cmd = "htar -xvf /NCEPDEV/emc-global/5year/emc.glopara/WCOSS_D/gfsv16/v16retro0e/"+ymdm+hourm+"/gfsa.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

          end if
          end if
          end if
          end if
          end if
          end if

;-----------------------------------------------------------------------------------

;Obtaining GFSv15 forecast files
          print("Downloading GFSv15 forecast file from HPSS...")

          gfs_cdate3 = cd_inv_calendar(2020,2,26,00,00,00,timeunits,0)      ; Specify date formating changed
          gfs_cdate2 = cd_inv_calendar(2019,6,12,00,00,00,timeunits,0)      ; Specify date formating changed
          gfs_cdate1 = cd_inv_calendar(2017,7,20,00,00,00,timeunits,0)      ; Specify date formating changed

	  print("thisdate: "+modelstrings)

          if (thisdate .ge. gfs_cdate3) then
                print("Valid date is after GFS naming convention was FINALLY corrected!")

                cmd = "htar -xvf /NCEPPROD/hpssprod/runhistory/rh"+yearm+"/"+str_get_cols(ymdm,0,5)+"/"+ymdm+"/com_gfs_prod_gfs."+ymdm+"_"+hourm+".gfs_pgrb2.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                ;print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

           else if (thisdate .ge. gfs_cdate2 .and. thisdate .lt. gfs_cdate3) then
                print("Valid date is after GFS moved to Dell")

                cmd = "htar -xvf /NCEPPROD/hpssprod/runhistory/rh"+yearm+"/"+str_get_cols(ymdm,0,5)+"/"+ymdm+"/gpfs_dell1_nco_ops_com_gfs_prod_gfs."+ymdm+"_"+hourm+".gfs_pgrb2.tar" + \
                        " ./gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                ;print(cmd)
                system(cmd)

                cmd = "mv gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+"/"
;                system(cmd)

           else if (thisdate .ge. gfs_cdate1 .and. thisdate .lt. gfs_cdate2) then
                print("Valid date is before GFS moved to Dell")

                cmd = "htar -xvf /NCEPPROD/hpssprod/runhistory/rh"+yearm+"/"+str_get_cols(ymdm,0,5)+"/"+ymdm+"/gpfs_hps_nco_ops_com_gfs_prod_gfs."+ymdm+hourm+".pgrb2_0p25.tar" + \
                        " ./gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                ;print(cmd)
                system(cmd)

                cmd = "mv gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+hourm+"/"
;                system(cmd)

           else if (thisdate .lt. gfs_cdate1) then
                print("Valid date is before GFS name change at 0000 UTC 20 July 2017")

                cmd = "htar -xvf /NCEPPROD/hpssprod/runhistory/rh"+yearm+"/"+str_get_cols(ymdm,0,5)+"/"+ymdm+"/com2_gfs_prod_gfs."+ymdm+hourm+".pgrb2_0p25.tar" + \
                        " ./gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))
                print(cmd)
                system(cmd)

                cmd = "mv gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h)) + \
                        " ./gfs15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
                system(cmd)

;                cmd = "rm -fR gfs."+ymdm+hourm+"/"
;                system(cmd)

           end if
           end if
           end if
           end if

end do    ; end loop through forecast dates

;------------------------------------

;system("sleep 20")
;cmd = "rm -fR gfs."+ymd+"*/"
;system(cmd)

;------------------------------------

print("=============================")
print("Forecast script has finished!")
print("=============================")


end



