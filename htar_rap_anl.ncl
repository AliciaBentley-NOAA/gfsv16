; ===========================================
; Plots 4-panel of GEFS mean/spread & diff.
; Created by: Alicia M. Bentley
; Last updated: 28 October 2019
; ===========================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
; ===========================================
begin

print("======================")
print("Script has started!")
print("======================")

; Define casename
  if (isdefined("eventname")) then
        print("Eventname defined on command line: "+eventname)
        casename = eventname
  else
        print("No eventname defined on command line")
        casename = "eventname"
  end if

;================================================================

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

          print("Downloading RAP analysis file from HPSS...")

          if (toint(hour) .le. 5) then
             tar_suffix = "00-05.awip32.tar"
          else if (toint(hour) .ge. 6  .and. toint(hour) .le. 11) then
             tar_suffix = "06-11.awip32.tar"
          else if (toint(hour) .ge. 12 .and. toint(hour) .le. 17) then
             tar_suffix = "12-17.awip32.tar"
          else if (toint(hour) .ge. 18 .and. toint(hour) .le. 23) then
             tar_suffix = "18-23.awip32.tar"
          end if
          end if
          end if
          end if

          ; Define start and end dates for changing RAP tarfile naming conventions on HPSS

          rap_cdate2 = cd_inv_calendar(2020,2,26,18,00,00,timeunits,0)      ; Specify date formating changed
  	  rap_cdate1 = cd_inv_calendar(2018,7,11,18,00,00,timeunits,0)      ; Specify date formating changed

          if (thisdate .ge. rap_cdate2) then
                print("thisdate is after the RAP naming convention didn't care about machine")
                raptar = "com_rap_prod_rap"
                rappath = "/NCEPPROD/hpssprod/runhistory/2year"
	  else if (thisdate .ge. rap_cdate1) .and. (thisdate .lt. rap_cdate2) then
        	print("thisdate is after RAP moved to the Cray")
        	raptar = "gpfs_hps_nco_ops_com_rap_prod_rap"
        	rappath = "/NCEPPROD/hpssprod/runhistory/2year"
  	  else if (thisdate .lt. rap_cdate1) then
        	print("thisdate is before RAP moved to the Cray")
        	raptar = "com2_rap_prod_rap"
        	rappath = "/NCEPPROD/hpssprod/runhistory"
  	  end if
  	  end if
          end if

          cmd = "htar -xvf "+rappath+"/rh"+year+"/"+str_get_cols(ymd,0,5)+"/"+ymd+"/"+raptar+"."+str_get_cols(modelstrings,0,7)+tar_suffix + \
                " ./rap.t"+hour+"z.awip32f00.grib2"
          system(cmd)

          cmd = "mv rap.t"+hour+"z.awip32f00.grib2" + \
                " ./rap."+ymd+".t"+hour+"z.awip32f00.grib2"
          system(cmd)

       anl=addfile("rap."+ymd+".t"+hour+"z.awip32f00.grib2","r")

end do

;-------------------------------------------------------------------------------

cmd = "mkdir -p ../../analyses/"
print(cmd)
system(cmd)

cmd2 = "'mv' rap*.grib2 ../../analyses/."
print(cmd2)
system(cmd2)

;-------------------------------------------------------------------------------


print("======================")
print("Script has finished!")
print("======================")


end



