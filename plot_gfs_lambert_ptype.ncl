; ===========================================
; Plots 4-panel for GFS evaluation
; Created by: Alicia M. Bentley
; Last updated: 9 June 2020
; ===========================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
; ===========================================
begin

print("======================")
print("Script has started!")
print("======================")

;================================================================

; Define casename
  if (isdefined("eventname")) then
        print("Eventname defined on command line: "+eventname)
        casename = eventname
  else
        print("No eventname defined on command line")
        casename = "eventname"
  end if

;==================================================================

; Define data_directory
  if (isdefined("images_path")) then
        print("images_path defined on command line: "+images_path)
        image_dir = images_path
  else
        print("No images_path defined on command line")
        image_dir = "images_path"
  end if

;==================================================================

; Pre-defined domain definitions
  minlatlist=(/15.0,35.0,25.0,31.0,40.0,25.5,35.0,42.0,41.0,34.0,40.0,34.0,24.5,12.5,10,20,1,-40,15,10,3/)
  maxlatlist=(/60.0,75.0,50.0,43.0,50.0,37.5,44.0,50.0,49.5,43.0,48.0,42.5,35.0,35,27,47.5,60,-1,62.5,29,35/)
  minlonlist=(/-135.0,160.0,-120,-125.0,-125.0,-108.0,-108.0,-110.0,-97.0,-97.0,-81.0,-86.0,-92.0,-105,-81,-95,110,137.5,-167.5,-171,-136/)
  maxlonlist=(/-60.0,250.0,-72.5,-105.0,-107.0,-90.0,-92.0,-95.0,-80.5,-83.0,-66.5,-72.0,-76.0,-72.5,-55,-57.5,179,192.5,-115,-141,-82/)
  regionlist=(/"us","ak","uszoom","sw","nw","t","cp","np","mw","ov","ne","ma","se","gom","pr","nwatl","wpac","spac","epac","hi","epactc"/)
  if (isdefined("scriptregion")) then
     if (scriptregion .eq. "new")
        print("New domain requested. Script will fail if the following variables are not defined with command line arguments: regionname, minlat, minlon, maxlat, maxlon.")
        scriptregion=regionname
     else
        print("Domain defined on command line: "+scriptregion)
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

;Obtaining GFSv16 fcst file
       parafile_gfs ="gfsv16."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
       if (isfilepresent(parafile_gfs)) then
          print("GFSv16 fcst file found!")
       else
          print("GFSv16 fcst file is missing...")
          system("pwd")
       end if

       para=addfile(parafile_gfs,"r")

; ----------------------------------------------------------------------------------

;Obtaining GFSv15 fcst file
       prodfile_gfs ="gfsv15."+ymdm+".t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2"
       if (isfilepresent(prodfile_gfs)) then
          print("GFSv15 fcst file found!")
       else
          print("GFSv15 fcst file is missing...")
          system("pwd")
       end if

       prod=addfile(prodfile_gfs,"r")

