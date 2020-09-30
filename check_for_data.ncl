; ===========================================
; Check that data was downloaded correctly
; Created by: Alicia M. Bentley
; Last updated: 12 June 2020
; ===========================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
; ===========================================
begin

print("======================")
print("Script has started!")
print("======================")

data_path = "/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16/Dorian2019/"
beginyyyymmddhh = "2019082700"
endyyyymmddhh = "2019090600"
int_inc = 12
fcst_inc = 6

beginyyyymmddhh_anl = beginyyyymmddhh 
endyyyymmddhh_anl = "2019091600"         ;Add 10 days to endyyyymmddhh

data_to_check = (/"rap","st4","gfs","retros"/)
;data_to_check = (/"retros"/)

;==================================================================
;==================================================================

; Obtaining the date of the first forecast requested
  startyear=toint(str_get_cols(beginyyyymmddhh,0,3))
  startmonth=toint(str_get_cols(beginyyyymmddhh,4,5))
  startday=toint(str_get_cols(beginyyyymmddhh,6,7))
  starthour=toint(str_get_cols(beginyyyymmddhh,8,9))
  timeunits="hours since 1800-01-01 00:00"
  datestart=ut_inv_calendar(startyear,startmonth,startday,starthour,0,0,timeunits,0)

; Obtaining the date of the last forecast requested
  endyear=toint(str_get_cols(endyyyymmddhh,0,3))
  endmonth=toint(str_get_cols(endyyyymmddhh,4,5))
  endday=toint(str_get_cols(endyyyymmddhh,6,7))
  endhour=toint(str_get_cols(endyyyymmddhh,8,9))
  timeunits="hours since 1800-01-01 00:00"
  dateend=ut_inv_calendar(endyear,endmonth,endday,endhour,0,0,timeunits,0)

; Obtaining the date of the first analysis requested
  astartyear=toint(str_get_cols(beginyyyymmddhh_anl,0,3))
  astartmonth=toint(str_get_cols(beginyyyymmddhh_anl,4,5))
  astartday=toint(str_get_cols(beginyyyymmddhh_anl,6,7))
  astarthour=toint(str_get_cols(beginyyyymmddhh_anl,8,9))
  timeunits="hours since 1800-01-01 00:00"
  datestart_anl=ut_inv_calendar(astartyear,astartmonth,astartday,astarthour,0,0,timeunits,0)

; Obtaining the date of the last analysis requested
  aendyear=toint(str_get_cols(endyyyymmddhh_anl,0,3))
  aendmonth=toint(str_get_cols(endyyyymmddhh_anl,4,5))
  aendday=toint(str_get_cols(endyyyymmddhh_anl,6,7))
  aendhour=toint(str_get_cols(endyyyymmddhh_anl,8,9))
  timeunits="hours since 1800-01-01 00:00"
  dateend_anl=ut_inv_calendar(aendyear,aendmonth,aendday,aendhour,0,0,timeunits,0)

  sdate=tostring(ut_calendar(datestart,-3))
  edate=tostring(ut_calendar(dateend,-3))
  sdate_anl=tostring(ut_calendar(datestart_anl,-3))
  edate_anl=tostring(ut_calendar(dateend_anl,-3))

  print(" ")
  print("Date of first initialized forecast: "+sdate)
  print("Date of last initialized forecast:  "+edate)
  print(" ")
  print("Date of first analysis file: "+sdate_anl)
  print("Date of last analysis file:  "+edate_anl)
  print(" ")

;================================================================

do y = 0,dimsizes(data_to_check)-1,1

model = data_to_check(y)




if model .eq. "retros" then
  print("********************************************************************************")
  print("Looking for GFSv15 and GFSv16 forecasts initialized")
  print("between "+sdate+" and "+edate)
  print("(This will take a minute for each initialization date.)") 

  do x = datestart,dateend,toint(int_inc)

  idate = tostring(ut_calendar(x,-3))
  print("--------------------------------------------------------------------------------")
  print("Checking for GFSv15/v16 forecasts (F000-F240) from init. date: "+idate)

; Obtaining initialization date information
  hourm=str_get_cols(idate,8,9)
  ymdm=toint(str_get_cols(idate,0,7))

     do fhour = 0,240,fcst_inc
;       print("Looking for fhour: "+fhour)
;--------------------------------------------------------------
       parafile_gfs = data_path+idate+"/gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2"
;       print("parafile_gfs: "+parafile_gfs)

       if (isfilepresent(parafile_gfs)) then
