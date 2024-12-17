;;;
;; Collection of Sound making UDO's, Instruments, and Effects
;; Requires cslc.csd
;;;
printf_i "beginning loading Sounds.orc %f\n", 1, 1

;For Live audio... could be used by anything
gi_cslc_LiveTab  ftgen 0,0,32768 + 1,-2,0


gi_mpft1 ftgen 0,0,512,5,1,512,0.0001 ;used in marb UDO

;for bellpno
gicarfn ftgen 0, 0, 512,  10,  1, 0, 0.05, 0, 0.01
gimodfn ftgen 0, 0, 512,  10,  1, 0.1,0.3, 0.02,0.1

;for padoscil
gicusttable ftgen 5, 0, 16384, 8, -1, 2, 1, 4096, 0.1, 4096, -1, 7900, 1, 290, -1
giaftersawfn vco2init 1, 256
giaftertrifn vco2init 16, giaftersawfn
giaftersquarefn vco2init 8, giaftertrifn
giafterpulsefn vco2init 4, giaftersquarefn
giafterisaw vco2init 2, giafterpulsefn
giaftercust vco2init -gicusttable, giafterisaw, 1.05, 128, 2^16, gicusttable

;for basswobbler
gi_cubicb ftgen 0, 0, 512, 8, 0, 128, 1, 128, 0, 256, 0
gienvlpxrrise ftgen 0,0,129,-7,0,128, 1

;foraltfm
gi_altfm ftgen 0, 0, 17, 2, 0, .2, .3, 0.8, 1.0, 0.8, 0.5, 0.2, 0, -0.3, -0.5, -0.8, -1.0, -0.9, -0.7, -0.3, 0 ;casio
gitremtab ftgen 0,0,513,8,1,1,0,510,0,1,0.7

;for bassUV
gi_biexp ftgen 0, 0, 16384, 21, 5,1

;for deephas
gi_phasshape ftgen 0, 0, 16384, 6, 1, 16384*0.05, -0.1, 16384*0.35, -1, 16384*0.4, -0.75, 16384*0.2, 1; 0.5 128 1 128 0 129 -1

;;;for snare opcode, nreverb settings. These suit sr=48000. May need to adjust for other sr's.
giSnrcombs ftgen 0, 0, 16,   -2,  0.003, 0.003 * (7/4), 0.003 * (4/5) * 2, 0.003 * (11/16)*3, 1,0.3,0.2,0.1;
giSnralps ftgen 0, 0, 16,   -2,  0.0023, 0.005, 0.008, 0.0095, 0.011, 0.013, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0

;nice big sine for dfmb
gi_sine ftgen 0, 0, 16384,10,1

gi_cosine ftgen 0,0,16384,11,1,1
;used in dfma, grainfx, basswobbler

; Grainfx
gi_window ftgen 0, 0, 2048, 8, 0, 40, 0, 984, 1, 984, 0, 40, 0 

;;;For partfx
;                             loopstndx,lpend,mult, mult 
giptkslidst	ftgen	0, 0, 16, -2, 0, 0,   1 ;kslide
giptkslidend	ftgen	0, 0, 16, -2, 0, 0,   1 
giShapeRise     ftgen   0, 0, 8193, 16, 0, 8192, -5, 1 ; kenv
giShapeFall     ftgen   0, 0, 8193, 16, 1, 8192, -5, 0 ;
gidisttab	ftgen	0, 0, 512, -16, 6, 512, -4, 0	; kmask
gichannelmasks	ftgen	0, 0, 32, -2, 0,2,0.5,0.1,0.9,0.2,0.8,0.3,0.7,0.4,0.6,0.5,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1, 0.9, 0.4, 0.6;
;                                         0c   1L  2R 3-9s ->                   m pan10-18->18-26                                                |               29   
;;preset res functions for mverb
gk_mverb_shall[] fillarray 102, 435, 735, 76.8, 114, 669.2, 739.7, 843.6, 272.72, 114.3, 963.2, 250.3, 373.73, 842, 999, 621, 210, 183, 578, 313, 792, 159.3, 401.5, 733, 1010
gk_mverb_mhall[] fillarray 57.8,461.1,141.6,442.9,395.4,384.7,156.3,31.7,47.7,181.4,82.3,470.7,283.7,133.7,128.5,426.9,274.1,495,112.3,401.9,126.5,218.9,374.8,140.3,171.3
gk_mverb_lhall[] fillarray 23.24,100.43,45.58,105.62,226.26,65.66,216.33,32.41,244.91,84.61,349.42,134.08,444.19,51.83,32.42,42.73,125.7,83.25,23.83,170.28,116.83,40.96,53,78.42,29.42
gk_mverb_hhall[] fillarray 3.24,10.43,5.58,105.62,16.26,65.66,216.33,2.41,244.91,4.61,349.42,134.08,444.191,51.83,32.42,2.73,25.7,83.25,3.83,170.28,6.83,40.96,13,8.42,20.42
gk_mverb_infspc[] fillarray 3.24,10.43,5.58,105.62,16.26,65.66,216.33,2.41,244.91,4.61,349.42,134.08,444.191,51.83,32.42,2.73,25.7,83.25,3.83,170.28,6.83,40.96,13,8.42,20.42
gk_mverb_echo[] fillarray 200,2000,2,2000,200,2000,2,200,2,2000,2,200,2,200,2,2000,2,200,2,2000,200,2000,2,2000,200
gk_mverb_rl[] fillarray 4.4,10.8,33.9,77.23,243,3.1,7.5,26.68,64.9,111.11,2,5.5,17.3,53,97.2,3.6,7.53,26.75,67,113.2,4.57,10.67,33.25,75.3,248
gk_mverb_comb1[] fillarray 75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75
gk_mverb_comb2[] fillarray 275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275,275
gk_mverb_8ves[] fillarray 320,80,320,80,2560,640,40,2560,10240,80,2560,640,160,1280,160,640,5120,320,40,10240,1280,40,5120,320,160
gk_mverb_tritns[] fillarray 369.99,92.5,370,185,65.41,32.7,261.63,46.25,261.63,1046.5,739.99,1479.98,130.81,65.41,23.13,92.5,46.25,130.81,185,32.7,65.41,130.81,523.25,184.99,92.5
gk_mverb_dark[] fillarray 41,3.84,50.28,2.38,19.71,3.83,83.27,16.93,27.95,4.33,88.41,39.93,95.02,93.99,84.19,3.38,79.5,69.39,32.79,8.32,97.16,3.23,28.84,8.46,71.69
gk_mverb_met1[] fillarray 361.6,66.9,679.5,251.6,395.3,166.4,123.9,314.6,262.5,182.9,245.4,40.4,435.5,253.9,350.5,527.1,628.3,365.2,71.6,699.6,684.8,560.1,408.4,55.4,190
gk_mverb_weird1[] fillarray 246.96,246.84,246.92,247,246.88,164.83,164.79,164.81,164.85,164.77,138.58,138.57,138.59,138.61,138.6,196.06,195.97,196,196.03,195.94,2.35,6.62,3.38,5.01,2.67
gk_mverb_weird2[] fillarray 2,150.1,10.3,150.3,2.2,150.5,149.9,149.5,149.7,150.8,10.2,109.2,150,149.3,10.1,150.7,149.6,149.4,149.8,150.6,2.3,150.4,10,150.2,2.1
gk_mverb_weird3[] fillarray 880,587.33,18.35,523.25,987.77,698.46,12.98,9.72,10.91,739.99,19.45,9.18,8.18,8.66,20.6,783.99,11.56,10.3,12.25,659.25,932.33,554.36,17.32,622.25,830.6
gk_mverb_lcym1[] fillarray 562,4047,6112,4211,640,4333,661,6276,745,6399,860,6487,445,1011,915,1498,896,2720,4001,2912,3872,6144,4735,9920,2473
gk_mverb_lcym2[] fillarray 6154,4559,5043,4399,4740,3839,4829,3656,4649,2577,5106,4309,6343,3378,5478,3286,5269,4230,4122,3126,4026,3048,3965,2897,5806
gk_mverb_scym1[] fillarray 1868,1136,2557,934,1378,1421,487,2026,732,3485,1824,2715,2067,2269,1338,2756,891,689,3243,1580,1176,2312,1623,2514,2799
gk_mverb_scym2[] fillarray 1135,3815,1442,4126,1857,4623,250,2271,287,4681,5151,323,2573,381,2990,594,5323,627,5761,721,3147,3294,4367,3712,3599
gk_mverb_tcym[] fillarray 1699,2867,309,1871,3540,399,2047,3644,503,2920,3733,667,2196,4556,922,2269,4587,1037,2415,4430,1449,100,2720,1524,194
gk_mverb_gong[] fillarray 1397,7046,7145,7302,2803,7346,1395,2442,5618,2793,4198,11111,8845,2435,12675,4135,4693,5563,6715,6740,4733,9008,8700,10315,8957
gk_mverb_sgong[] fillarray 1150,2638,4630,1203,2875,4697,1257,547,2917,1357,644,3184,1908,717,3532,2014,780,3592,2089,991,3834,2167,1082,4280,2551
gk_mverb_met2[] fillarray 1538,3268,4500,4511,7620,1818,5762,1313,8902,8123,2222,7200,1435,2253,2345,7652,1111,3342,6671,5669,6359,1515,2626,9821,5589
gk_mverb_tubmet[] fillarray 5801,2555,1062,2988,1163,3191,3438,1266,5357,1391,1537,3870,6775,1752,162,316,1899,2141,520,6189,3957,771,4389,974,4870
gk_mverb_cowbell[] fillarray 43,427.33,469.63,636.8,879,1194.3,1285,1525,1605.7,1692.6,1834,1913.4,2058,2131.5,2553.4,2697.3,2845,2971,3094.5,3421.33,3517,3704,3824.36,4026,4103.5
gk_mverb_fcym[] fillarray 50.613,162.049,235.200,449.253,649.376,905.887,1472.145,1560.246,1620.714,1719.811,2011.201,2227.079,2321.843,2520.884,3645.568,3719.782,4519.738,5439.683,5550.825,5799.373,5887.881,5985.715,8391.483,8599.464,8742.274
gk_mverb_bell[] fillarray 1105.304,1103.750,1794.986,1953.592,2048.571,2151.073,2212.690,2294.689,2456.427,2479.858,2588.582,2939.855,3128.298,3338.705,3994.719,5093.901,5302.248,6016.276,6633.354,7061.309,7204.633,7280.145,7396.092,7451.345,7596.472
gk_mverb_chnball[] fillarray 50.613,162.049,235.200,449.253,649.376,905.887,1472.145,1560.246,1620.714,1719.811,2011.201,2227.079,2321.843,2520.884,3645.568,3719.782,4519.738,5439.683,5550.825,5799.373,5887.881,5985.715,8391.483,8599.464,8742.274
gk_mverb_cymcap[] fillarray 256.393,395.910,563.166,828.052,1184.536,1335.321,1546.818,1827.957,2480.316,2773.729,3196.038,3341.018,3464.887,3685.670,3978.220,4078.167,4271.071,4423.289,4519.296,4722.426,4897.136,5013.317,5107.348,5175.045,5274.198
gk_mverb_bakesht[] fillarray 62.317,165.692,274.382,348.507,415.855,471.671,528.891,558.866,656.594,775.976,876.664,982.164,1118.923,1247.646,1389.558,1512.517,1651.298,1753.110,1837.643,1905.806,1984.672,2048.393,2112.321,2181.847,2288.017
gk_mverb_fpan[] fillarray 53.066,203.032,479.499,543.879,743.276,801.769,892.304,960.408,1056.683,1207.074,1959.924,2512.418,2796.932,2962.237,4128.661,4757.159,5226.305,7228.675,8082.551,8150.188,8996.844,9060.971,9135.351,9440.564,10176.578
gk_mverb_squeak[] fillarray 59.069,633.891,735.346,829.804,1096.602,1281.328,1381.799,1457.992,1601.895,1736.677,1801.428,1882.553,2063.394,2141.092,2241.275,2423.967,2496.568,2740.324,3155.239,3228.240,3422.348,3571.240,3639.228,3668.764,3749.605
gk_mverb_trellace[] fillarray 62.266,120.836,185.376,299.858,459.254,540.377,640.285,831.450,895.198,991.975,1107.400,1266.421,1415.155,1466.344,1641.805,1747.948,1899.558,2223.494,2309.037,2359.031,2439.546,2524.965,2662.755,2801.177,2884.055
gk_mverb_mwrnch[] fillarray 1193.150,1501.169,1584.422,1760.128,1876.764,2057.868,2297.103,2900.218,3614.225,3719.350,3956.729,5413.109,6072.599,6354.645,6882.175,7042.264,7340.854,8751.580,9774.188,10410.871,10575.217,11393.946,15018.148,16121.814,18907.158

;arate calculation for dbamp
;used in movest
opcode dbamp2,a,a
   aval xin 
   xout log(abs(aval)) / 0.11512925
endop

opcode declick, a, ajjo
ain, irisetime, idectime, itype xin
irisetm = (irisetime == -1 ? 0.0001 : irisetime)
idectm = (idectime == -1 ? 0.05 : idectime)
aenv    transeg 0.0001, irisetm, itype, 1, p3 - (irisetm + idectm), 0, 1, idectm, itype, 0.0001
        xout ain * aenv         ; apply envelope and write output
endop



;declickr included in SetupLib.csd
;; opcode declickr, a, ajjoj
;; itie tival  
;; ain, irisetime, idectime, itype,iinvert xin
;; irisetm = (irisetime == -1 ? 0.003 : irisetime)
;; idectm = (idectime == -1 ? 0.08 : idectime)
;; if (iinvert != -1) then
;;     aenv1   transegr itie, 0.003, 0, 1, irisetm, -itype, iinvert, 0,0,iinvert,idectm, itype, 1
;;     aenv2   linseg 1, abs(p3)+idectm-0.004, 1, 0.004,(p3 < 0 ? 1:0);transegr 1,0,0,1,0.08,0,0
;;     aenv = aenv2 * aenv1
;;   else
;;     aenv    transegr itie, irisetm, itype, 1, 0, 0, 1, idectm, itype, 0
;; endif
;; xout ain * aenv         ; apply envelope and write output
;; endop


;stereo version 
opcode declickrst, aa, aajjoj
itie tival
ainL, ainR, irisetime, idectime, itype, iinvert xin
irisetm = (irisetime == -1 ? 0.003 : irisetime)
idectm = (idectime == -1 ? 0.08 : idectime)
if (iinvert != -1) then
    aenv1   transegr itie, 0.003, 0, 1, irisetm, -itype, iinvert, 0,0,iinvert,idectm, itype, 1
    aenv2   linseg 1, abs(p3)+idectm-0.004, 1, 0.004,(p3 < 0 ? 1:0);transegr 1,0,0,1,0.08,0,0
    aenv = aenv2 * aenv1
  else
    aenv    transegr itie, irisetm, itype, 1, 0, 0, 1, idectm, itype, 0