; ============================================================================
; ======================= Download data ======================================
; ============================================================================ 

    ptypesprod=new((/721,1440/),float)
    ptypespara=new((/721,1440/),float)
    isprecip=new((/721,1440/),float)

    if (fhours(h).eq.0) then
       tempprod=prod->TMP_P0_L103_GLL0({2},:,:)
       temppara=para->TMP_P0_L103_GLL0({2},:,:)
       ptypesprod(:,:)=where(tempprod.gt.0,0,ptypesprod(:,:))
       ptypespara(:,:)=where(tempprod.gt.0,0,ptypespara(:,:))
       tstring="P-Type (6-h avg)"

    else if (fhours(h).eq.6) then
       catsnowprod=prod->CSNOW_P8_L1_GLL0_avg
       catrainprod=prod->CRAIN_P8_L1_GLL0_avg
       catfrzrprod=prod->CFRZR_P8_L1_GLL0_avg
       caticepprod=prod->CICEP_P8_L1_GLL0_avg
       catsnowpara=para->CSNOW_P8_L1_GLL0_avg
       catrainpara=para->CRAIN_P8_L1_GLL0_avg
       catfrzrpara=para->CFRZR_P8_L1_GLL0_avg
       caticeppara=para->CICEP_P8_L1_GLL0_avg
       ptypesprod(:,:)=where(catsnowprod.eq.1,1,ptypesprod(:,:))
       ptypesprod(:,:)=where(catrainprod.eq.1,4,ptypesprod(:,:))
       ptypesprod(:,:)=where(catfrzrprod.eq.1,3,ptypesprod(:,:))
       ptypesprod(:,:)=where(caticepprod.eq.1,2,ptypesprod(:,:))
       ptypespara(:,:)=where(catsnowpara.eq.1,1,ptypespara(:,:))
       ptypespara(:,:)=where(catrainpara.eq.1,4,ptypespara(:,:))
       ptypespara(:,:)=where(catfrzrpara.eq.1,3,ptypespara(:,:))
       ptypespara(:,:)=where(caticeppara.eq.1,2,ptypespara(:,:))
       isprecip(:,:)=where((catsnowpara.ne.1).and.(catrainpara.ne.1).and.(catfrzrpara.ne.1).and.(caticeppara.ne.1),0,ptypespara(:,:))
       tstring="P-Type (6-h avg)"

    else
       catsnowprod=prod->CSNOW_P8_L1_GLL0_avg6h
       catrainprod=prod->CRAIN_P8_L1_GLL0_avg6h
       catfrzrprod=prod->CFRZR_P8_L1_GLL0_avg6h
       caticepprod=prod->CICEP_P8_L1_GLL0_avg6h
       catsnowpara=para->CSNOW_P8_L1_GLL0_avg6h
       catrainpara=para->CRAIN_P8_L1_GLL0_avg6h
       catfrzrpara=para->CFRZR_P8_L1_GLL0_avg6h
       caticeppara=para->CICEP_P8_L1_GLL0_avg6h
       ptypesprod(:,:)=where(catsnowprod.eq.1,1,ptypesprod(:,:))
       ptypesprod(:,:)=where(catrainprod.eq.1,4,ptypesprod(:,:))
       ptypesprod(:,:)=where(catfrzrprod.eq.1,3,ptypesprod(:,:))
       ptypesprod(:,:)=where(caticepprod.eq.1,2,ptypesprod(:,:))
       ptypespara(:,:)=where(catsnowpara.eq.1,1,ptypespara(:,:))
       ptypespara(:,:)=where(catrainpara.eq.1,4,ptypespara(:,:))
       ptypespara(:,:)=where(catfrzrpara.eq.1,3,ptypespara(:,:))
       ptypespara(:,:)=where(caticeppara.eq.1,2,ptypespara(:,:))
       isprecip(:,:)=where((catsnowpara.ne.1).and.(catrainpara.ne.1).and.(catfrzrpara.ne.1).and.(caticeppara.ne.1),0,ptypespara(:,:))
       tstring="P-Type (6-h avg)"
    end if
    end if

   dif=ptypesprod
   copy_VarCoords(tempprod,ptypesprod)
   copy_VarCoords(temppara,ptypespara)
   dif=ptypespara-ptypesprod
   dif(:,:)=where((isprecip.eq.0),0,dif(:,:))

   copy_VarCoords(tempprod,isprecip)

