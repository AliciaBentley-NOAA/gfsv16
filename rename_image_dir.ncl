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

image_path = "/scratch2/NCEPDEV/stmp3/Alicia.Bentley/scripts/gfsv16/Dorian2019/images/"
beginyyyymmddhh = "2019082700"
endyyyymmddhh = "2019090600"
int_inc = 12

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

  sdate=tostring(ut_calendar(datestart,-3))
  edate=tostring(ut_calendar(dateend,-3))

  print(" ")
  print("Date of first initialized forecast: "+sdate)
  print("Date of last initialized forecast:  "+edate)
  print(" ")
  print("image_path: "+image_path)
  print(" ")

;================================================================

  prev = 0

  do x = dateend,datestart,toint(int_inc)

  idate = tostring(ut_calendar(x,-3))
  ymdh=toint(str_get_cols(idate,0,9))
;  print("ymdh: "+ymdh)

  if (prev .ge. 0) .and. (prev .lt. 10) then
     pXXX = "p00"+prev
  else if (prev .ge. 10) .and. (prev .lt. 100) then
     pXXX = "p0"+prev
  else if (prev .ge. 100) then
     pXXX = "p"+prev
  end if
  end if
  end if
;  print("pXXX: "+pXXX)

  print("Moving /"+ymdh+" to /"+pXXX)
  cmd = "mv "+image_path+ymdh+" "+image_path+pXXX 
  system(cmd)


  prev = prev + int_inc

  end do   ; end x (initialization dates)


print(" ")
print("======================")
print("Script has finished!")
print("======================")


end