endif
xout ainL * aenv, ainR * aenv         ; apply envelope and write output
endop

;just a wrapper around declickr with predefined shapes
;fadeout: ishape >= 1,  fadein: ishape <= -1, fadein+out: 1 > ishape > 0, fadeout+in: -1 < ishape < 0    
;ishape == 0 == default: just declick the signal.
;iinvdec and iinvrise only mean something when using a u-shape envelope (-1 < ishape < 0)
;iinvdec specifies decaytime in seconds. iinvrise is a multiple of p3 for the attack time (ususally between 0 and 1)
;uses p3 and release segments, so be careful with other r units.
opcode envr, a, aooo
  ain, ishape, iinvdec, iinvrise xin
  if (ishape == 0) then    
    irise, idec, itype, iinvert = -1, -1, 0, -1 ;--
  elseif (ishape >= 1) then ;->
   irise, idec, itype, iinvert = -1, abs(p3)+(ishape - 1), -(ishape - 1), -1
  elseif (ishape <= -1) then ;<-
   irise, idec, itype, iinvert = abs(p3), 0.004, abs(ishape) - 1, -1
  elseif (ishape > 0) then ;<>
   irise, idec, itype, iinvert = abs(p3)*ishape, abs(p3)*ishape, ishape*7, -1
  elseif (ishape < 0) then ;><
    irise, idec, itype, iinvert = abs(p3 * (iinvrise == 0 ? 0.5:iinvrise)), (iinvdec == 0 ? abs(p3)*0.5:iinvdec), (1 - abs(ishape)) * 7, abs(ishape) ;
  else
    prints "shouldn't be here in envr"
  endif      

  ares declickr ain, irise, idec, itype, iinvert
  xout ares
endop

opcode envrst, aa, aaooo
  ainL,ainR, ishape, iinvdec, iinvrise xin
  if (ishape == 0) then    
    irise, idec, itype, iinvert = -1, -1, 0, -1 ;--
  elseif (ishape >= 1) then ;->
   irise, idec, itype, iinvert = -1, abs(p3)+(ishape - 1), -(ishape - 1), -1
  elseif (ishape <= -1) then ;<-
   irise, idec, itype, iinvert = abs(p3), 0.004, abs(ishape) - 1, -1
  elseif (ishape > 0) then ;<>
   irise, idec, itype, iinvert = abs(p3)*ishape, abs(p3)*ishape, ishape*7, -1
  elseif (ishape < 0) then ;><
    irise, idec, itype, iinvert = abs(p3 * (iinvrise == 0 ? 0.5:iinvrise)), (iinvdec == 0 ? abs(p3)*0.5:iinvdec), (1 - abs(ishape)) * 7, abs(ishape) ;
  else
    prints "shouldn't be here in envr"
  endif      
  aresL, aresR declickrst ainL, ainR,irise, idec, itype, iinvert; [, irisetime, idectime, itype, iinvert]
  xout aresL, aresR
endop

;reduces amplitude of an audio signal based on the number of currently active instruments.
;reduction is -kfac db every doubling of current instances. Default is -3db
;ktime smooths the changes to avoid clicks (defaults to 0.08 seconds)
;iinsnum is the instrument number to monitor (defaults to calling instrument p1. 0 monitors all instruments.)
opcode activedamp, a,aOOj
  asig, kfac,ktime, iinsnum xin
  setksmps 1
  iinsnum = (iinsnum == -1 ? p1 : iinsnum)
  kfac = (kfac == 0 ? -3:kfac)
  kinsnums active iinsnum, 0, 0
  kampfac2 = ampdbfs(log2(max(1,kinsnums)) * kfac); drop kfac db every doubling of instances
  asig *= lineto(kampfac2, limit:k(ktime, 0.008, 5))
  xout asig
endop

;buzzy brass sounds
opcode dfma, a,kkk
kamp, kcps, kmod xin

kmod limit kmod, 0, 1 ; can blow up Csound beyond this.
k1 = kmod*0.78

ksq            =         k1*k1
kmp            =         -2*k1
k2             =         1+ksq

;;;;;;                                                    
a2             gbuzz     abs(kmp), kcps,3,1,k1*3, gi_cosine, -tival();

a2 *= -1 ; for some reason, flipping the signal causes an amp buildup.
         ; when phase init is skipped.

a3             =         a2+k2 ; a3 is high (1.76) but stable
k3             =         sqrt((1-ksq)/(1+ksq))              ; AMP NORM. FUNC.
a1             oscili    k3,kcps,-1,-tival(); a1 is stable (0.8)

kshifter rspline -1 * kmod, kmod, (kmod + 1)*3, (kmod + 1) * 7

a3 pdhalfy a3, kshifter * 0.8, 0, 1; => this line is fine

a3 = a1/a3

;a3 *= linseg(-tival(),0.05,1)
asig           =         kamp*a3
xout asig
endop



opcode dfmb, a,kkk
kamp, kcps, kmod xin
kmod limit kmod, 0, 1.25
k1 = kmod*0.78
ksq            =         k1*k1
kmp            =         -2*k1
k2             =         1+ksq
knh = ceil((curvek(kmod, 0.9) * 10) + 1)
a2             buzz     kmp, kcps,knh,gi_sine,-1
a2 buthp a2, 20

a3             =         a2+k2
k3             =         sqrt((1-ksq)/(1+ksq))              ; AMP NORM. FUNC.
a1             oscili    k3,kcps;, gi_sine, -1
a3             =         a1/a3
kshifter rspline -1 * kmod, kmod, (kmod + 1)*3, (kmod + 1) * 7
a3 pdclip a3, k1*0.8, limit:k(kshifter, -1, 1), 1, 0.8
asig           =         kamp*a3
asig dcblock2 asig
xout asig
endop

;stereo ensemble originally based on Bob rhainey's ensembleChorus UDO
opcode ensemblest, aa, akjp
ain, kdepth, inumvoice, icount xin

inumvoice = (inumvoice == -1 ? 4:inumvoice) ;defaults to four voices
kdpscale = kdepth * 0.03
imax = 0.7

incr = 1/(inumvoice)

if (icount >= inumvoice) goto out
ainl, ainr ensemblest ain, kdepth, inumvoice, icount + 1
out:

    alfo rspline kdpscale*0.5, kdpscale, 1, 3

adel vdelay3 ain/(inumvoice * .5), alfo*1000, 4000

al = ainl + adel * incr * icount
ar = ainr + adel * (1 - incr * icount)
xout al, ar
clear ainl, ainr
	endop

opcode ensemble, a, ak
;ensemble from Sean Costello's string ensemble
asource,kvib xin
kvib *= 3 * .00025	; Determines amount of pitch change/vibrato/
			; chorusing. A value of 1 gives moderately thick 
ktimea	oscili	4, 0.33
ktimeb	oscili	4, 0.33, -1, .333
ktimec	oscili	4, 0.33, -1, .667
ktimed	oscili	1, 5.5
ktimee	oscili	1, 5.5, -1, .333
ktimef	oscili	1, 5.5, -1, .667

ktime1 = (ktimea + ktimed) * kvib
ktime2 = (ktimeb + ktimee) * kvib
ktime3 = (ktimec + ktimef) * kvib
adummy	delayr	.030
asig1	deltapi	ktime1 + .012
asig2	deltapi	ktime2 + .012
asig3 	deltapi	ktime3 + .012
	delayw	asource
aout = (asig1 + asig2 + asig3) * .33
xout aout
endop

;Using Sean Costello's string phaser shape.
;kspd is flange cycle in hz. Negative values allowed, and changes direction of flange.
;iphs is initial phase of shape
;note kord is actually i-time and must be > 1
;includes a degree of randomness
opcode deepphas1, a,akikjj
asource, kspd, iord, kfdbk, iphs, ishapefn xin
;gideepflangeshape ftgenonce 0, 0, 16384, 9, 0.5, -1, 0
iphs = (iphs == -1 ? 0.25:iphs)
ishapefn = (ishapefn == -1 ? gi_phasshape:ishapefn)
iord limit iord, 1, 4999

kfreq  = oscili(1500, kspd, ishapefn, iphs) + 1501
;kmod   = limit(kfreq + jspline:k(kfreq * 0.3, 1, 5), 5, 7000)
kmod   = kfreq + jspline:k(kfreq * 0.3, 1, 5)
aout phaser1 asource*0.6, kmod, k(iord), kfdbk, iphs
xout aout   
endop