; ============================================================================
; ======================= Make plot ==========================================
; ============================================================================
plot_dir = image_dir+"/"+casename+"/images/"+scriptyyyymmddhh+"/"
system("mkdir -p "+plot_dir)

  wks  = gsn_open_wks("png", plot_dir+"/gfs_"+scriptregion+"_ptype_"+casename+"_"+sprinti("%0.1i",(h)))       
  ;gsn_define_colormap(wks,"BlueWhiteOrangeRed") 
  gsn_define_colormap(wks,"temp")
  ;gsn_define_colormap(wks,"MPL_jet") 

  plot=new(3,"graphic")

  res  = True

  res@mpMinLatF                = minlat
  res@mpMaxLatF                = maxlat
  res@mpMinLonF                = minlon
  res@mpMaxLonF                = maxlon

  res@lbLabelAlignment="BoxCenters"
  res@lbLabelStrings=(/"no precip (0)","snow (1)","ice pellets (2)","freezing rain (3)","rain (4)"/)
  ;res@mpOutlineBoundarySets="AllBoundaries"
  res@mpOutlineBoundarySets="GeophysicalAndUSStates"
  res@mpDataBaseVersion="MediumRes"
  res@gsnMaximize=True
  res@tmXBLabelFontHeightF=.008
  res@tmYLLabelFontHeightF=.008
  res@gsnRightString=tstring
  res@gsnAddCyclic=False
  res@gsnLeftString="GFS Fcst init "+hourm+"Z "+daym+" "+months(toint(monthm))+ " " +yearm+" valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  res@mpOutlineDrawOrder="PostDraw"
  res@mpFillColor="grey75"
  res@cnInfoLabelOn=False
  res@mpFillDrawOrder="PreDraw"
  res@cnLabelMasking=True
  res@mpGeophysicalLineColor="black"
  res@mpGeophysicalLineThicknessF=2.0
  res@mpNationalLineThicknessF=2.0
  ;res@cnFillMode="RasterFill"
  ;res@cnRasterSmoothingOn=True
  res@mpUSStateLineThicknessF=1.0
  res@mpCountyLineThicknessF=.5
  ;res@mpUSStateLineThicknessF=3.0
  res@mpNationalLineColor="black"
  res@mpUSStateLineColor="black"
  res@cnLineLabelsOn=False
  res@pmLabelBarHeightF=.05
  res@lbLabelFontHeightF=.008
  res@gsnLeftStringFontHeightF=.01
  res@gsnRightStringFontHeightF=.01
  res@cnFillOn=True
  res@cnFillColors=(/"transparent","deepskyblue1","darkorchid1","deeppink1","green3"/)
  res@mpFillOn=True
  res@cnFillMode="RasterFill"
  res@cnRasterSmoothingOn=False
  res@cnLevelSelectionMode="ExplicitLevels"
  res@cnLevels=(/0.5,1.5,2.5,3.5/)
  res@cnLinesOn=False
  res@mpLimitMode="LatLon"
  res@gsnDraw=False
  ;res@mpProjection="Mercator"
  res@mpProjection="LambertConformal"

  if scriptregion.eq."spac" then
     res@mpLambertParallel1F = -33.0         ; two parallels
     res@mpLambertParallel2F = -45.0
  else
     res@mpLambertParallel1F = 33.0         ; two parallels
     res@mpLambertParallel2F = 45.0
  end if

  res@mpLambertMeridianF  = -95.0        ; central meridian
  if scriptregion.eq."ak" .or. scriptregion.eq."epac" then
    res@mpLambertMeridianF  = 215.0        ; central meridian
  else if scriptregion.eq."wpac" then
    res@mpLambertMeridianF  = 145.0        ; central meridian
  else if scriptregion.eq."spac" then
    res@mpLambertMeridianF  = 160.0        ; central meridian
  else if scriptregion.eq."pr" then
    res@mpLambertMeridianF  = 294.0        ; central meridian
  else if scriptregion.eq."atl" then
    res@mpLambertMeridianF  = 355.0        ; central meridian
    res@gsnAddCyclic =  True
  else if scriptregion.eq."hi" then
    res@mpLambertMeridianF  = 202.0        ; central meridian
  else if scriptregion.eq."epactc" then
    res@mpLambertMeridianF  = 260.0        ; central meridian
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  res@mpLimitMode         = "LatLon"
  ;res@lbLabelStride=1
  res@cnLinesOn=False
  res@lbLabelAutoStride=True
  res@gsnFrame=False
   res@lbLabelBarOn=True
  if scriptregion.eq."us" then
    res@mpNationalLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF=2.0
  end if


  res@cnLineLabelInterval=1
  res@cnLineLabelDensityF=1.5
  plot(0) = gsn_csm_contour_map(wks,ptypesprod,res)       ; create a default plot