;         print("GFSv16 fcst file gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2 found!")
       else
          print("GFSv16 fcst file gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2")
          print("is missing from "+data_path+idate+"/")
	  print("*******")
          system("sleep 3")
       end if
;----------------------------------------------------------------
       prodfile_gfs = data_path+idate+"/gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2"
;       print("prodfile_geavg: "+prodfile_geavg)

       if (isfilepresent(prodfile_gfs)) then
;         print("GFSv15 fcst file gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2 found!")
       else
          print("GFSv15 fcst file gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhour)+".grib2")
          print("is missing from "+data_path+idate+"/")
          print("*******")
          system("sleep 3")
       end if
;--------------------------------------------------------------
     end do
  end do
end if







;*****************************************************************

if (model .eq. "gfs")
  print("********************************************************************************")
  print("Looking for "+model+" analysis files initialized")
  print("between "+sdate_anl+" and "+edate_anl)

  do x = datestart_anl,dateend_anl,toint(fcst_inc)

  adate = tostring(ut_calendar(x,-3))
  print("--------------------------------------------------------------------------------")
  print("Checking for GFS analysis date: "+adate)

; Obtaining analysis date information
  hour=str_get_cols(adate,8,9)
  ymd=toint(str_get_cols(adate,0,7))

;--------------------------------------------------------------
       gfs_anl_f000 = data_path+"analyses/gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f000.grib2"
;       print("gfs_anl_f000: "+gfs_anl_f000)

       if (isfilepresent(gfs_anl_f000)) then
;          print("GFS analysis file gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f000.grib2 found!")
       else
          print("GFS analysis file gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f000.grib2")
          print("is missing from "+data_path+"analyses/")
          print("*******")
          system("sleep 3")
       end if
;--------------------------------------------------------------
if x .lt. dateend_anl then
       gfs_anl_f006 = data_path+"analyses/gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f006.grib2"
;       print("gfs_anl_f006: "+gfs_anl_f006)

       if (isfilepresent(gfs_anl_f006)) then
;          print("GFS analysis file gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f006.grib2 found!")
       else
          print("GFS analysis file gfs."+ymd+".t"+hour+"z.pgrb2.0p25.f006.grib2 is missing")
          print("from "+data_path+"analyses/")
          print("*******")
          system("sleep 3")
       end if
end if

  end do

end if







;*****************************************************************

if (model .eq. "rap")
  print("********************************************************************************")
  print("Looking for "+model+" analysis files initialized")
  print("between "+sdate_anl+" and "+edate_anl)

  do x = datestart_anl,dateend_anl,toint(fcst_inc)

  adate = tostring(ut_calendar(x,-3))
  print("--------------------------------------------------------------------------------")
  print("Checking for RAP analysis date: "+adate)

; Obtaining analysis date information
  hour=str_get_cols(adate,8,9)
  ymd=toint(str_get_cols(adate,0,7))

;--------------------------------------------------------------
       rap_anl = data_path+"analyses/rap."+ymd+".t"+hour+"z.awip32f00.grib2"
;       print("rap_anl: "+rap_anl)

       if (isfilepresent(rap_anl)) then
;          print("RAP analysis file rap."+ymd+".t"+hour+"z.awip32f00.grib2 found!")
       else
          print("RAP analysis file rap."+ymd+".t"+hour+"z.awip32f00.grib2 is missing")
          print("from "+data_path+"analyses/")
          print("*******")
          system("sleep 3")
       end if

  end do

end if





;*****************************************************************

if (model .eq. "st4")
  print("********************************************************************************")
  print("Looking for "+model+" analysis files initialized")
  print("between "+sdate_anl+" and "+edate_anl)

  do x = datestart_anl,dateend_anl,toint(fcst_inc)

  adate = tostring(ut_calendar(x,-3))
  print("--------------------------------------------------------------------------------")
  print("Checking for Stage-IV analysis date: "+adate)

; Obtaining analysis date information
  hour=str_get_cols(adate,8,9)
  ymd=toint(str_get_cols(adate,0,7))

;--------------------------------------------------------------
       st4_anl = data_path+"analyses/ST4."+ymd+hour+".06h.grb"
;       print("st4_anl: "+st4_anl)

       if (isfilepresent(st4_anl)) then
;          print("Stage-IV analysis file ST4."+ymd+hour+".06h.grb found!")
       else
          print("Stage-IV analysis file ST4."+ymd+hour+".06h.grb is missing")
          print("from "+data_path+"analyses/")
          print("*******")
          system("sleep 3")
       end if

  end do

end if












end do   ; end y (list of models to check for)


print("======================")
print("Script has finished!")
print("======================")


end