;a barberpole version of deepphas1 (i.e. doesn't change direction)
opcode deepphas2, a,aKKK
asource, kspd, kord, kfdbk xin
gihalfsine ftgenonce 0, 0, 4097, 19, .5, 1, 0, 0 ; Half Sine
kord limit kord, 1, 4999
aexp, asaw1 ephasor kspd, 0.5
ksaw1 = k(asaw1)
ksaw3 wrap ksaw1 - 0.5, 0, 1 
ksaw1 curvek ksaw1, 0.83
ksaw3 curvek ksaw3, 0.83
asin1    oscili  1, kspd, gihalfsine, 0                ; 1/2 Sine 0 degrees
asin3    oscili  1, kspd, gihalfsine, .5            ; 1/2 Sine 180 degrees

asource *= 0.6
aouta phaser1 asource, ksaw1 * 5500 + 30, kord, kfdbk
aoutc phaser1 asource, ksaw3 * 5500 + 30, kord, kfdbk
aout maca aouta, asin1, aoutc, asin3
xout aout
endop

gk_cslc_startFollow init 0
opcode audiotablew, 0,ao
asig, itabaudio xin
;setksmps 1
itabaudio = (itabaudio == 0 ? gi_cslc_LiveTab:itabaudio)
ilivlen = tableng(itabaudio) 

gk_cslc_startFollow	tablewa	itabaudio, asig, 0;gk_cslc_startFollow - 5000      				; write audio a1 to table
gk_cslc_startFollow	= (gk_cslc_startFollow > (ilivlen-1) ? 0 : gk_cslc_startFollow)	; reset kstart when table is full
tablegpw itabaudio                                            ; update table guard point (for interpolation)
endop

opcode audiotabler, a, j
   itabaudio xin
   itabaudio = (itabaudio == -1 ? gi_cslc_LiveTab:itabaudio)
   ilivlen = tableng(gi_cslc_LiveTab) 
   ares oscili 1, 1/ilivlen, itabaudio
   ;ares tablera itabaudio, 0, 0;wrap(gk_cslc_startFollow - (sr * 1), 0, ilivlen)
   xout ares
endop



instr grainfxchanins
if mono()==1 then
    turnoff
endif
  
itabaudio = p4
asig chnget "grainfxchan"

audiotablew asig, itabaudio
chnset	gk_cslc_startFollow, "kstartFollow"
endin

;;a delay-line granulator effect
;; opcode grainfx, a,akkkkPPjj
opcode grainfx, a,akkkkPVoj
asig, kdens, kdur, kpitchrnd, kphasrand, ktranspose, kdelay, itabaudio, iwindow xin
   itabaudio = (itabaudio == 0 ? gi_cslc_LiveTab:itabaudio)
   iwindow = (iwindow == -1 ? gi_window:iwindow)
   iTablen tableng itabaudio
   idelay = max:i(i(kdelay), 0.5)    

   schedule "grainfxchanins", 0, p3, itabaudio

   chnset asig, "grainfxchan"

   kphs phasor 1 / (tableng:i(itabaudio) / sr)

   kpitchrnd = kpitchrnd * 0.2
   kpitchrnd curvek kpitchrnd, 0.68
   ares grain3 (sr/iTablen) * ((ktranspose/1) - 1), (gk_cslc_startFollow/tableng:i(itabaudio)) - kdelay, kpitchrnd, kphasrand, kdur, kdens, 3500, itabaudio, iwindow, 0.5, 0.5, 0, 24; was 24
   kampfac = ampdbfs(log2(max(1,(kdur*kdens))) * -3)
   ares *= kampfac
   ares limit ares, -1, 1
   ares *= madsr(0.05, 0.05, 1, 0.1, idelay)
xout ares
endop
;;rescales a linear value in a bipolar range around zero to a scalar equidistantly around 1. 
;;useful for adjusting a multipier equally on either side of '1'
;;e.g.
;;     val,amp   
;;bifac(2) = 2
;;bifac(-2) = 0.5
;;bifac(0.1) = 1.07
;;bifac(-0.1) = 0.934

opcode bifac, k, k
kval xin
if (kval < 0) then
   kout = 1 / (log2(abs(kval) + 2))
else
   kout = log2(abs(kval) + 2)
endif
xout kout
endop

opcode partfx, aa,akkOOPOOOOOo
asig, kdens, kdur, kpitchrnd, kphasrand, ktranspose,kchans,kslide,kgenv,krandommask,kfdbk,itabaudio xin
        itabaudio = (itabaudio == 0 ? gi_cslc_LiveTab:itabaudio)
        ktablen tableng itabaudio
        ktabpitch = 1/(ktablen / sr)

        ;feedback channel, careful!
        aFeed	chnget	"Fdbckchan"
        asig = asig + (aFeed*kfdbk)
        asig dcblock2 asig
        
       ;write input to table
        chnset asig, "grainfxchan"
        schedule 9, 0, p3, itabaudio
 
        if (kdur < 0) then
            kgdurs = 1/kdens
            kdurproc = kgdurs * bifac(rnd31:k(abs(kdur), 1))
        else 
            kdurproc = kdur
        endif 
	kduration	= (kdurproc*1000)

	ksamplepos1	= 0.02 ; delay latency 
	kpos1Deviation	randh kphasrand, kdens
	ksamplepos1	= ksamplepos1 + kpos1Deviation
	ksamplepos1	limit ksamplepos1, (kduration*ktranspose)/((ktablen/sr)*1000), 1

	kstartFollow 		chnget	"kstartFollow"					; the current buffer write position for live follow mode
	ksamplepos1 		= (kstartFollow/ktablen) - ksamplepos1		; move samplepos in parallel with the write pointer for the input buffer
	ksamplepos1		= (ksamplepos1 < 0 ? ksamplepos1+1 : ksamplepos1)	; wrap around on undershoot
	ksamplepos1		= (ksamplepos1 > 1 ? ksamplepos1-1 : ksamplepos1)	; wrap around on overshoot
	asamplepos1		upsamp ksamplepos1					; upsample

        if (kchans >= 0) then
           ;spread - reduce from 9;
           kstrtlp = round(9 - (kchans * 8))
           kndlp = 9  
        elseif (kchans == -4) then
           kstrtlp = 26
           kndlp = 29  
        elseif (kchans == -3) then
           ;C,L,R ;-3
           kstrtlp = 0
           kndlp = 2  
        elseif (kchans == -2) then
           ;LR    ;-2
           kstrtlp = 1
           kndlp = 2  
        elseif (kchans == -1) then
           kstrtlp = 10
           kndlp = 26  
        elseif (kchans < 0) then
           kresult rescalek kchans, 0, -1, 10, 26
           if (kchans > -0.5) then
           kstrtlp = kresult
           kndlp = 18  
           else 
           kstrtlp = 18
           kndlp = kresult  
           endif
        else
          ;centre
          kstrtlp = 0
          kndlp = 0  
          ;tablew 0, 0, gichannelmasks ;s
          ;tablew 0, 1, gichannelmasks ;e
        endif
        tablew kstrtlp, 0, gichannelmasks ;s
        tablew kndlp, 1, gichannelmasks ;e

        ;graingliss
        kslidest bifac -kslide 
        kslidend bifac kslide 
        tablew kslidest, 2, giptkslidst
        tablew kslidend, 2, giptkslidend
        
        ;pitch jitter
        kwavekey1 bifac jitter:k(kpitchrnd, 10,14)
        kwavekey2 bifac jitter:k(kpitchrnd, 12,22)
        kwavekey3 bifac  jitter:k(kpitchrnd, 30,42)
        kwavekey4 bifac jitter:k(kpitchrnd, 38,62)

	a1,a2	partikkel kdens, kphasrand, 
                          gidisttab, a(0),0, -1, giShapeRise, giShapeFall,
			  kgenv, 0.5, kduration,1,-1, 
			  ktranspose, 0.15, giptkslidst, giptkslidend, 
			  a(0), -1, -1, gi_cosine, 1, 1, 1, 
			  gichannelmasks, krandommask,
			  itabaudio, itabaudio, itabaudio, itabaudio,-1,
			  asamplepos1, asamplepos1, asamplepos1, asamplepos1, 
			  kwavekey1*ktabpitch, kwavekey2*ktabpitch, kwavekey3*ktabpitch, kwavekey4*ktabpitch,
			  500
        kampfac = ampdbfs(log2(max(1,(kdurproc*kdens))) * -3)
        a1 *= kampfac
        a2 *= kampfac
        afdSum sum a1,a2
        chnset afdSum, "Fdbckchan"
     xout a1, a2
 endop

;slightly modded from Eric Lyons Rev1.orc
opcode LyonRev1, aa,aakk
ain1, ain2, kmix, krevlen xin
  ;korig = 0.78 ; mix param
  kgain = sqrt(limit:k(kmix, 0.13, 1))
  krev = sqrt(1 - kmix)

  ;krevlen = 1 ;revlen param
  
        ; ain1 chnget "Rev1L"
        ; ain2 chnget "Rev1R"

  ain1 = ain1*kgain
  ain2 = ain2*kgain
  
  ajunk valpass ain1,1.7 * krevlen,oscil:k(0.003, 0.15) + 0.11, 0.3
  aleft valpass ajunk,1.01 * krevlen,oscil:k(0.0031, 0.11) + 0.0701, 0.1
  ajunk valpass ain2,1.05 * krevlen,oscil:k(0.0022, 0.28) + 0.205, 0.35
  aright valpass ajunk,1.33 * krevlen,oscil:k(0.0016, 0.341) + 0.05, 0.1
  
  kdel1 jspline 0.01, 0.555, 0.777
  kdel1 += 0.03
  kdel1b jspline 0.01, 0.555, 0.777
  kdel1b += 0.03

  addl1 delayr 0.3
  afeed1 deltap3 kdel1
  
  afeed1b deltap3 kdel1b
  
  afeed1 = (afeed1 + afeed1b) + (aleft*0.767)
  delayw aleft
  
  kdel2 jspline 0.01, 0.0555, 0.0877
  kdel2 += 0.02
  kdel2b jspline 0.01, 0.555, 0.777
  kdel2b += 0.03
  
  addl2 delayr 0.3
  afeed2 deltap3 kdel2

  afeed2b deltap3 kdel2b
  
  afeed2 = (afeed2 + afeed2b) + (aright*0.767)
  delayw aright
  
  aglobin = (afeed1+afeed2)*krev*0.5
  atap1 combinv aglobin,0.001,0.0909090909
  atap2 combinv aglobin,0.0021,0.04348
  atap3 combinv aglobin,0.0033,0.02439
  
  aglobrev nestedap atap1+atap2+atap3, 3, 1, 0.063, 0.11, 0.0027, 0.09, 0.0021, 0.07
  
  aglobrev tone aglobrev, 900
  
  kdel3 randi .003,1,0.888
  kdel3 =kdel3 + .05
  addl3 delayr .2
  agr1 deltap3 kdel3
  delayw aglobrev

  kdel4 randi .003,1,0.999
  kdel4 = kdel4 + 0.05
  addl4 delayr 0.2
  agr2 deltap3 kdel4
  delayw aglobrev  


  arevl = agr1+afeed1
  arevr = agr2+afeed2

  aoutl = (ain1*kgain)+(arevl*krev)
  aoutr = (ain2*kgain)+(arevr*krev)
  aoutl = buthp(aoutl, 20)
  aoutr = buthp(aoutr, 20)
  
xout aoutl*0.78, aoutr*0.78
endop
;;;;;;;;;;;;;;;;;;;;
;'uncabbaged' and modified udo's from mverb instrument
; by Jon Christopher Nelson, 2019 
;;;;;;;;;;;;;;;;;;;

;;;; alternative EQ opcode
opcode EQ,a,akk[] ;1 audio out, 1 audio in ;get k-rate data through chnget arguments
al,kQ,keqArr[]	xin
cggoto kQ == 1, bypass
keqArrtrunc[] truncarray keqArr, 9 
abal = al

aleq eqfil al,    75,  75*2,keqArrtrunc[0] * kQ
aleq eqfil aleq, 150, 150*2,keqArrtrunc[1] * kQ
aleq eqfil aleq, 300, 300*2,keqArrtrunc[2] * kQ
aleq eqfil aleq, 600, 600*2,keqArrtrunc[3] * kQ
aleq eqfil aleq,1200,1200*2,keqArrtrunc[4] * kQ
aleq eqfil aleq,2400,2400*2,keqArrtrunc[5] * kQ
aleq eqfil aleq,4800,4800*2,keqArrtrunc[6] * kQ
aleq eqfil aleq,9600,9600*2,keqArrtrunc[7] * kQ 
aleq   eqfil aleq,15000,10000*2,keqArrtrunc[8] * kQ
;and a high shelf?
al balance  al,abal
al dcblock2 al
bypass:
xout al
endop


opcode  meshEQ2,aaaa,aaaakkkk ;4 audio outs and 5 audio ins one k-rate in for FB value, use for boundary nodes
aUin,aRin,aDin,aLin,kres,kDFact,kFB,krsprd xin
afactor=(aUin+aRin+aDin+aLin)*-0.5	;calculate raw value

adel = a(kDFact*(1000/kres))
adel *= bifac:k(jspline:k(krsprd*0.25, 0.75 + (krsprd * 0.75), 4 + (krsprd * 4)))

aUout   vdelay  aUin+afactor,adel,1000	;calculate outputs
aRout   vdelay aRin+afactor,adel,1000
aDout   vdelay  aDin+afactor,adel,1000
aLout   vdelay  aLin+afactor,adel,1000

;too slow for realtime.
;aUout, aRout, aDout, aLout vdelayxq aUin+afactor, aRin+afactor, aDin+afactor, aLin+afactor, adel*1000, 1, 1024

;;;;Applying EQ is an expensive operation in meshverb.
;;;;skipping this for now
;; keqArr[] fillarray 0.5, 0.6, 0.7, 0.9, 0.7, 0.5
;; kQ = 0.5
;; aUout   EQ  aUout,kQ,keqArr   ;apply EQ on each output
;; aRout   EQ  aRout,kQ,keqArr
;; aDout   EQ  aDout,kQ,keqArr
;; aLout   EQ  aLout,kQ,keqArr

aUout   tone  aUout,7000 ;apply EQ on each output
aRout   tone  aRout,8000;kQ,keqArr
aDout   tone  aDout,5000;kQ,keqArr
aLout   tone  aLout,6500;kQ,keqArr

xout	aUout*kFB,aRout*kFB,aDout*kFB,aLout*kFB
endop

opcode mverb, aa, aakkkkkkk[]k
ainL,ainR,kDFact,kFB,kmix,kER,kERamp,krmax,kresArr[],kdelclear xin
;a    a    k     k    k   k   k      k     k[]       k         
if (lenarray(kresArr) == 25) then
   kresArrtrunc[] truncarray kresArr, 25
else
   kresArrtrunc[] truncarray kresArr, 25, 1.414
endif

aAU,aAR,aAD,aAL,
aBU,aBR,aBD,aBL,
aCU,aCR,aCD,aCL,
aDU,aDR,aDD,aDL,
aEU,aER,aED,aEL,
aFU,aFR,aFD,aFL init 0
aGU,aGR,aGD,aGL,
aHU,aHR,aHD,aHL,
aIU,aIR,aID,aIL,
aJU,aJR,aJD,aJL,
aKU,aKR,aKD,aKL,
aLU,aLR,aLD,aLL init 0
aMU,aMR,aMD,aML,
aNU,aNR,aND,aNL,
aOU,aOR,aOD,aOL,
aPU,aPR,aPD,aPL,
aQU,aQR,aQD,aQL,
aRU,aRR,aRD,aRL init 0
aSU,aSR,aSD,aSL,
aTU,aTR,aTD,aTL,
aUU,aUR,aUD,aUL,
aVU,aVR,aVD,aVL,
aWU,aWR,aWD,aWL,
aXU,aXR,aXD,aXL init 0
aYU,aYR,aYD,aYL init 0

;kDFact  chnget  "DFact"
kDFact  port    kDFact,0.25
;kFB chnget  "FB"
kFB port    kFB,0.25
;;;"clear delays" coefficient
kdelclear   port    kdelclear,.1
kFB=kFB*(1-kdelclear)

if kER=1 then   ;none
aL=0
aR=0
elseif kER=2 then   ;small
aL  multitap    ainL*kERamp,0.0070 , 0.5281 , 0.0156 , 0.5038 , 0.0233 , 0.3408 , 0.0287 , 0.1764 , 0.0362 , 0.2514 , 0.0427 , 0.1855 , 0.0475 , 0.2229 , 0.0526 , 0.1345 , 0.0567 , 0.1037 , 0.0616 , 0.0837 , 0.0658 , 0.0418 , 0.0687 , 0.0781 , 0.0727 , 0.0654 , 0.0762 , 0.0369 , 0.0796 , 0.0192 , 0.0817 , 0.0278 , 0.0839 , 0.0132 , 0.0862 , 0.0073 , 0.0888 , 0.0089 , 0.0909 , 0.0087 , 0.0924 , 0.0065 , 0.0937 , 0.0015 , 0.0957 , 0.0019 , 0.0968 , 0.0012 , 0.0982 , 0.0004
aR  multitap    ainR*kERamp,0.0097 , 0.3672 , 0.0147 , 0.3860 , 0.0208 , 0.4025 , 0.0274 , 0.3310 , 0.0339 , 0.2234 , 0.0383 , 0.1326 , 0.0441 , 0.1552 , 0.0477 , 0.1477 , 0.0533 , 0.2054 , 0.0582 , 0.1242 , 0.0631 , 0.0707 , 0.0678 , 0.1061 , 0.0702 , 0.0331 , 0.0735 , 0.0354 , 0.0758 , 0.0478 , 0.0778 , 0.0347 , 0.0814 , 0.0185 , 0.0836 , 0.0157 , 0.0855 , 0.0197 , 0.0877 , 0.0171 , 0.0902 , 0.0078 , 0.0915 , 0.0032 , 0.0929 , 0.0026 , 0.0947 , 0.0014 , 0.0958 , 0.0018 , 0.0973 , 0.0007 , 0.0990 , 0.0007
elseif kER=3 then   ;medium
aL  multitap    ainL*kERamp,0.0215 , 0.3607 , 0.0435 , 0.2480 , 0.0566 , 0.3229 , 0.0691 , 0.5000 , 0.0842 , 0.1881 , 0.1010 , 0.2056 , 0.1140 , 0.1224 , 0.1224 , 0.3358 , 0.1351 , 0.3195 , 0.1442 , 0.2803 , 0.1545 , 0.1909 , 0.1605 , 0.0535 , 0.1680 , 0.0722 , 0.1788 , 0.1138 , 0.1886 , 0.0467 , 0.1945 , 0.1731 , 0.2010 , 0.0580 , 0.2096 , 0.0392 , 0.2148 , 0.0314 , 0.2201 , 0.0301 , 0.2278 , 0.0798 , 0.2357 , 0.0421 , 0.2450 , 0.0208 , 0.2530 , 0.0484 , 0.2583 , 0.0525 , 0.2636 , 0.0335 , 0.2694 , 0.0311 , 0.2764 , 0.0455 , 0.2817 , 0.0362 , 0.2874 , 0.0252 , 0.2914 , 0.0113 , 0.2954 , 0.0207 , 0.2977 , 0.0120 , 0.3029 , 0.0067 , 0.3054 , 0.0094 , 0.3084 , 0.0135 , 0.3127 , 0.0095 , 0.3157 , 0.0111 , 0.3178 , 0.0036 , 0.3202 , 0.0064 , 0.3221 , 0.0025 , 0.3252 , 0.0016 , 0.3268 , 0.0051 , 0.3297 , 0.0029 , 0.3318 , 0.0038 , 0.3345 , 0.0016 , 0.3366 , 0.0013 , 0.3386 , 0.0009 , 0.3401 , 0.0019 , 0.3416 , 0.0012 , 0.3431 , 0.0015 , 0.3452 , 0.0011 , 0.3471 , 0.0007 , 0.3488 , 0.0003
aR  multitap    ainR*kERamp,0.0146 , 0.5281 , 0.0295 , 0.3325 , 0.0450 , 0.3889 , 0.0605 , 0.2096 , 0.0792 , 0.5082 , 0.0881 , 0.1798 , 0.1051 , 0.3287 , 0.1132 , 0.1872 , 0.1243 , 0.1184 , 0.1338 , 0.1134 , 0.1480 , 0.1400 , 0.1594 , 0.2602 , 0.1721 , 0.0610 , 0.1821 , 0.1736 , 0.1908 , 0.0738 , 0.1978 , 0.1547 , 0.2084 , 0.0842 , 0.2187 , 0.0505 , 0.2256 , 0.0906 , 0.2339 , 0.0996 , 0.2428 , 0.0490 , 0.2493 , 0.0186 , 0.2558 , 0.0164 , 0.2596 , 0.0179 , 0.2658 , 0.0298 , 0.2698 , 0.0343 , 0.2750 , 0.0107 , 0.2789 , 0.0417 , 0.2817 , 0.0235 , 0.2879 , 0.0238 , 0.2938 , 0.0202 , 0.2965 , 0.0242 , 0.3015 , 0.0209 , 0.3050 , 0.0139 , 0.3097 , 0.0039 , 0.3137 , 0.0039 , 0.3165 , 0.0096 , 0.3205 , 0.0073 , 0.3231 , 0.0052 , 0.3255 , 0.0069 , 0.3273 , 0.0044 , 0.3298 , 0.0041 , 0.3326 , 0.0026 , 0.3348 , 0.0028 , 0.3372 , 0.0014 , 0.3389 , 0.0023 , 0.3413 , 0.0012 , 0.3428 , 0.0014 , 0.3443 , 0.0006 , 0.3458 , 0.0003 , 0.3474 , 0.0004 , 0.3486 , 0.0005 
elseif kER=4 then   ;large
aL  multitap    ainL*kERamp,0.0473 , 0.1344 , 0.0725 , 0.5048 , 0.0997 , 0.2057 , 0.1359 , 0.2231 , 0.1716 , 0.4355 , 0.1963 , 0.1904 , 0.2168 , 0.2274 , 0.2508 , 0.0604 , 0.2660 , 0.1671 , 0.2808 , 0.1725 , 0.3023 , 0.0481 , 0.3154 , 0.1940 , 0.3371 , 0.0651 , 0.3579 , 0.0354 , 0.3718 , 0.0504 , 0.3935 , 0.1609 , 0.4041 , 0.1459 , 0.4166 , 0.1355 , 0.4344 , 0.0747 , 0.4524 , 0.0173 , 0.4602 , 0.0452 , 0.4679 , 0.0643 , 0.4795 , 0.0377 , 0.4897 , 0.0159 , 0.4968 , 0.0433 , 0.5104 , 0.0213 , 0.5170 , 0.0115 , 0.5282 , 0.0102 , 0.5390 , 0.0091 , 0.5451 , 0.0146 , 0.5552 , 0.0371 , 0.5594 , 0.0192 , 0.5667 , 0.0218 , 0.5740 , 0.0176 , 0.5806 , 0.0242 , 0.5871 , 0.0167 , 0.5931 , 0.0184 , 0.6000 , 0.0075 , 0.6063 , 0.0060 , 0.6121 , 0.0068 , 0.6149 , 0.0138 , 0.6183 , 0.0044 , 0.6217 , 0.0035 , 0.6243 , 0.0026 , 0.6274 , 0.0017 , 0.6295 , 0.0098 , 0.6321 , 0.0054 , 0.6352 , 0.0022 , 0.6380 , 0.0011 , 0.6414 , 0.0012 , 0.6432 , 0.0062 , 0.6462 , 0.0024 , 0.6478 , 0.0032 , 0.6506 , 0.0009
aR  multitap    ainR*kERamp,0.0271 , 0.5190 , 0.0558 , 0.1827 , 0.0776 , 0.3068 , 0.1186 , 0.2801 , 0.1421 , 0.1526 , 0.1698 , 0.3249 , 0.1918 , 0.1292 , 0.2178 , 0.2828 , 0.2432 , 0.1128 , 0.2743 , 0.1884 , 0.2947 , 0.2023 , 0.3121 , 0.1118 , 0.3338 , 0.0660 , 0.3462 , 0.0931 , 0.3680 , 0.1295 , 0.3889 , 0.1430 , 0.4040 , 0.0413 , 0.4218 , 0.1122 , 0.4381 , 0.1089 , 0.4553 , 0.0691 , 0.4718 , 0.0699 , 0.4832 , 0.0375 , 0.4925 , 0.0119 , 0.5065 , 0.0181 , 0.5180 , 0.0500 , 0.5281 , 0.0228 , 0.5365 , 0.0072 , 0.5458 , 0.0366 , 0.5520 , 0.0065 , 0.5597 , 0.0115 , 0.5644 , 0.0105 , 0.5724 , 0.0063 , 0.5801 , 0.0118 , 0.5836 , 0.0198 , 0.5886 , 0.0172 , 0.5938 , 0.0081 , 0.5987 , 0.0094 , 0.6033 , 0.0029 , 0.6060 , 0.0078 , 0.6096 , 0.0149 , 0.6122 , 0.0102 , 0.6171 , 0.0144 , 0.6204 , 0.0014 , 0.6243 , 0.0038 , 0.6284 , 0.0111 , 0.6309 , 0.0107 , 0.6338 , 0.0036 , 0.6374 , 0.0035 , 0.6401 , 0.0015 , 0.6417 , 0.0052 , 0.6433 , 0.0019 , 0.6461 , 0.0033 , 0.6485 , 0.0007 
elseif kER=5 then   ;huge
aL  multitap    ainL*kERamp,0.0588 , 0.6917 , 0.1383 , 0.2512 , 0.2158 , 0.5546 , 0.2586 , 0.2491 , 0.3078 , 0.1830 , 0.3731 , 0.3712 , 0.4214 , 0.1398 , 0.4622 , 0.1870 , 0.5004 , 0.1652 , 0.5365 , 0.2254 , 0.5604 , 0.1423 , 0.5950 , 0.1355 , 0.6233 , 0.1282 , 0.6486 , 0.1312 , 0.6725 , 0.1009 , 0.7063 , 0.0324 , 0.7380 , 0.0968 , 0.7602 , 0.0169 , 0.7854 , 0.0530 , 0.8097 , 0.0342 , 0.8303 , 0.0370 , 0.8404 , 0.0173 , 0.8587 , 0.0281 , 0.8741 , 0.0164 , 0.8825 , 0.0045 , 0.8945 , 0.0181 , 0.9063 , 0.0057 , 0.9136 , 0.0030 , 0.9214 , 0.0065 , 0.9296 , 0.0059 , 0.9373 , 0.0021 , 0.9462 , 0.0087 , 0.9541 , 0.0035 , 0.9605 , 0.0013 , 0.9648 , 0.0043 , 0.9691 , 0.0014 , 0.9746 , 0.0011 , 0.9774 , 0.0032 , 0.9818 , 0.0020 , 0.9853 , 0.0042 , 0.9889 , 0.0030 , 0.9923 , 0.0034 , 0.9941 , 0.0021 , 0.9976 , 0.0009 , 0.9986 , 0.0008
aR  multitap    ainR*kERamp,0.0665 , 0.4406 , 0.1335 , 0.6615 , 0.1848 , 0.2284 , 0.2579 , 0.4064 , 0.3293 , 0.1433 , 0.3756 , 0.3222 , 0.4157 , 0.3572 , 0.4686 , 0.3280 , 0.5206 , 0.1134 , 0.5461 , 0.0540 , 0.5867 , 0.0473 , 0.6281 , 0.1018 , 0.6516 , 0.1285 , 0.6709 , 0.0617 , 0.6979 , 0.0360 , 0.7173 , 0.1026 , 0.7481 , 0.0621 , 0.7690 , 0.0585 , 0.7943 , 0.0340 , 0.8072 , 0.0170 , 0.8177 , 0.0092 , 0.8345 , 0.0369 , 0.8511 , 0.0369 , 0.8621 , 0.0251 , 0.8740 , 0.0109 , 0.8849 , 0.0135 , 0.8956 , 0.0118 , 0.9026 , 0.0187 , 0.9110 , 0.0182 , 0.9225 , 0.0034 , 0.9310 , 0.0083 , 0.9354 , 0.0058 , 0.9420 , 0.0040 , 0.9464 , 0.0028 , 0.9549 , 0.0090 , 0.9590 , 0.0076 , 0.9654 , 0.0030 , 0.9691 , 0.0041 , 0.9729 , 0.0009 , 0.9757 , 0.0024 , 0.9787 , 0.0049 , 0.9823 , 0.0040 , 0.9847 , 0.0025 , 0.9898 , 0.0005 , 0.9922 , 0.0022 , 0.9935 , 0.0025 , 0.9964 , 0.0027 , 0.9992 , 0.0007 
elseif kER=6 then   ;long random 
aL  multitap    ainL*kERamp,0.0131 , 0.6191 , 0.0518 , 0.4595 , 0.0800 , 0.4688 , 0.2461 , 0.2679 , 0.3826 , 0.1198 , 0.5176 , 0.2924 , 0.6806 , 0.0293 , 0.8211 , 0.0327 , 1.0693 , 0.3318 , 1.2952 , 0.1426 , 1.3079 , 0.1021 , 1.4337 , 0.1293 , 1.4977 , 0.2383 , 1.6702 , 0.0181 , 1.7214 , 0.2042 , 1.8849 , 0.0780 , 2.1279 , 0.0160 , 2.2836 , 0.0061 , 2.4276 , 0.0390 , 2.5733 , 0.1090 , 2.7520 , 0.0047 , 2.8650 , 0.0077 , 3.1026 , 0.0005
aR  multitap    ainR*kERamp,0.1591 , 0.4892 , 0.2634 , 0.1430 , 0.3918 , 0.0978 , 0.5004 , 0.0675 , 0.7004 , 0.1285 , 0.7251 , 0.0251 , 0.9368 , 0.4531 , 1.0770 , 0.0022 , 1.1426 , 0.0132 , 1.3189 , 0.1608 , 1.3550 , 0.0512 , 1.4347 , 0.0224 , 1.4739 , 0.1401 , 1.6996 , 0.1680 , 1.9292 , 0.1481 , 2.1435 , 0.2463 , 2.1991 , 0.1748 , 2.3805 , 0.1802 , 2.4796 , 0.0105 , 2.6615 , 0.0049 , 2.8115 , 0.0517 , 2.9687 , 0.0468 , 2.9899 , 0.0095 , 3.1554 , 0.0496 
elseif kER=7 then   ;short backwards
aL  multitap    ainL*kERamp,0.0022 , 0.0070 , 0.0040 , 0.0014 , 0.0054 , 0.0120 , 0.0085 , 0.0075 , 0.0106 , 0.0156 , 0.0141 , 0.0089 , 0.0176 , 0.0083 , 0.0200 , 0.0227 , 0.0225 , 0.0189 , 0.0253 , 0.0121 , 0.0284 , 0.0118 , 0.0367 , 0.0193 , 0.0431 , 0.0163 , 0.0477 , 0.0260 , 0.0558 , 0.0259 , 0.0632 , 0.0515 , 0.0694 , 0.0266 , 0.0790 , 0.0279 , 0.0873 , 0.0712 , 0.1075 , 0.1212 , 0.1286 , 0.0938 , 0.1433 , 0.1305 , 0.1591 , 0.0929 , 0.1713 , 0.2410 , 0.1982 , 0.1409 , 0.2144 , 0.3512 , 0.2672 , 0.5038 , 0.3293 , 0.3827
aR  multitap    ainR*kERamp,0.0019 , 0.0107 , 0.0030 , 0.0031 , 0.0049 , 0.0068 , 0.0066 , 0.0050 , 0.0098 , 0.0090 , 0.0132 , 0.0080 , 0.0165 , 0.0085 , 0.0196 , 0.0071 , 0.0221 , 0.0143 , 0.0247 , 0.0086 , 0.0316 , 0.0164 , 0.0374 , 0.0160 , 0.0416 , 0.0110 , 0.0511 , 0.0167 , 0.0619 , 0.0191 , 0.0730 , 0.0233 , 0.0887 , 0.0313 , 0.1037 , 0.0484 , 0.1114 , 0.0912 , 0.1219 , 0.0980 , 0.1482 , 0.1220 , 0.1806 , 0.2021 , 0.2057 , 0.2059 , 0.2382 , 0.2379 , 0.2550 , 0.2536 , 0.3112 , 0.6474
elseif kER=8 then   ;long backwards
aL  multitap    ainL*kERamp,0.0021 , 0.0008 , 0.0050 , 0.0006 , 0.0065 , 0.0007 , 0.0092 , 0.0014 , 0.0124 , 0.0028 , 0.0145 , 0.0032 , 0.0166 , 0.0015 , 0.0225 , 0.0018 , 0.0294 , 0.0030 , 0.0345 , 0.0077 , 0.0405 , 0.0056 , 0.0454 , 0.0096 , 0.0508 , 0.0088 , 0.0593 , 0.0082 , 0.0643 , 0.0074 , 0.0743 , 0.0182 , 0.0874 , 0.0103 , 0.0986 , 0.0270 , 0.1143 , 0.0135 , 0.1370 , 0.0327 , 0.1633 , 0.0420 , 0.1823 , 0.0708 , 0.2028 , 0.0842 , 0.2258 , 0.0962 , 0.2482 , 0.0513 , 0.2856 , 0.1035 , 0.3132 , 0.1229 , 0.3398 , 0.0721 , 0.3742 , 0.0996 , 0.4199 , 0.1817 , 0.4914 , 0.3000 , 0.5557 , 0.1649 , 0.6181 , 0.4180 , 0.6689 , 0.5216 , 0.7310 , 0.5185
aR  multitap    ainR*kERamp,0.0024 , 0.0007 , 0.0053 , 0.0006 , 0.0090 , 0.0034 , 0.0138 , 0.0026 , 0.0196 , 0.0016 , 0.0250 , 0.0080 , 0.0292 , 0.0051 , 0.0346 , 0.0039 , 0.0409 , 0.0089 , 0.0459 , 0.0067 , 0.0589 , 0.0132 , 0.0702 , 0.0192 , 0.0781 , 0.0211 , 0.0964 , 0.0239 , 0.1052 , 0.0201 , 0.1212 , 0.0226 , 0.1428 , 0.0147 , 0.1547 , 0.0418 , 0.1849 , 0.0232 , 0.2110 , 0.0975 , 0.2425 , 0.0620 , 0.2851 , 0.0963 , 0.3366 , 0.1248 , 0.3645 , 0.1321 , 0.4079 , 0.1293 , 0.4433 , 0.1425 , 0.5031 , 0.3787 , 0.5416 , 0.5061 , 0.6336 , 0.2865 , 0.7434 , 0.6477
elseif kER=9 then   ;strange1
aL  multitap    ainL*kERamp,0.0137 , 0.2939 , 0.0763 , 0.8381 , 0.2189 , 0.7019 , 0.2531 , 0.2366 , 0.3822 , 0.3756 , 0.4670 , 0.0751 , 0.4821 , 0.0870 , 0.4930 , 0.0794 , 0.5087 , 0.1733 , 0.5633 , 0.0657 , 0.6078 , 0.0218 , 0.6410 , 0.0113 , 0.6473 , 0.0246 , 0.6575 , 0.0513 , 0.6669 , 0.0431 , 0.6693 , 0.0392 , 0.6916 , 0.0050 , 0.6997 , 0.0192 , 0.7091 , 0.0186 , 0.7174 , 0.0105 , 0.7284 , 0.0254 , 0.7366 , 0.0221 , 0.7390 , 0.0112 , 0.7446 , 0.0029 , 0.7470 , 0.0211 , 0.7495 , 0.0006
aR  multitap    ainR*kERamp,0.0036 , 0.0052 , 0.0069 , 0.0105 , 0.0096 , 0.0190 , 0.0138 , 0.0235 , 0.0150 , 0.0018 , 0.0231 , 0.0012 , 0.0340 , 0.0022 , 0.0355 , 0.0154 , 0.0415 , 0.0057 , 0.0538 , 0.0237 , 0.0722 , 0.0037 , 0.0839 , 0.0291 , 0.1027 , 0.0500 , 0.1163 , 0.0367 , 0.1375 , 0.0114 , 0.1749 , 0.0156 , 0.2002 , 0.0635 , 0.2215 , 0.0660 , 0.2777 , 0.0517 , 0.3481 , 0.1666 , 0.3871 , 0.2406 , 0.4851 , 0.1022 , 0.5305 , 0.2043 , 0.5910 , 0.4109 , 0.6346 , 0.5573 , 0.7212 , 0.5535 , 0.8981 , 0.5854 
elseif kER=10 then  ;strange2
aL  multitap    ainL*kERamp,0.0306 , 0.3604 , 0.2779 , 0.6327 , 0.3687 , 0.2979 , 0.5186 , 0.4202 , 0.6927 , 0.3695 , 0.7185 , 0.2370 , 0.8703 , 0.3283 , 0.9138 , 0.1334 , 0.9610 , 0.1183 , 1.0656 , 0.2089 , 1.1153 , 0.0835 , 1.1933 , 0.0954 , 1.1974 , 0.0609 , 1.2972 , 0.1078 , 1.3243 , 0.0720 , 1.3498 , 0.0840 , 1.4191 , 0.0694 , 1.4479 , 0.0572 , 1.4992 , 0.0449 , 1.5256 , 0.0186 , 1.5704 , 0.0470 , 1.5852 , 0.0202 , 1.6090 , 0.0106 , 1.6165 , 0.0302 , 1.6440 , 0.0204 , 1.6557 , 0.0042 , 1.6582 , 0.0223 , 1.6810 , 0.0054 , 1.6814 , 0.0064 , 1.6943 , 0.0075 , 1.6988 , 0.0032 , 1.7064 , 0.0027 , 1.7073 , 0.0064 , 1.7124 , 0.0091 , 1.7150 , 0.0015 , 1.7218 , 0.0043 , 1.7308 , 0.0116 , 1.7335 , 0.0122 , 1.7355 , 0.0011 , 1.7433 , 0.0154 , 1.7466 , 0.0084 , 1.7487 , 0.0139 , 1.7503 , 0.0123 , 1.7520 , 0.0036 , 1.7561 , 0.0097 , 1.7565 , 0.0041 , 1.7586 , 0.0016 , 1.7657 , 0.0132 , 1.7704 , 0.0038 , 1.7748 , 0.0020 , 1.7777 , 0.0053 , 1.7783 , 0.0056 , 1.7791 , 0.0017 , 1.7818 , 0.0058 , 1.7822 , 0.0089 , 1.7844 , 0.0074 , 1.7863 , 0.0009 , 1.7878 , 0.0016 , 1.7899 , 0.0061 , 1.7919 , 0.0073 , 1.7925 , 0.0025 , 1.7941 , 0.0045 , 1.7956 , 0.0060 , 1.7958 , 0.0088 , 1.7963 , 0.0010 , 1.7965 , 0.0006 , 1.7977 , 0.0078 , 1.7988 , 0.0026
aR  multitap    ainR*kERamp,0.0011 , 0.0055 , 0.0022 , 0.0063 , 0.0027 , 0.0089 , 0.0034 , 0.0009 , 0.0049 , 0.0010 , 0.0064 , 0.0005 , 0.0069 , 0.0044 , 0.0091 , 0.0027 , 0.0103 , 0.0099 , 0.0112 , 0.0017 , 0.0131 , 0.0018 , 0.0142 , 0.0008 , 0.0159 , 0.0010 , 0.0188 , 0.0034 , 0.0207 , 0.0055 , 0.0245 , 0.0005 , 0.0262 , 0.0094 , 0.0312 , 0.0057 , 0.0344 , 0.0051 , 0.0402 , 0.0044 , 0.0404 , 0.0102 , 0.0433 , 0.0044 , 0.0435 , 0.0034 , 0.0489 , 0.0087 , 0.0512 , 0.0108 , 0.0605 , 0.0046 , 0.0702 , 0.0010 , 0.0734 , 0.0121 , 0.0839 , 0.0135 , 0.0985 , 0.0151 , 0.1014 , 0.0203 , 0.1041 , 0.0043 , 0.1114 , 0.0150 , 0.1216 , 0.0182 , 0.1293 , 0.0220 , 0.1299 , 0.0169 , 0.1312 , 0.0046 , 0.1453 , 0.0046 , 0.1527 , 0.0062 , 0.1545 , 0.0192 , 0.1578 , 0.0092 , 0.1655 , 0.0053 , 0.1754 , 0.0301 , 0.1967 , 0.0122 , 0.2289 , 0.0233 , 0.2353 , 0.0131 , 0.2632 , 0.0396 , 0.2873 , 0.0171 , 0.3348 , 0.0454 , 0.3872 , 0.0398 , 0.4484 , 0.0244 , 0.4913 , 0.0693 , 0.5424 , 0.0820 , 0.5668 , 0.1112 , 0.6054 , 0.0635 , 0.6669 , 0.1016 , 0.7211 , 0.1217 , 0.7541 , 0.1756 , 0.8759 , 0.1688 , 0.9106 , 0.1932 , 1.0384 , 0.1542 , 1.0732 , 0.1598 , 1.0767 , 0.2409 , 1.0988 , 0.1879 , 1.2422 , 0.3049 , 1.3480 , 0.3001 , 1.4961 , 0.3374 , 1.5886 , 0.2791 , 1.5957 , 0.3366 , 1.8248 , 0.2962 
endif

aAU,aAR,aAD,aAL meshEQ2    aAU,aBL,aFU,aAL,kresArrtrunc[0],kDFact,kFB,krmax
aBU,aBR,aBD,aBL meshEQ2    aBU,aCL,aGU,aAR,kresArrtrunc[1],kDFact,kFB,krmax
aCU,aCR,aCD,aCL meshEQ2    aCU,aDL,aHU,aBR,kresArrtrunc[2],kDFact,kFB,krmax
aDU,aDR,aDD,aDL meshEQ2    aDU,aEL,aIU,aCR,kresArrtrunc[3],kDFact,kFB,krmax
aEU,aER,aED,aEL meshEQ2    aEU,aER,aJU,aDR,kresArrtrunc[4],kDFact,kFB,krmax
aFU,aFR,aFD,aFL meshEQ2    aAD,aGL,aKU,aFL,kresArrtrunc[5],kDFact,kFB,krmax;aGL is an output
aGU,aGR,aGD,aGL meshEQ2    aBD,aHL,aLU,aFR,kresArrtrunc[6],kDFact,kFB,krmax
aHU,aHR,aHD,aHL meshEQ2    aCD,aIL,aMU,aGR,kresArrtrunc[7],kDFact,kFB,krmax
aIU,aIR,aID,aIL meshEQ2    aDD,aJL,aNU,aHR,kresArrtrunc[8],kDFact,kFB,krmax
aJU,aJR,aJD,aJL meshEQ2    aED,aJR,aOU,aIR,kresArrtrunc[9],kDFact,kFB,krmax;aIR is an output
aKU,aKR,aKD,aKL meshEQ2    aFD,aLL,aPU,aKL,kresArrtrunc[10],kDFact,kFB,krmax
aLU,aLR,aLD,aLL meshEQ2   ainL+aL+aGD,aML,aQU,aKR,kresArrtrunc[11],kDFact,kFB,krmax;input
aMU,aMR,aMD,aML meshEQ2    aHD,aNL,aRU,aLR,kresArrtrunc[12],kDFact,kFB,krmax
aNU,aNR,aND,aNL meshEQ2    ainR+aR+aID,aOL,aSU,aMR,kresArrtrunc[13],kDFact,kFB,krmax;input
aOU,aOR,aOD,aOL meshEQ2    aJD,aOR,aTU,aNR,kresArrtrunc[14],kDFact,kFB,krmax
aPU,aPR,aPD,aPL meshEQ2    aKD,aQL,aUU,aPL,kresArrtrunc[15],kDFact,kFB,krmax
aQU,aQR,aQD,aQL meshEQ2    aLD,aRL,aVU,aPR,kresArrtrunc[16],kDFact,kFB,krmax
aRU,aRR,aRD,aRL meshEQ2    aMD,aSL,aWU,aQR,kresArrtrunc[17],kDFact,kFB,krmax
aSU,aSR,aSD,aSL meshEQ2    aND,aTL,aXU,aRR,kresArrtrunc[18],kDFact,kFB,krmax
aTU,aTR,aTD,aTL meshEQ2    aOD,aTR,aYU,aSR,kresArrtrunc[19],kDFact,kFB,krmax
aUU,aUR,aUD,aUL meshEQ2    aPD,aVL,aUD,aUL,kresArrtrunc[20],kDFact,kFB,krmax
aVU,aVR,aVD,aVL meshEQ2    aQD,aWL,aVD,aUR,kresArrtrunc[21],kDFact,kFB,krmax
aWU,aWR,aWD,aWL meshEQ2    aRD,aXL,aWD,aVR,kresArrtrunc[22],kDFact,kFB,krmax
aXU,aXR,aXD,aXL meshEQ2    aSD,aYL,aXD,aWR,kresArrtrunc[23],kDFact,kFB,krmax
aYU,aYR,aYD,aYL meshEQ2    aTD,aYR,aYD,aXR,kresArrtrunc[24],kDFact,kFB,krmax


aoutL=dcblock2(aGL)
aoutR=dcblock2(aIR)

amixL ntrpol ainL, aoutL, kmix 
amixR ntrpol ainR, aoutR, kmix 

xout amixL, amixR
endop

;;convenience wrappers
opcode mverb, aa, aakkkk[]JPOO
ainL,ainR,kDFact,kFB,kmix,kresArr[],kER,kERamp,krmax,kdelclear xin
kER = (kER == -1 ? 3:kER)
aoutL, aoutR mverb ainL,ainR,kDFact,kFB,kmix,kER,kERamp,krmax,kresArr,kdelclear
xout aoutL, aoutR
endop

;;single audio input
opcode mverb, aa, akkkk[]JPOO
ain,kDFact,kFB,kmix,kresArr[],kER,kERamp,krmax,kdelclear xin
kER = (kER == -1 ? 3:kER)
aoutL, aoutR mverb ain,ain,kDFact,kFB,kmix,kER,kERamp,krmax,kresArr,kdelclear
xout aoutL, aoutR
endop

;stereo pan + distance + doppler
;adist (source distance) and imicsep (microphone separation) in meters.
;aang in degrees (0 - 360)
opcode movest,aa,aaai
   asrc,adist,aang,imicsep xin
   imichalf = imicsep*0.5   

   asrcL = asrc
   asrcR = asrc

   adistL = sqrt(pow(imichalf,2) + pow(adist,2) - 2*imichalf*adist * cos((aang+90) * ($M_PI/180)))
   adistR = sqrt(pow(imichalf,2) + pow(adist,2) - 2*imichalf*adist * cos((180 - (aang+90)) * ($M_PI/180)))
   adistL = limit(adistL,0.18,100)
   adistR = limit(adistR,0.18,100)
   adelL = 0.008 * adistL
   adelR = 0.008 * adistR

   adelwing1 vdelayx asrcL, abs(adelL),0.8,64
   adelwing2 vdelayx asrcR, abs(adelR),0.8,64
    
   aflysigL        tone      adelwing1,(19000/(adistL*adistL*adistL)+1000),1 
   aflysigR        tone      adelwing2,(19000/(adistR*adistR*adistR)+1000),1 

   adistampL = ampdbfs(dbamp2(sqrt(1/(adistL^2))))
   adistampR = ampdbfs(dbamp2(sqrt(1/(adistR^2))))

   aleft          =         aflysigL*adistampL
   aright          =         aflysigR*adistampR  
  xout aleft, aright
endop

;convenience wrappers
opcode movest,aa,aiii
  asrc,idist,iang,imicsep xin
  adist = a(idist)
  aang = a(iang)
  aleft, aright movest asrc, adist,aang,imicsep
  xout aleft, aright
endop

opcode movest,aa,aiai
  asrc,idist,aang,imicsep xin
  adist = a(idist)
  aleft, aright movest asrc, adist,aang,imicsep
  xout aleft, aright
endop

opcode movest,aa,aaii
  asrc,adist,iang,imicsep xin
  aang = a(iang)
  aleft, aright movest asrc, adist,aang,imicsep
  xout aleft, aright
endop


;;Luca Pavan's Stereo Enhancer (1999)
;ipan : (0 = left, .5 = center, 1 = right)
;enh : "enhancing" level (0-1) [1=maximum]
opcode spreadst, aa, aakk
ainL, ainR, kamp, kenh xin
setksmps 1
;ipan   = p5  ;panning (0 = left, .5 = center, 1 = right) 
ipan = 0.5
ilev  = .01          ;feedback level
id    = 0            ;no delay
icomp = 1.3          ;amplitude compensatory factor

;==== ch1 ====
;asig1  soundin "test.wav", 0        ;use this line for mono input
;asig2 = asig1                        ;use this line for mono input
;asig1, asig1a soundin "C:/Audio/bryan/editg.wav", 0  ;use this line for stereo input
asig1 = ainL
asig1a = ainR

afil1   butterbp asig1, 50, 60
adel1   alpass afil1, id, ilev 
afil2   butterbp asig1, 200, 240
afil3   butterbp asig1, 800, 960
adel3   alpass afil3, id, ilev
afil4   butterbp asig1, 3200, 3840
afil5   butterbp asig1, 12800, 15360
adel5   alpass afil5, id, ilev
;==== ch2 ====
;asig2a, asig2 soundin "C:/Audio/bryan/editg.wav", 0  ;use this line for stereo input
asig2a  = ainL
asig2 = ainR

afil1a  butterbp asig2, 50, 60
afil2a  butterbp asig2, 200, 240
adel2a  alpass afil2a, id, ilev
afil3a  butterbp asig2, 800, 960
afil4a  butterbp asig2, 3200, 3840
adel4a  alpass afil4a, id, ilev
afil5a  butterbp asig2, 12800, 15360
;===========================================
aoutch1 = adel1+afil2+adel3+afil4+adel5
aoutch2 = afil1a+adel2a+afil3a+adel4a+afil5a
aoutch1m = (asig1 * (1 - kenh)) + (aoutch1 * kenh)
;aoutch2m = (asig1 * (1 - kenh)) + (aoutch2 * kenh) ;use this line for mono Input
aoutch2m = (asig2 * (1 - kenh)) + (aoutch2 * kenh) ;use this line for stereo in
aoutL = aoutch1m * sqrt(ipan) * kamp * icomp
aoutR = aoutch2m * sqrt(1 - ipan) * kamp * icomp

xout aoutL, aoutR
endop

opcode spreadst, aa, akk
ain, kamp, kenh xin
setksmps 1

;ilev  = .01          ;feedback level
ilev  = .01          ;feedback level
ipan = 0.5
id    = 0           ;no delay
icomp = 1.3          ;amplitude compensatory factor

asig1 = ain
asig2 = asig1                        ;use this line for mono input

afil1   butterbp asig1, 50, 60
adel1   alpass afil1, id, ilev 
afil2   butterbp asig1, 200, 240
afil3   butterbp asig1, 800, 960
adel3   alpass afil3, id, ilev
afil4   butterbp asig1, 3200, 3840
afil5   butterbp asig1, 12800, 15360
adel5   alpass afil5, id, ilev
;==== ch2 ====
;asig2a, asig2 soundin "C:/Audio/bryan/editg.wav", 0  ;use this line for stereo input
afil1a  butterbp asig2, 50, 60
afil2a  butterbp asig2, 200, 240
adel2a  alpass afil2a, id, ilev
afil3a  butterbp asig2, 800, 960
afil4a  butterbp asig2, 3200, 3840
adel4a  alpass afil4a, id, ilev
afil5a  butterbp asig2, 12800, 15360
;===========================================
aoutch1 = adel1+afil2+adel3+afil4+adel5
aoutch2 = afil1a+adel2a+afil3a+adel4a+afil5a
aoutch1m = (asig1 * (1 - kenh)) + (aoutch1 * kenh)
aoutch2m = (asig1 * (1 - kenh)) + (aoutch2 * kenh) ;use this line for mono Input
;aoutch2m = (asig2 * (1 - kenh)) + (aoutch2 * kenh) ;use this line for stereo in
aoutL = aoutch1m * sqrt(ipan) * kamp * icomp
aoutR = aoutch2m * sqrt(1 - ipan) * kamp * icomp

xout aoutL, aoutR
endop



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

opcode freqShift, a, ak
  ain, kfreq	xin

  ; Phase quadrature output derived from input signal.
  areal, aimag hilbert ain
  ; Sine table for quadrature oscillator.
  ;iSineTable ftgen	0, 0, 16384, 10, 1
  ; Quadrature oscillator.
  asin oscili 1, kfreq
  acos oscili 1, kfreq, -1, .25
  ; Use a trigonometric identity. 
  ; See the references for further details.
  amod1 = areal * acos
  amod2 = aimag * asin
  ; Both sum and difference frequencies can be 
  ; output at once.
  ; aupshift corresponds to the sum frequencies.
  aupshift = (amod1 + amod2) * 0.7
  ; adownshift corresponds to the difference frequencies. 
  adownshift = (amod1 - amod2) * 0.7
  ; Notice that the adding of the two together is
  ; identical to the output of ring modulation.
  xout aupshift
endop

opcode bellpno,a,kiippj
  kamp, ifrq, imod,ir1,ir2,ivib xin
  ivib = (ivib == -1 ? 0.4:ivib)
  ifq2   = ifrq*ir1
  ifq1   = ifrq*ir2          

  kvib vibr linseg:k(0, 0.45, 0, 0.01, 4), 5, -1

  aenv transeg i(kamp), p3-0.01, -(p3*i(kamp)), 0
  adyn  transeg ifq2*imod*i(kamp), p3, -1, 0.0
  
  amod  oscili  adyn, ifq2, gimodfn
  a1    oscili  kamp*aenv, (ifq1+amod) + (kvib * ivib), gicarfn

xout a1
endop




;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Slightly modified toms from Hans Mickelson, 1999
;;
opcode tomfm, a,iijjj
  iamp, ifqc, ihit, ifco, irez xin

  ihit = ((ihit == -1) ? 0.18:ihit)
  ihit = ihit + 0.01
  ifco = ((ifco == -1) ? 371:3000*tanh(tanh(ifco)))
  irez = ((irez == -1) ? 0.5:irez)
  irez = rescale(irez, 0, 1, 5, 70)

  ihamp = 120 * tanh(iamp)

  afqc1  expseg    1.9, ihit*0.5*abs(p3), 1.11, 0.2, 1 ; Pitch bend
  afqc   =         afqc1*afqc1                       ; Pitch bend squared
  aamp1  expseg    0.00001, 0.001, 1, abs(p3) - 0.08, 0.04,0.08-0.001,0.000001
  aamp2  expseg    0.00001, 0.001, 1, abs(p3) * ihit, 0.01 ; Noise envelope
  arnd1  noise      ihamp,0.5                          ; Genrate noise
  arnd   rezzy     arnd1, ifco, irez, 1           ; High pass mode 
  asig1   oscili     1,   afqc*ifqc*(1+arnd*aamp2); 
  asig2   oscili     1,   afqc*ifqc*(1.11+arnd*aamp2);,-1,-0.05; 
  asig ntrpol asig1, asig2, linseg:k(0.5,0.7,0.9)
  aout   =         asig*iamp*aamp1;*adclck         ; Apply amp envelope and declick
  aout buthp aout, 25

xout aout
endop



;;;;;;ekick UDO - 2021-01-04 TK
opcode ekick,a,kkVjjj
kamp,kpit,kdist,iheight,iholdlen,ideclen xin
iheight = (iheight == -1 ? 3:iheight)
iholdlen = (iholdlen == -1 ? 0.08:iholdlen)
ideclen = (ideclen == -1 ? 0.15:ideclen)
agliss transeg iheight,0.05,-1.5,1
aswp oscili kamp, kpit * agliss
aenv transeg 0, 0.005, 1, 1, iholdlen, 0, 1, ideclen, -1, 0 
aswp *= aenv
afiltgliss transeg iheight*2, ideclen, -1.5, 1, 0.08, 1, 0
anoise noise kamp*0.8, 0.6
anoise *= transeg:a(1, 0.005, 1, 0)
anoise += mpulse(kamp, 0, 0.002)
aswp += anoise
afilt lpf18 aswp, kpit*afiltgliss, aenv * 0.85, kdist
  aresult = afilt + anoise
  aresult = limit(aresult, -0dbfs*0.99, 0dbfs*0.99)
xout aresult 
endop

;based on a bass drum by Istvan Varga (kept the obfuscating variable names ;).
;Sounds good around 15hz
opcode bdrum, a,ii
  setksmps 1
  iamp, ipit xin
  iAM2s = 1.0
  ibtime = p3 * 3
  iamp = (185 * iamp) / pow((ipit ^ 2), 0.4)
  iAM1s = iamp * 8
  k_	port 1,ibtime/20,5.3333
  k__	port 1,ibtime/256,0.5
  kcps	=  ipit*k_*k__

  a_ rnd31 1,0
  a_	butterbp a_,kcps,0.0+kcps*0.25
  a0	=  a_

  k_	expseg 1,ibtime/1024,0.5
  k__	expseg 1,ibtime/4,0.5
  k_	=  (1-k_)*(1-iAM1s)+iAM1s
  k__	=  (1-k__)*(1-iAM2s)+iAM2s
  a0	=  a0*k_*k__
  a1	=  a0
  k_	port 0,ibtime/4,4
  a0	butterlp a0,kcps*k_

  a_	butterhp a1,kcps*1
  a_	butterlp a_,kcps*8
  k_	expseg 1,0.005,0.5
  a0      =  a0+1.5*a_*k_
  a0 = a0*iamp
  a0 clip a0,0,0dbfs

  xout a0
endop

opcode clap, a, ijjjj
   ;;example schedule 103, onbeat(0,4), tempodur(1)
   iamp, ifrq, ibw, iatt, idec xin

   iatt = (iatt == -1 ? 0.0001:iatt)
   idec = (idec == -1 ? 0.096:idec)

   ifrq = (ifrq == -1 ? 770:ifrq)
   ibw = (ibw == -1 ? 1555:ibw)

   asig	trirand iamp * 10.0
   asig1 butbp asig, ifrq, ibw
   asig1 butbp asig1, ifrq, ibw
   asig2 butbp asig, ifrq*2.5, ibw * 0.8 
   asig2 butbp asig2, ifrq*2.5, ibw * 0.8
   ares ntrpol asig1, asig2, 0.6
   kenv	transeg 0.0,  iatt, 3, 1.0,  idec, -4.5, 0.0, 0.1, 1, 0.0
   ares	= ares * kenv
   xout ares
endop


;;;;Snare UDO - 2020-11-25 TK
;kamp = amplitude,
;imode - 0 = hit, 1 = drumroll. default is 0 - hit.
;kfrq = not a precise pitch, but controlls the 'tuning' of the snare. Defaults to 145. Other values can be fun.
;kq = ;0 - 1 'tightness' of the skin. Defaults are either 0.68 for hit mode, or 0.01 for drumroll
;krevdec and krevres  = ;technically reverb time and diffusion amount,
                        ;but in this opcode sounds more like resonance time and colour of the drum
opcode snare, a, koJJJO
;defaults kamp, 0, 145, 145/35, 0.68/0.02, 0.68
kamp, imode, kfrq, kq, krevdec, krevres xin
setksmps 1
kfrq = (kfrq == -1 ? 145:kfrq)
kq = (kq == -1 ? (imode == 0 ? 145:35):kq)
krevdec = (krevdec == -1 ? (imode == 0 ? 0.68:0.02):krevdec)
krevres = (krevres == 0 ? 0.68:krevres)
afdbk init 0
ashock unirand kamp

if imode == 0 then
   ashock *= expseg:a(1, p3*0.15, 0.03, p3*0.35, 0.01)  ;hit mode
endif

  ares1 mode ashock + afdbk, kfrq, kq
  ares2 mode ashock + afdbk, kfrq * (9/4), kq 

  ares3 =  ares1 * ares2 * ashock
  ares3 buthp ares3, 25
  ares3     balance2 ares3, ashock
adistort    distort1 ares3, 8, 1, 0.2, 0.1

adistort *= 0.38
afdbk buthp adistort, 16

arevout nreverb adistort, krevdec, krevres, 0, 4, giSnrcombs, 6, giSnralps

aout = adistort + arevout*0.24 + ashock
aout dcblock2 aout

;some additional amplitude adjustments for using hits or rolls.
if (imode == 0) then ;hit
    aout *= expseg:a(1, p3 * 0.3, 0.07, p3 * 0.7, 0.001)
    aout *= 0.4
    aout = taninv(taninv(aout))
    aout *= kamp
elseif (imode == 1) then ;roll
   aout *= 0.02
   aout clip aout, 0, 0.99, 2
endif
aout = limit(aout, -0dbfs*0.99, 0dbfs*0.99)
xout aout
endop

;cymbal modified from a design by Istvan Varga
gicym1	ftgen 0, 0, 8, -2, 1.0000, 1.4471, 1.6170, 1.9265, 2.5028, 2.6637
gicym2	ftgen 0, 0, 32768, -27, 0, 0dbfs,1,0,16383,0,16384,-0dbfs,16385,0;, -32768, 0, 0, 32767, 0
;                                   x    y   x y  x    y  x      y     x    y
ifrq = 340
itrns[] init 6
itrndx = 0
until (itrndx >= lenarray(itrns)) do
      itr = int(0.5 + (ftlen(gicym2) * 2) / (sr / (ifrq * table(itrndx, gicym1))))
      itrns[itrndx] = itr
      itrndx += 1
od

gicym3	ftgen 0, 0, 65536, -31, gicym2, itrns[0], 1, 0, itrns[1], 1, 0,	\
				      itrns[2], 1, 0, itrns[3], 1, 0,	\
				      itrns[4], 1, 0, itrns[5], 1, 0

gicym4	ftgen 0, 0, 4096, 16, 1, 4096, -2, 0.0001

opcode cymbal, aaa, kPPp
kamp, kpitfac, kdens, iatt xin

if kdens < 0 then 
   kdens1 = abs(kdens)
   kdens2 = kdens1 
else
   kdens1 = linlin:k(kdens, 0.05, 200)
   kdens2 = linlin:k(kdens, 0.05, 500)
endif

a1	grain3 (sr / 65536) * kpitfac, 0.5, 0, 0.5, 0.2, kdens1, 100, gicym3, gicym4, 0, 0, 0, 18
a2l	grain3 sr / 65536 * kpitfac, 0.5, 0, 0.5, 0.04, kdens2, 100, gicym3, gicym4, 0, 0, 0, 18
a2r	grain3 sr / 65536 * kpitfac, 0.5, 0, 0.5, 0.04, kdens2, 100, gicym3, gicym4, 0, 0, 0, 18

a1	pareq a1, 500, 0, 1.5, 1
a2l	pareq a2l, 500, 0, 1.5, 1
a2r	pareq a2r, 500, 0, 1.5, 1
a1	butterbp a1, 11000, 7000
a1	butterlp a1, limit:i(sr/3, 100, sr/2)
a2l	butterlp a2l, limit:i(sr/2, 100, sr/2)
a2r	butterlp a2r, limit:i(sr/2, 100, sr/2)
a1 *= 2.5

;;attack
attk distort1 a1, 1.3, 1, 0.7, 0.2
attk limit attk, -0dbfs + 0.05, 0dbfs - 0.05
a1 ntrpol a1, attk, linseg:k(1 * iatt, 0.006, 0)

xout a2l * kamp * 100, a1 * kamp * 100, a2r * kamp * 100
endop

;convenience wrapper around cymbal. Stereo with enveloping.
opcode cymst,aa, kPPpp
kamp, kpitfac, kdens, ishape,iatt xin
aL, aC, aR cymbal kamp, kpitfac, kdens, iatt
aL,aR envrst aL,aR, ishape; [,ishape, iinvdec, iinvrise]
aC *= transeg(1, 0.15, -2, 0.3, p3-0.5, 1, 0)

aL *= abs(1 - iatt * 0.5)
aR *= abs(1 - iatt * 0.5)

aL = aL+aC
aR = aR+aC

xout aL,aR
endop

opcode cymmn,a, kPPpp
kamp, kpitfac, kdens, ishape,iatt xin
aL, aC, aR cymbal kamp, kpitfac, kdens, iatt
aL envr aL,ishape; [,ishape, iinvdec, iinvrise]
aC *= transeg(1, 0.15, -2, 0.3, p3-0.5, 1, 0)
aL *= abs(1 - iatt * 0.5)
aC += aL
xout aC
endop


opcode padoscilst, aa,kkkij
  kamp, kcps, kwidth, iwave, iovrlap xin
  ;aL, aR padoscil kamp, kcps, kwidth(0 - 1), iwave(0-4,-5)

  iovrlap = (iovrlap == -1 ? 45 : iovrlap)
  
  ; FM depth in Hz
  kfmd1	=  expcurve(kwidth, 15) * 0.25 * kcps  
  kfnum vco2ft kcps, iwave

  ;ares oscbnk   kcps, kamd, kfmd, kpmd, iovrlap, iseed, kl1minf, kl1maxf, kl2minf, kl2maxf, ilfomode, keqminf, keqmaxf, keqminl, keqmaxl, keqminq, keqmaxq, ieqmode, kfn [, il1fn] [, il2fn] [, ieqffn] [, ieqlfn] [, ieqqfn] [, itabl] [, ioutfn]
  a1    oscbnk   kcps, 1.0,  kfmd1, 0,   45,      rnd:i(100),   0.1,     6.7,     0.15,     0.8,       132,      0.1,       0.3,      0,       0,       0,       0,     -1,       kfnum, -1,        -1
  a2    oscbnk   kcps, 1.0,  kfmd1, 0,   45,      rnd:i(100),   0.1,     6.7,     0.17,     0.8  ,     132,      0.1,       0.3,      0,       0,       0,       0,     -1,       kfnum, -1,        -1

  if (iwave == 0) then
    iwvscale = 0.08
  elseif (iwave == 1) then
    iwvscale = 0.17
  elseif (iwave == 2) then
    iwvscale = 0.0051
  elseif (iwave == 3) then
    iwvscale = 0.05
  else 
    iwvscale = 0.1
  endif

  aoutL	=  a1 * iwvscale * kamp
  aoutR	=  a2 * iwvscale * kamp

  xout aoutL, aoutR

endop

;based on Iain McCurdy's uniform_wooden_bar from modeUDOs.csd, 2012
opcode	marb, a, iii
	iamp,ibasfrq, iqp	xin
        iamp    =       iamp * curve(ibasfrq / 600, 0.15)
	iq	=	140 

        ain  osciln iamp, iq*1.6, gi_mpft1,1
	amix	init	0
	kfrq	=	ibasfrq*1
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	kfrq	=	ibasfrq*2.572
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	kfrq	=	ibasfrq*4.644
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	kfrq	=	ibasfrq*6.984
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	kfrq	=	ibasfrq*9.723
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	kfrq	=	ibasfrq*12
	if sr/kfrq>=$M_PI then
	 asig	mode	ain, kfrq, iq*iqp
	 amix	=	amix + asig
	endif
	xout	amix*iamp*0.166667
	clear	amix
endop

opcode padoscil, a,kkkij
  kamp, kcps, kwidth, iwave, iovrlap xin
  ;ares padoscil kamp, kcps, kwidth(0 - 1), iwave(0-4,-5)

  iovrlap = (iovrlap == -1 ? 45 : iovrlap)

  ; FM depth in Hz
  kfmd1	=  expcurve(kwidth, 15) * 0.25 * kcps  
  kfnum vco2ft kcps, iwave

  ;ares oscbnk   kcps, kamd, kfmd, kpmd, iovrlap, iseed, kl1minf, kl1maxf, kl2minf, kl2maxf, ilfomode, keqminf, keqmaxf, keqminl, keqmaxl, keqminq, keqmaxq, ieqmode, kfn [, il1fn] [, il2fn] [, ieqffn] [, ieqlfn] [, ieqqfn] [, itabl] [, ioutfn]
  a1    oscbnk   kcps, 1.0,  kfmd1, 0,   iovrlap,  rnd:i(100),   0.1,     6.7,     0.15,     0.8,       132,      0.1,       0.3,      0,       0,       0,       0,     -1,       kfnum, -1,        -1

  if (iwave == 0) then
    iwvscale = 0.08
  elseif (iwave == 1) then
    iwvscale = 0.17
  elseif (iwave == 2) then
    iwvscale = 0.0051
  elseif (iwave == 3) then
    iwvscale = 0.05
  else 
    iwvscale = 0.1
  endif

  aout	=  a1 * iwvscale * kamp

xout aout

endop
;;used internally for simpadd
opcode genadditive, ak,kkiPOPpp
kamp, kfrq, inumvoice, katten, kstretch, kwarp, icnt, iphs xin
kwarp = abs(kwarp)
katten *= -1
kscale = kamp
kcnt = icnt * kwarp
  ares poscil (kfrq >= sr/2 ? 0:kamp), (kfrq >= sr/2 ? 0:kfrq), -1, rnd(iphs)
if (inumvoice > 0) then
   khz = kfrq * (kcnt+1)/kcnt
   kmodhz = khz * ((khz * 2) / khz) ^ abs(kstretch/(kcnt))
   anewsig, knewscale genadditive (kamp * (ampdbfs(katten * kcnt))), \
           kmodhz, inumvoice - 1, katten*-1, kstretch, kwarp, icnt + 1, iphs
   ares += anewsig
   kscale += knewscale
endif
xout ares, kscale
endop

;;;simple additive tone generator
;;;harmonic partials, with a stretch and a warp factor for special effects
;;;iphs makes partial phases random by default, which sounds slightly different
;;;to a constant phase. Constant phase can also cause amplitude spikes.
opcode simpadd, a, kkiPOPp
   kamp, kfrq, inumvoice, katten, kstretch, kwarp, iphs xin
   ares, kscale genadditive kamp, kfrq, inumvoice, katten, kstretch, kwarp, 1, iphs
xout ares * (kamp/kscale)
endop

opcode basswobbler, a,kkk
kamp, kcps, krate xin

  adeclick envlpxr 1, 0.002, 0,  gienvlpxrrise, 1, 0.01

  kwobbler = oscil3(0.5, krate) + 0.5
  ares1      gbuzz    kamp, kcps + jspline:k(kcps*0.00625, 0.2, 7.7), 8, 1, kwobbler, gi_cosine
  ares2      gbuzz    kamp, (kcps/2) + jspline:k(kcps*0.00625, 2.5, 3), 8, 2, kwobbler, gi_cosine
  ares3 distort ares1, (kwobbler + 0.1) * 2.3, gi_cubicb
  ares = (ares1 + (ares2 * 2) + ares3)
  ares = ares * adeclick

xout ares
endop

;From Iain McCurdy's collection
opcode	resony2,a,akkikooo
	ain, kbf, kbw, inum, ksep , isepmode, iscl, iskip xin

	;IF 'Octaves (Total)' MODE SELECTED...
	if isepmode==0 then
	 irescale	divz	inum,inum-1,1	;PREVENT ERROR IF NUMBER OF FILTERS = ZERO
	 ksep	=	ksep * irescale		;RESCALE SEPARATION
	  
	;IF 'Hertz' MODE SELECTED...	
	elseif isepmode==1 then
	 inum	=	inum + 1		;AMEND QUIRK WHEREBY NUMBER RESONANCES PRODUCED IN THIS MODE WOULD ACTUALLY BE 1 FEWER THAN THE VALUE DEMANDED
	 ksep	=	inum			;ksep IS NOT ESSESNTIAL IN THIS MODE, IT MERELY DOUBLES AS A BASE FREQUENCY CONTROL. THEREFORE SETTING IT TO NUMBER OF BANDS ENSURES THAT BASE FREQUENCY WILL ALWAYS BE DEFINED ACCURATELY BY kbf VALUE
			 
	;IF 'Octaves (Adjacent)' MODE SELECTED...
	elseif isepmode==2 then 
	 irescale	divz	inum,inum-1,1	;PREVENT ERROR IF NUMBER OF FILTERS = ZERO
	 ksep = ksep * irescale			;RESCALE SEPARATION
	 ksep = ksep * (inum-1)			;RESCALE SEPARATION INTERVAL ACCORDING TO THE NUMBER OF FILTERS CHOSEN
	 isepmode	=	0		;ESSENTIALLY WE ARE STILL USING MODE:0, JUST WITH THE ksep RESCALING OF THE PREVIOUS LINE ADDED	 

	endif
	
	aout 		resony 	ain, kbf, kbw, inum, ksep , isepmode, iscl, iskip
			xout	aout
endop

opcode bassUV, a,kkVVjoJ
  kamp, kfrq, kbw, ksep, inum, isub,kvco xin 
  ksep limit ksep, 0, 1
  inum = ((inum == -1) ? 5:inum)

  kbw = (kbw < 0.05 ? 0.05:kbw)

  kvco = (kvco < 0 ? 0.2:kvco)

  kenv = kamp
  asig1    pluck     kenv, kfrq, 32, gi_biexp, 4, 0, 2 - isub
  asig2 vco2 kenv*kamp, kfrq, 12
  asub vco2 kenv*kamp, kfrq*0.5, 12
  if (isub == 1) then
     asig2 ntrpol asig2, asub, 0.8 
  endif
  krespit expseg 3, abs(p3)*0.2, 0.5, abs(p3)*0.7, 0.2, abs(p3)*0.1,0.21;0.1
  asig1 resony2 asig1, krespit*kfrq, (krespit * kfrq)*expcurve(kbw, 48), inum, (logcurve(ksep, 0.01))*20, 0, 0
  asig1 tone asig1, 3000
  asig1    balance2 asig1, asig2
  asig ntrpol asig1, asig2, kvco
  aout = asig*0.8
  xout aout
endop

;basswood - A slightly natural sounding bass, with optional tone and distortion
;very high tone (around 12 - 20), sounds a bit like bass piano strings
;originally based on a model by Victor Lzzarini, instr 301 String resonator instrument.

;Linek written by Joachim Heintz in old CS UDO database 
opcode Linek, kk, kkkk
;performs a linear interpolation from kthis to knext in ktim whenever ktrig is 1
    kthis, knext, ktim, ktrig xin 
    kstat     init      0 ;status at the begin
    kfin      init      0
    knprd     =         round(ktim*kr) ;number of k-cycles for ktim
    ktimek    timek
     if ktrig == 1 then ;freeze values 
    kthistim  =         ktimek 
    kstrt     =         kthis
    kend      =         knext
    kstat     =         1
     endif
     if kstat == 0 then
    kval      =         kthis
     elseif kstat == 1 then
    kcount    =         ktimek-kthistim ;number of k-cycles in the time needed
    kinc      =         (kend-kstrt) / knprd ;increment
    kval      =         kstrt + kcount * kinc 
      if ktimek == kthistim+knprd then ;if target reached
    kfin      =         1 ;tell it
    kstat     =         2 ;set status
      else
    kfin      =         0
      endif
     elseif kstat == 2 then
    kval      =         kval ;stay at kval if no new trigger
    kfin      =         0
     endif
  xout      kval, kfin ;value and 1 if target reached
endop

opcode basswood, a, KKoo
        setksmps 1
	kamp, kfrq, itone, idistort xin
	idistort = limit:i(1 - idistort, 0.01, 1)
	kh = 0.03 * (sqrt(A4) / sqrt( kfrq*2 ) )

	kfilt = kfrq * curvek(1/sqrt(kfrq), 0.8) * (1+itone) * 700 

        asig    pinker
	asig	butlp asig, kfilt
	asig	butlp asig, kfilt*1
	asig	butlp asig, kfilt*1.665
	asig	butlp asig, kfilt*3

        ktrig init 1
        kenv, kfin Linek 1, 0, kh, ktrig
        ktrig = 0

	aout 	streson asig*kenv, kfrq/2, 0.996
	aout1 	streson asig*kenv, kfrq, 0.9997
	aout2   streson asig*kenv, kfrq * 1.003, 0.9997
	aout3   streson asig*kenv, kfrq * 2.005, 0.996
	aout4   streson asig*kenv, kfrq * 2.007, 0.997
	aout5   streson asig*kenv, kfrq * 2 ^ (9/8), 0.953

        aout sum aout*1, aout1*1.3, aout2, aout3, aout4, aout5

        aout *= (kamp/sqrt(kfrq)) * 10
        aout butterhp aout, 15

	aout	= aout
	aout	= aout * 0.776

        if (idistort < 1) then
           aout pdclip aout, (1 - idistort), 0, 1, 0.7
           aout *= limit:i(rescale:i((1 - idistort), 0, 1, 2,0.4), 0, 1.1)
        endif
        
        aout *= limit:i(rescale:i(itone, 0, 5, 1,0.7), 0.7, 1.1)
        aout clip aout, 0, 0.9, 0.8

        aout *= kamp
    xout aout
endop

opcode bassfm,a,kkk
kamp, kpit, kmod xin
kfmndx = 100*(2^kmod)/kpit ;richer harmonics with lower frequencies
kmndx = kfmndx * transeg:k(1,limit(abs(p3),0.5,7),-3,0.25)
aenv = mxadsr:a(0.007,0,1,0.2,0,0.1)
  ares foscili kamp,kpit,1,1,kmndx,-1
xout ares*aenv
endop


opcode slidefm,a,iiijo
iamp,ifrq,imodval,islidetime,ifn xin

  imod      rescale   imodval, 0, 1, 0, 1000

  if (islidetime <= 0) then
    islidetime = (abs(p3)) * 0.3
  else
    islidetime = tempodur(islidetime)
  endif

  ifn = (ifn == 0 ? gi_altfm:ifn)

  tigoto      tieinit

  ibegpitch   = ifrq
  iprevpitch  = ifrq
  ibegamp =  iamp
  iprevamp =  iamp
  ibegint	 =  imod
  iprevint =  imod
  ibegvib = 0
  iendvib = imodval

  goto        cont

  tieinit:

    ibegpitch   =       iprevpitch
    iprevpitch  =       ifrq
    ibegamp   	=       iprevamp
    iprevamp  	=       iamp
    ibegint		=		iprevint
    iprevint	=		imod
    ibegvib = iendvib
    iendvib = imodval

  cont:

    kvibcontour linseg ibegvib, abs(p3*0.3), ibegvib, abs(p3*0.5), iendvib
    kvib vibr kvibcontour, 5, -1
    kvib portk kvib, 0.08, -1

    kpitchenv   linseg  ibegpitch, islidetime, ifrq
    kampenv	transeg ibegamp, islidetime, 2, iamp 
    kintensity  transeg  ibegint, islidetime, 0.5, imod

    a1        oscili      kampenv + (kvib * 0.1), kpitchenv + kvib, -1, -1
    aout      oscili    kampenv, kpitchenv+(a1*kintensity), ifn, -1

xout aout
endop

opcode stringsfm,a,KKjj
kamp, kfqc, inoisdur, intens xin
  idur    = abs(p3)
  itie tival
  ireverse = 0
  if (itie == 1) then
    intens = 0
    inoisdur = 0
  else 
    if (intens == -1) then
      intens = 3
    else 
      if (intens < 0) then
         ireverse = 1
         intens = abs(intens)
      endif
      intens *= 10
    endif
    if (inoisdur == -1) then
       inoisdur limit idur*0.08, 0.05, 0.1
     else
       inoisdur limit  idur*inoisdur, 0.08, idur
   endif 
  endif    
  ;intens = (intens == -1 ? 3 : (intens * 10))
  kndx1   = 7.5/log(kfqc)    
  kndx2   = 15/sqrt(kfqc)    
  kndx3   = 1.25/sqrt(kfqc)  

  ktrans  linseg  (ireverse == 1 ? 0.1:intens),inoisdur,(ireverse == 1 ? intens:0.1),1,0.1

  anoise pinker
  attack  oscil  anoise*ktrans*0.3*kamp,kfqc*8
  kvibamp linseg 0, idur*0.3, 0, idur*0.4, 0.009, idur*0.3, 0
  kvibfrq linseg 0, idur*0.3, 5, idur*0.7, 3
  kvib vibr kvibamp, kvibfrq, -1
  
  amod1   oscil  kfqc*(kndx1+ktrans),kfqc*1.007, -1, (itie == 1 ? -1:0)
  amod2   oscil  kfqc*3*(kndx2+ktrans),kfqc*2.01, -1, (itie == 1 ? -1:0)
  amod3   oscil  kfqc*4*(kndx3+ktrans),kfqc*5, -1, (itie == 1 ? -1:0)
  asig    oscili  kamp,(kfqc+amod1+amod2+amod3)*(1+kvib), gi_altfm, (itie == 1 ? -1:0)
  asig2 = asig * attack
  asig = (asig + attack) * linseg(itie, limit(idur*0.1, 0.05, 0.1), 1, idur, 1)
  
  xout asig*0.8
endop

opcode wobstrings,a,KKjj
kamp, kfqc, itremrate, intens xin
  idur    = abs(p3)
  itie tival
  ireverse = 0
  intens *= 10
  kndx1   = 7.5/log(kfqc)    
  kndx2   = 15/sqrt(kfqc)    
  kndx3   = 1.25/sqrt(kfqc)  

  ktrans = oscili(intens,itremrate,gitremtab,0)
  ktrans = (ktrans*0.5) + 0.5

  anoise pinker
  attack  oscil  anoise*ktrans*0.3*kamp,kfqc*8
  kvibamp linseg 0, idur*0.3, 0, idur*0.4, 0.009, idur*0.3, 0
  kvibfrq linseg 0, idur*0.3, 5, idur*0.7, 3
  kvib vibr kvibamp, kvibfrq, -1
  
  amod1   oscil  kfqc*(kndx1+ktrans),kfqc*1.007, -1, (itie == 1 ? -1:0)
  amod2   oscil  kfqc*3*(kndx2+ktrans),kfqc*2.01, -1, (itie == 1 ? -1:0)
  amod3   oscil  kfqc*4*(kndx3+ktrans),kfqc*5, -1, (itie == 1 ? -1:0)
  asig    oscili  kamp,(kfqc+amod1+amod2+amod3)*(1+kvib), gi_altfm, (itie == 1 ? -1:0)
  asig2 = asig * attack
  asig = (asig + attack) * linseg(itie, limit(idur*0.1, 0.05, 0.1), 1, idur, 1)
  
  xout asig*0.8
endop



opcode simpleverb,a,apP
ain,itail,kmix xin
afdbk init 0
  ares1 nestedap ain+afdbk*0.4, 2, itail, 0.197*itail, 0.31, 0.123*itail, 0.21
  ares2 nestedap ares1*0.5, 2, itail, 0.1933*itail, 0.21, 0.115*itail, 0.11
afdbk butterbp ares1, 1000, 20,1
aout ntrpol ares2,ain,kmix
xout aout
endop

;hihat from by René Nyffenegger
opcode hihat,a,i
iamp xin
  kcutfreq  expon     10000, 0.1, 3500
  aamp      expseg    0.003,0.005,iamp,0.1,0.02
  arand     noise     aamp,0.3
  alp1      butterlp  arand,kcutfreq
  alp2      butterlp  alp1,kcutfreq
  ahp1      butterhp  alp2,3500
  asigpre   butterhp  ahp1,3500
  asig      linen    (asigpre+arand/2),0,abs(p3), .05  
  xout asig
endop

;e.g. ares multidel ares,fillarray(0.333, 0.125),0.9
opcode multidel,a,ak[]pOoo
ain,kdels[],iatten,kdur,imax,indx xin
imax = (imax == 0 ? 24 : imax) 
kdur = (kdur == 0 ? abs(p3) : kdur)
kdelval = kdels[indx % lenarray(kdels)]
kdeltm = tempodur_k(kdelval * 1000)
adeltm interp kdeltm
avdel vdelay ain, adeltm,7000
if (indx < imax) then
   if (kdur > kdelval) then
      avdel = avdel + multidel(avdel*iatten,kdels,iatten, kdur - kdelval,imax,indx + 1)
   endif
endif
xout avdel
endop

;a ringy reverb
opcode ringverb,a,apVp
ain,itail,kmix,idepth xin
afdbk init 0
imaxdepth = idepth
idepmod = curve(itail/idepth,0.27765)
idepth1a = curve(itail*0.197,0.5/imaxdepth) * idepmod
idepth2a = curve(itail*0.1232,0.5/imaxdepth) * idepmod
idepth1b = curve(itail*0.19311,0.5/imaxdepth) * idepmod
idepth2b = curve(itail*0.116,0.5/imaxdepth) * idepmod
  ares1 nestedap ain+afdbk*0.4, 2, imaxdepth, idepth1a, 0.31, idepth2a, 0.21
  ares2 nestedap ares1*0.5, 2, imaxdepth, idepth1b, 0.21, idepth2b, 0.11
afdbk tone ares1,7000*kmix
if idepth > 1 then
   ares3 ringverb ares1*0.9,itail,kmix*0.5,idepth-1
   ares2 = ares2+ares3
endif
aout ntrpol ares2,ain,kmix
xout aout
endop
;;;;;;;;;;;
;;Timpani - modal resonances
;;Based on a model from 'Timpani Drum Synthesis in MSoundfactory https://youtu.be/Fm3NxCDRk_M?si=koQqhDqfXSyjL37_
;;Chandler Guitar 
;;;;;;;;;;
gi_timpharms[] fillarray 1.00,1.51,2.03,2.88,3.53,4.01,4.34,4.77,5.38,5.77,6.27,6.74,7.36,7.73,8.04,8.34,8.87,9.14,9.44,9.87,10.30,10.79,11.42,12.03,12.75,13.28,13.95,14.44,14.77,15.23,15.71,16.16
gi_timpamps[] fillarray 0.00,-2.61,-10.5,-7.58,-21.1,-18.1,-3.45,-15.3,-10.5,-22.3,-11.4,-21.1,-21.9,-21.5,-26.5,-26.7,-26.5,-24.8,-27.2,-20.9,-31.1,-28.0,-24.2,-32.8,-25.3,-30.5,-29.4,-32.2,-29.4,-34.1,-32.3,-36.8

opcode timpani,a,iio
  iamp, ipit,iQ xin
  iamp limit iamp, 0,1.6
  iQ = (iQ == 0 ? 249:iQ)
  kamp = iamp*5
  kfrq linseg 8000,0.03,4000  
  ares    pluck     kamp, kfrq, ipit, gi_mpft1, 4, 0.4152,1.1373  
  ares lowres ares,linseg:k(1000,0.01,300),10
  ares0 mode ares*ampdbfs(gi_timpamps[0]),ipit*gi_timpharms[0]*transeg:k(semitone(-0.5),1,-2,semitone(0.08)),iQ
  ares1 mode ares*ampdbfs(gi_timpamps[1]),ipit*gi_timpharms[1],iQ
  ares2 mode ares*ampdbfs(gi_timpamps[2]),ipit*gi_timpharms[2],iQ
  ares3 mode ares*ampdbfs(gi_timpamps[3]),ipit*gi_timpharms[3],iQ
  ares4 mode ares*ampdbfs(gi_timpamps[4]),ipit*gi_timpharms[4],iQ
  ares5 mode ares*ampdbfs(gi_timpamps[5]),ipit*gi_timpharms[5],iQ
  ares6 mode ares*ampdbfs(gi_timpamps[6]),ipit*gi_timpharms[6],iQ
  ares7 mode ares*ampdbfs(gi_timpamps[7]),ipit*gi_timpharms[7],iQ
  ares8 mode ares*ampdbfs(gi_timpamps[8]),ipit*gi_timpharms[8],iQ
  ares9 mode ares*ampdbfs(gi_timpamps[9]),ipit*gi_timpharms[9],iQ
  ares10 mode ares*ampdbfs(gi_timpamps[10]),ipit*gi_timpharms[10],iQ  
  ares11 mode ares*ampdbfs(gi_timpamps[11]),ipit*gi_timpharms[11],iQ
  ares12 mode ares*ampdbfs(gi_timpamps[12]),ipit*gi_timpharms[12],iQ
  ares13 mode ares*ampdbfs(gi_timpamps[13]),ipit*gi_timpharms[13],iQ
  ares14 mode ares*ampdbfs(gi_timpamps[14]),ipit*gi_timpharms[14],iQ
  ares15 mode ares*ampdbfs(gi_timpamps[15]),ipit*gi_timpharms[15],iQ
  ares16 mode ares*ampdbfs(gi_timpamps[16]),ipit*gi_timpharms[16],iQ
  ares17 mode ares*ampdbfs(gi_timpamps[17]),ipit*gi_timpharms[17],iQ
  ares18 mode ares*ampdbfs(gi_timpamps[18]),ipit*gi_timpharms[18],iQ
  ares19 mode ares*ampdbfs(gi_timpamps[19]),ipit*gi_timpharms[19],iQ
  ares20 mode ares*ampdbfs(gi_timpamps[20]),ipit*gi_timpharms[20],iQ
  ares21 mode ares*ampdbfs(gi_timpamps[21]),ipit*gi_timpharms[21],iQ
  ares22 mode ares*ampdbfs(gi_timpamps[22]),ipit*gi_timpharms[22],iQ
  ares23 mode ares*ampdbfs(gi_timpamps[23]),ipit*gi_timpharms[23],iQ
  ares24 mode ares*ampdbfs(gi_timpamps[24]),ipit*gi_timpharms[24],iQ
  ares25 mode ares*ampdbfs(gi_timpamps[25]),ipit*gi_timpharms[25],iQ
  ares26 mode ares*ampdbfs(gi_timpamps[26]),ipit*gi_timpharms[26],iQ
  ares27 mode ares*ampdbfs(gi_timpamps[27]),ipit*gi_timpharms[27],iQ
  ares28 mode ares*ampdbfs(gi_timpamps[28]),ipit*gi_timpharms[28],iQ
  ares29 mode ares*ampdbfs(gi_timpamps[29]),ipit*gi_timpharms[29],iQ
  ares30 mode ares*ampdbfs(gi_timpamps[30]),ipit*gi_timpharms[30],iQ
  ares31 mode ares*ampdbfs(gi_timpamps[31]),ipit*gi_timpharms[31],iQ

  aout sum ares0,ares1,ares2,ares3,ares,ares5,ares6,ares7,ares8,ares9,ares10  ,ares11,ares12,ares13,ares14,ares15,ares16,ares17,ares18,ares19,ares20,ares21,ares22,ares23,ares24,ares25,ares26,ares27,ares28,ares29,ares30,ares31
  aout *= expseg:a(1,0.045,0.75,4,0.75)*0.03125
  aout lpf18 aout,iamp*2500,iamp*0.5,iamp*0.5
  aout *= linlin:i(iamp,1,3.7,65,130)
  aout clip aout,1,1
  xout aout
endop
;;;;
;; Sean Costello's Gong.
;;;;
opcode gong, aa,ijjjj
  iamp,ipit,if1,if2,itimbfn xin
  setksmps 1
  ipit = (ipit == -1 ? 127:ipit)
  if1 = (if1 == -1 ? 50:if1)
  if2 = (if2 == -1 ? 277:if2)
  
afilt1 init 0
afilt2 init 0
afilt3 init 0
afilt4 init 0
adel1 init 0
adel2 init 0
adel3 init 0
adel4 init 0
alimit1 init 0
alimit2 init 0
alimit3 init 0
alimit4 init 0
alimita init 0
alimitb init 0
alimitc init 0
alimitd init 0

anoise=0
ipi = 3.141592654
idel1 = 1/ipit
ilooptime = idel1 * 3
idel2 = 1/ipit * 2.25
idel3 = 1/ipit * 3.616
idel4 = 1/ipit * 5.06

ipitchmod = 0
idur = 3

ilimit1 = (1 - ipi * if1 / sr) / (1 + ipi * if1 / sr)
ilimit2 = (1 - ipi * if2 / sr) / (1 + ipi * if2 / sr)
; "strike" the gong.
  krandenv linseg 1, ilooptime, 1, 0, 0, idur-ilooptime, 0
    
anoise  oscili  krandenv * 1.2, ipit, itimbfn ;try gi_cosine for a harsh attack
igain = 0.999 * 0.70710678117      ; gain of reverb

k1      randi   .001, 3.1, .06
k2      randi   .0011, 3.5, .9
k3      randi   .0017, 1.11, .7
k4      randi   .0006, 3.973, .3

adum1   delayr  1
adel1a  deltap3 idel1 + k1 * ipitchmod
        delayw  anoise + afilt2 + afilt3

kdel1 downsamp adel1a
        if kdel1 < 0 goto or
        klimit1 = ilimit1
        goto next
or:
        klimit1 = ilimit2
        next:
        ax1     delay1  adel1a
        adel1 = klimit1 * (adel1a + adel1) - ax1

; Repeat the above for the next 3 delay lines.
adum2   delayr  1
adel2a  deltap3 idel2 + k2 * ipitchmod
        delayw  anoise - afilt1 - afilt4

kdel2 downsamp adel2a
        if kdel2 < 0 goto or2
        klimit2 = ilimit1
        goto next2
or2:
        klimit2 = ilimit2
        next2:
        ax2     delay1  adel2a
        adel2 = klimit2 * (adel2a + adel2) - ax2

adum3   delayr  1
adel3a  deltap3 idel3 + k3 * ipitchmod
        delayw  anoise + afilt1 - afilt4

kdel3 downsamp adel3a
        if kdel3 < 0 goto or3
        klimit3 = ilimit1
        goto next3
or3:
        klimit3 = ilimit2
        next3:
        ax3     delay1  adel3a
        adel3 = klimit3 * (adel3a + adel3) - ax3

adum4   delayr  1
adel4a  deltap3 idel4 + k4 * ipitchmod
        delayw  anoise + afilt2 - afilt3

kdel4 downsamp adel4a
        if kdel4 < 0 goto or4
        klimit4 = ilimit1
        goto next4
or4:
        klimit4 = ilimit2
        next4:
        ax4     delay1  adel4a
        adel4 = klimit4 * (adel4a + adel4) - ax4

afilt1  tone    adel1 * igain, 20000
afilt2  tone    adel2 * igain, 20000
afilt3  tone    adel3 * igain, 20000
afilt4  tone    adel4 * igain, 20000

aoutl =  (afilt1 + afilt3) * iamp
aoutr =  (afilt2 + afilt4) * iamp

aoutl dcblock aoutl
aoutr dcblock aoutr
	    
xout aoutl, aoutr
endop

;;;;;;;;;;;;;;;;;;
;; delayfray
;; adapted from Philipp Nuemann's recursive delayArray UDO (June 10, 2023).
opcode delayfray, a, akkOpp
  setksmps 1
  aDelIn, kDelTime, kFdbk, kfilt,iInstances, iDelBuf xin 
  kNextDel = kDelTime+(kDelTime/iInstances/1.5)
  aDelDump delayr iDelBuf
  aDelTap deltap kDelTime 
  delayw aDelIn + (aDelTap * kFdbk)

  aDelOut limit aDelTap, -1, 1

  if iInstances > 1 then
    aDelfilt  clfilt aDelOut,263,1,6,1,4
    aDelcopy ntrpol aDelOut, aDelfilt, kfilt
    aDelOut += delayfray(aDelcopy, kNextDel, kFdbk, kfilt,iInstances-1, iDelBuf)
  endif
  aDelOut limit aDelOut, -1, 1
  xout aDelOut
endop


printf_i "finished loading Sounds.orc %f\n", 1, 1