;---------------------------------------------------------------------

  res@gsnLeftString="GFSv16 fcst init. "+hourm+"Z "+daym+" "+months(toint(monthm))+ " " +yearm+" valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  plot(1) = gsn_csm_contour_map(wks,ptypespara,res)       ; create a default plot

;-------------------------------------------------

  resprecip=True
  resprecip=res
  resprecip@cnLevels:=(/0.5/)
  resprecip@cnFillColors:=(/"transparent","beige"/)
  resprecip@gsnLeftString="GFSv16 fcst minus GFSv15 fcst valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  resprecip@lbLabelStrings:=(/"no precip (GFSv16 fcst)","precip (GFSv16 fcst)"/)
  plot(2) = gsn_csm_contour_map(wks,isprecip,resprecip)       ; create a default plot

;------------------------------------------------

  resdif=True
  resdif=res
  delete(resdif@cnFillColors)
  resdif@cnFillColors=(/"blue3","dodgerblue","lightskyblue","transparent","transparent","lightsalmon","orangered2","red4"/)
  resdif@cnLevels:=(/-2.5,-1.5,-.5,0,.5,1.5,2.5/)
  resdif@lbLabelAlignment="BoxCenters"
  resdif@lbLabelStrings:=(/"-3","-2","-1","0","0","1","2","3"/)
  resdif@gsnLeftString=" "
  resdif@gsnRightString=" "
  resdif@lbOrientation = "vertical"
  resdif@pmLabelBarWidthF      = 0.065               ; default is shorter
  resdif@pmLabelBarHeightF     = 0.6               ; default is taller

delete(resdif@mpProjection)
delete(resdif@mpLimitMode)
delete(resdif@mpMinLonF)
delete(resdif@mpMaxLonF)
delete(resdif@mpMinLatF)
delete(resdif@mpMaxLatF)
delete(resdif@mpLambertMeridianF)
delete(resdif@mpLambertParallel1F)
delete(resdif@mpLambertParallel2F)
delete(resdif@mpOutlineDrawOrder)
delete(resdif@mpFillOn)
delete(resdif@mpDataBaseVersion)
delete(resdif@mpOutlineBoundarySets)
delete(resdif@mpGeophysicalLineColor)
delete(resdif@mpGeophysicalLineThicknessF)
delete(resdif@mpNationalLineColor)
delete(resdif@mpNationalLineThicknessF)
delete(resdif@mpUSStateLineColor)
delete(resdif@mpUSStateLineThicknessF)
delete(resdif@mpFillColor)
delete(resdif@mpFillDrawOrder)
delete(resdif@mpCountyLineThicknessF)

  plot_dif=gsn_csm_contour(wks,dif,resdif)
  overlay(plot(2),plot_dif)

;-------------------------------------------------

  resP=True
  resP@gsnMaximize=True
  resP@txFontHeightF=.012
  resP@gsnPanelLabelBar=False
  resP@gsnFrame=False
  gsn_panel(wks,plot,(/2,2/),resP)
 
print("Framing figure")
frame(wks)
print("Deleting workstation")
delete(wks)

system("convert "+plot_dir+"/gfs_"+scriptregion+"_ptype_"+casename+"_"+sprinti("%0.1i",(h))+".png -trim +repage "+plot_dir+"/gfs_"+scriptregion+"_ptype_"+casename+"_"+sprinti("%0.1i",(h))+".png")              

end do

;------------------------------------------------

print("======================")
print("Script has finished!")
print("======================")


end



