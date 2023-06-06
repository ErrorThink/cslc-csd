<CsoundSynthesizer>
<CsOptions>
-odac --port=8099 --sample-rate=48000 --ksmps=64 --nchnls=2 --0dbfs=1 --nodisplays --messagelevel=1120 --omacro:SOUNDLIB=Sounds.orc
</CsOptions>
<CsVersion>
After 6.18
</CsVersion>
<CsInstruments>
/*cslc.csd
A library of UDO's and intruments to support live coding.

Dependencies: 
Csound with UDP port 8099 open.  

USAGE:
Code can be received on UDP port 8099 (or whatever --port is set to in CsOptions).
Some instrument numbers are reserved and should be avoided: 1 - 10,299,300,301   
To use the instruments in Sounds.orc, uncomment the commandline flag above:
`--omacro:SOUNDLIB=Sounds.orc`
And save Sounds.orc in your $INCDIR path, (or same directory as cslc.csd) 
The 'patch' feature requires named instruments.
All UDO's have i-time versions. This allows them to be used in csound global space (outside instrument defenitions)

FEATURES / UDO's:
Patch and send audio between instruments on-the-fly. (See patch* UDO's)
Microtonal support (See Microtonal)
Effect instrument generation (See Effects)
Rhythm helpers
Event generators
An assortment of other utilities and helpers.

Private UDO names are prefixed with the form
_cslc_<name> e.g. _cslc_loopmaster
These UDO's are used within other UDO's. It is not expected that users would use these UDO's in performance (although nothing strictly prohibits this).

Private variable names use the format
rate_cslc_<name> e.g. gk_cslc_tempo

Public UDO names haven't been pseudo namespaced, largely to assist with the convenience of live coding.
However be wary of name clashes / overloading.

Public UDO's:
;;;;;;;;;;;;;;;;
;; RHYTHM
A clock (gk_now) begins running when performance starts.
The clock value is meaured in bpm. 
A 'beat' can be considered as a round number in the clock.
---
now - the current value of the clock 
temposet - set the speed of the clock in bpm
tempoget - get the speed of the clock in bpm
tempodur/tempodur_k - return the duration in seconds for the clock time duration. 
nextbeat - returns the time interval in seconds for the clock to reach the beat n beats from now.
onbeat - returns the time interval in seconds for the clock to reach the next beat n in a bar.
nextrh - yield the duration to the next beat in an array on successive calls.
euclidean/euclidean_i - Use a euclidean rhythm algorithm to return an array of rhythm values

;;;;;;;;;;;;;;;;
;; MICROTONAL
Scales are stored in tables in a format suitable for the cpstun/i opcodes.
Two tables are always available: gi_SuperScale, and gi_CurrentScale
Many UDO's (such as the event generators will reference the scales set in these tables)
Typically, one would put a complete temperament in gi_Superscale (e.g. a chromatic scale). 
A subset of that temperament is then placed in gi_CurrentScale (e.g. a major scale)

Many of the supplied scale tables set degree '0' at 263 cps. 

Tbedn - Generate a table of equidistant degrees per period
cpstun3 - return values from a scale table
cps2deg - returns the nearest scale value to the value given in cps pitch.
sclbend - returns the cps pitch when given a scale degree and a modifier (pitchbend) channel.
passing - returns an interpolated array of from a subset of scale degrees.
scalemode - Sets gi_CurrentScale to a mode from gi_SuperScale.
scaleModulate - Shifts and rotates the interval pattern in gi_CurrentScale
scalemode31 - Sets gi_CurrentScale with a selection of modes in 31edo 
scldegmatch - returns the index in one scale table which matches the pitch from another scale table.

;;;;;;;;;;;;;;;;;;;;;;;;
;; EVENT GENERATORS
Event generators produced score events. 
orn - generate score events from arrays of intervals and rhythms
chrdi - generate concurrant score events
arpi - generate score events from arrays of scale degrees and rhythms
loopevent - generate repeating score event cycles
loopcode - generate repeating cycles of arbitrary code.

;;;;;;;;;;;;;;;;;;;;;;;;;
;; PATCH UDO's for signal routing
patching routes audio between named instruments.
Audio is sent to a patch array. Patch UDO's determine which instrument receive the audio.
In this context 'Source' Intruments send audio to the patch system using the 'send' opcode.
'Effect' instruments retrieve and send audio back to the patch system.

Syntax:
patchsig Ssource, SDestination [,ilevel]
patchchain Spatharray[] [,ilevel]
patchspread Ssource, SDestinationarray[] [,ilevel]
send asig
send asig1,asig2
send asigs[]o

Ssource -- String name of the instrument or effect sending audio
SDestination -- String name of the effect receiving audio (See EffectConstruct)
SDestination[] (In patchspread) -- A string array of the names of effects receiving audio. Patchspread sends audio from Ssource to each effect in parallel. 
                                   Useful for splitting the signal path.
Spatharray[] (In patchchain) -- Spatharray is a string array of Instrument and/or Effect Names. 
                                Patchchain seqentially applies patchsig to each element in the array in series. 
                                Audio is routed between each instrument/effect from the beginning of the array to the end. 
  				While the first element can be a either a source instrument or an Effect, subsequent elements must be effects (with inputs).
Example:
instr myoscil
asig oscil p4,p5
send fillarray(asig) ; send audio to the patch array
endin

;Creating an Effect ; Effects already receive from the patch array 
EffectConstruct "flange",{{
ain = ains[0]
aout flanger ain, oscili:a(0.005,0.25,-1,1) + 0.0055, 0.66
aouts[] fillarray aout
}},1,1,1

;Now route the audio
patchsig "myoscil", "outs"                               ; Send audio to the output.
patchchain fillarray("myoscil", "flange","outs"),0.6     ; re-route the audio to an effect, then from the effect to the output.
patchspread "myoscil", fillarray("rvb","compressor")     ; re-route audio to two effects in parallel.  

;EFFECT Instruments
EffectConstruct generates 'Effect' instruments.
These are 'always on' instruments, but can be re-evaluated to update the code 'on the fly'. Re-evaluating replaces the running instance.
Effect instruments send audio to the Patch system. 
Syntax: EffectConstruct SName, Scode, input_count, ioutput_count, icrossfade
Sname -- A name given to the instrument (must be unique). The Patchsend opcodes use this name to route audio.
Scode -- the body of csound code used to process audio.
         Input audio arrives in an audio array labelled ains[]. The length of this array depends on input_count
         Output audio should be assigned to an audio array labelled aouts[]. The length of this array depends on ioutput_count
input_count -- Number of audio inputs (sets the size of the ains[] array)
ioutput_count -- Number of audio outputs (sets the size of the aouts[] array)
icrossfade -- crossfade length in seconds for the transition to the new instance. 
Example:
;create an instrument named 'flange' with one input and two outputs.
EffectConstruct "flange",{{
ain = ains[0]
adel1 = oscili(0.005,0.25,-1,1) + 0.0055
adel2 = oscili(0.004,0.23,-1,1) + 0.0045
aoutL flanger ain, adel1, 0.75
aoutR flanger ain, adel2, 0.75
aouts fillarray aoutL, aoutR
}},1,2,1

Other Utilities/miscellaneous
fillarray:a - a-rate version of fillarray
catarray - concatenate multiple arrays
encode2 - encode two audio signals into a single audio signal 
decode2 - decodes two audio signals from one encoded by encode2
encode4 - encode 4 integers into a single integer
decode4 - decode 4 integers from a single encoded integer
n - short wrapper for nstrnum
rescale, rescalek - rescales values
randint - return a random integer in a range
ndxarray - forgiving array indexing
mono - signals when a concurrant instance is active
castarray/ca - iarray to karray or vice versa 
truncatearray - extend or trim an array
wchoice - weighted choice selection
rotatearray - permute an array
dedupe - remove dulicates from an array
slicearray_k - like slicearray with k-rate inputs
poparray - returns item at index in an array, and the array with item removed.
rndpick - get a random selection from an array, without duplicates. 
cosr - returns a value in a cosine circle with resp[ect to the current time.
linslide - control a channel value
counterChan - increment a channel value
iterArr - yield the next value in an array on successive calls.
seesaw - oscillate between two values
walker - Random walk
randselect_i - Select a random value fromthe argument list
curve/curvek - convex/concave curves


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Optional: See also cslc-mode, the emacs minor mode for live coding.
*/

;Setup actions for cslc livecode environment.
gk_tempo init 60
gk_now init 0

gkVUmonitorfreq init 12 ;frequency of the ANSI term vumeter updates.

seed 0
;;;
;;
giMAXOUTS = 4 ; up to a maximum of 4 outputs per instrument (i.e. quadrophonic). Adjust to suit.
giMAXINSTR = 300 ;Handle up to i299 patched instruments (output is instr 299).
ga_cslc_PatchArr[][] init giMAXINSTR,giMAXOUTS ;can handle 300 instruments and up to 4 outputs per instrument
gi_cslc_Srcouts[][] init giMAXINSTR,2 ; records no. of outputs per source instrument
gi_cslc_Destins[][] init giMAXINSTR,2 ;records no. of inputs per effect instrument 
gk_cslc_clearupdate init 0
;gS_cslc_channelarr is used for clearing channels
gS_cslc_channelarr[] init giMAXINSTR ;300
ga_cslc_channelclear[] init giMAXINSTR ;zero's only
;for loopplayers
gi_cslc_Looprec[][] init giMAXINSTR, 50 ;

gi_cslc_patchsig_inum = 5
gi_cslc_clearsig_inum = 6

;fill the channel array with "null"
gi_cslc_chntally = 0

i_cslc_sndx = 0
until i_cslc_sndx >= lenarray(gS_cslc_channelarr) do
   gS_cslc_channelarr[i_cslc_sndx] = "null"
   i_cslc_sndx += 1
od
;gi_cslc_nstance
gi_cslc_nstance ftgen 0,0,-giMAXINSTR,-2,0
gi_cslc_nstance_cnt ftgen 0,0,-giMAXINSTR,-2,0

;;;default instrument allocations for midi
gi_midichanmap ftgen 0, 0, 16, -2, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116

;channel instance control used by linslide
gi_cslc_chanfn ftgen 0,0,256,-2,0
gS_cslc_ActiveChans[] init 200

;for loopevent 
gkloopsignal init 0

;Some scale tables
gi12edofn ftgen 0,0,64,-2, 12, 2, 263, 0,  
1, 2^(1/12) ,2^(2/12),2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(8/12),2^(9/12),2^(10/12),2^(11/12),2

gi17edofn ftgen 0,0,64,-2, 17, 2, 263, 0,  
1, 2^(1/17) ,2^(2/17),2^(3/17),2^(4/17),2^(5/17),2^(6/17),2^(7/17),2^(8/17),2^(9/17),2^(10/17),2^(11/17),2^(12/17),2^(13/17),2^(14/17),2^(15/17),2^(16/17),2

gi12justfn ftgen 0,0,64,-2, 12, 2, 263, 0,  
1, (16/15), (9/8),(6/5),(5/4),(4/3),(7/5),(3/2),(8/5),(5/3),(16/9),(15/8),2

gi12coul_12afn ftgen 0,0,64,-2, 12, 2, 263, 0,  
1, (25/24), (10/9),(6/5),(5/4),(4/3),(36/25),(3/2),(25/16),(5/3),(9/5),(15/8),2

gi_31edo ftgen 0,0,64,-2, 31, 2, 263, 0,\
1, 2^(1/31) ,2^(2/31),2^(3/31),2^(4/31),2^(5/31),2^(6/31),2^(7/31),2^(8/31),2^(9/31),2^(10/31),2^(11/31),2^(12/31),2^(13/31),2^(14/31),2^(15/31),2^(16/31),2^(17/31),2^(18/31),2^(19/31),2^(20/31),2^(21/31),2^(22/31),2^(23/31),2^(24/31),2^(25/31),2^(26/31),2^(27/31),2^(28/31),2^(29/31),2^(30/31),2

;Some interval arrays
gk12majormode[] array 2,2,1,2,2,2,1
gi12majormode[] array 2,2,1,2,2,2,1
gk12minormode[] array 2,1,2,2,1,2,2
gk17neutralmode[] array 3,2,3,2,2,3,2
gi31Diatonic[] array 5,5,3,5,5,5,3
gk31Diatonic[] array 5,5,3,5,5,5,3
gi31NaturalMinor[] array 5,3,5,5,3,5,5
gi31DiaDom7[] array 5,5,3,5,5,2,6
gi31MinDom7[] array 5,3,5,5,3,4,6
gi31Neutral[] array 4,5,4,5,4,5,4
gi31Diminished[] array 4,2,6,4,2,6,7
;more than 7 notes!
gi31Orwell[] array 4,3,4,3,4,3,4,3,3

;create some default modes used by scalemode31 
gi_cslc_31Modes[][] init 31,7
i_cslc_31ndx = 0
until (i_cslc_31ndx == lenarray(gi_cslc_31Modes, 1)) do
    i7ndx = 0
    until (i7ndx == lenarray(gi_cslc_31Modes, 2)) do
        if (i_cslc_31ndx == 0 || i_cslc_31ndx == 13 || i_cslc_31ndx == 18 || i_cslc_31ndx == 25 ||
            i_cslc_31ndx == 3 || i_cslc_31ndx == 16 || i_cslc_31ndx == 21 || i_cslc_31ndx == 28 ||
            i_cslc_31ndx == 6 || i_cslc_31ndx == 19 || i_cslc_31ndx == 24) then
            gi_cslc_31Modes [i_cslc_31ndx][i7ndx] = gi31DiaDom7[i7ndx]
        elseif (i_cslc_31ndx == 5 || i_cslc_31ndx == 10 || i_cslc_31ndx == 23 ||
                i_cslc_31ndx == 8 || i_cslc_31ndx == 13 || i_cslc_31ndx == 26 ||
                i_cslc_31ndx == 11 || i_cslc_31ndx == 29) then
            gi_cslc_31Modes [i_cslc_31ndx][i7ndx] = gi31MinDom7[i7ndx]
        elseif (i_cslc_31ndx == 2 || i_cslc_31ndx == 4 || i_cslc_31ndx == 7 || i_cslc_31ndx == 9 ||
                i_cslc_31ndx == 14 || i_cslc_31ndx == 17 || i_cslc_31ndx == 20 || i_cslc_31ndx == 22 || i_cslc_31ndx == 27) then
            gi_cslc_31Modes [i_cslc_31ndx][i7ndx] = gi31Neutral[i7ndx]            
        elseif (i_cslc_31ndx == 1 || i_cslc_31ndx == 12 || i_cslc_31ndx == 15 || i_cslc_31ndx == 28 || i_cslc_31ndx == 30) then
            gi_cslc_31Modes [i_cslc_31ndx][i7ndx] = gi31Diminished[i7ndx]
        endif
        i7ndx += 1
    od
i_cslc_31ndx += 1
od

;Declarations of gi_Superscale and gi_CurrentScale.
;Loaded with a default JI from scala lib.
gi_SuperScale = gi12coul_12afn
gi_CurrentScale ftgen 0,0,128,-2,7, 2,    263, 0,
(table:i(4, gi12coul_12afn)),
(table:i(6, gi12coul_12afn)), 
(table:i(8, gi12coul_12afn)), 
(table:i(9, gi12coul_12afn)), 
(table:i(11, gi12coul_12afn)),
(table:i(13, gi12coul_12afn)),
(table:i(15, gi12coul_12afn)),
(table:i(16, gi12coul_12afn))

gkTonic_ndx init 0  ;index of the tonic in gi_CurrentScale
giTonic_ndx = 0  ;might be better than krate
gi_midikeyref = 60

;;_cslc_taberror returns the index of the nearest value in a table that matches ival.
;;also returns the deviation (the error) of the table value to ival
opcode _cslc_taberror, ii,iioj
  ival, itab, indxst, indxnd xin
  indxresult = -1
  ierror = 9999
  isign = 1
  indxnd = (indxnd == -1 ? tableng(itab) : indxnd)
  until (indxst >= indxnd) do
     ires table indxst, itab
     idiff = abs(ival - ires)
     if (idiff < ierror) then
        ierror = idiff 
        indxresult = indxst
        isign = (ival < ires ? -1 : 1)
     endif
     indxst += 1
  od
  xout indxresult, ierror * isign  
endop

;;krate version
opcode _cslc_taberror, kk,kiOJ
  kval, itab, kndxst, kndxnd xin
  kndxresult = -1
  kerror = 9999
  ksign = 1
  kndxnd = (kndxnd == -1 ? tableng(itab) : kndxnd)
  until (kndxst >= kndxnd) do
     kres table kndxst, itab
     kdiff = abs(kval - kres)
     if (kdiff < kerror) then
        kerror = kdiff 
        kndxresult = kndxst
        ksign = (kval < kres ? -1 : 1)
     endif
     kndxst += 1
  od
  xout kndxresult, kerror * ksign  
endop

;; just a wrapper for _cslc_taberror, only _cslc_finds exact values
opcode _cslc_find, i, iioj
   ival, ift, indxst, indxnd xin
   indxres,ierr _cslc_taberror ival, ift, indxst, indxnd
   ires = (ierr == 0 ? indxres : -1)
   xout ires
endop

;krate version
opcode _cslc_find, k, kiOJ
   kval, ift, kndxst, kndxnd xin
   kndxres,kerr _cslc_taberror kval, ift, kndxst, kndxnd
   kres = (kerr == 0 ? kndxres : -1)
   xout kres
endop

opcode _cslc_find, i, ik[]
;returns index position of ival, or  -1 if false
ival, kselection[] xin
iresult = -1
indx = 0
until (indx == lenarray(kselection)) do
   if (ival == i(kselection, indx)) then
   iresult = indx
   igoto BREAK
   endif
   indx += 1
od
BREAK:
xout iresult
endop

opcode _cslc_find, i, ii[]
ival, iselection[] xin
iresult = -1
indx = 0
until (indx == lenarray(iselection)) do
   if (ival == iselection[indx]) then
      iresult = indx
      igoto BREAK
   endif
   indx += 1
od
BREAK:
xout iresult
endop

opcode _cslc_find,i,SS[]
  Schan,SArr[] xin
  iresult = -1
  indx = 0
  ilen = lenarray(SArr)
  until (indx >= ilen) do
    Schnval = SArr[indx]
    if (strcmp(Schnval, Schan) == 0) then
         iresult = indx
         igoto BREAK
    elseif (strcmp(Schnval, "null") == 0) then 
         igoto BREAK
    endif
    indx += 1
  od
BREAK:
xout iresult
endop

;fillarray for audio vectors
;This opcode generates multiple overloaded versions of fillarray to handle mutltiple args for audio inputs.
;note: the opcodes are only generated at performance time, after the first initialisation pass in the orchestra.
opcode _cslc_fillarrayoload,0,i
  inumops xin
  iopndx = 1
  while iopndx <= inumops do
    icount = iopndx
    indx = 1
    Sopln1 = {{
    opcode fillarray, a[],}}
    Sopln2 = ""
    Sbody1 sprintf "ares[] init %d\n",icount
    until indx > icount do
       Sopln1 strcat Sopln1, "a"
       if indx < icount then
	  Snewln2 sprintf "ain%d,",icount - indx - 1
	  Sopln2 strcat Snewln2,Sopln2
       else
	  Snewln2 sprintf "ain%d xin\n",icount - 1
	  Sopln2 strcat Sopln2,Snewln2
       endif
       Sbody2 sprintf "ares[%d] = ain%d\n", indx - 1, indx - 1
       Sbody1 strcat Sbody1, Sbody2
       indx+=1
    od
    Sopheader sprintf "%s%s%s%s",Sopln1,"\n",Sopln2,Sbody1
    Sopfooter = {{xout ares
    endop
    }}
    Sfinal strcat Sopheader, Sopfooter
    icomp compilestr Sfinal
    iopndx += 1
  od
endop
;;default is up to 16 arates
_cslc_fillarrayoload 16 

;;This UDO creates multiple overloaded `catarray` UDO's.
;;_cslc_catarrayoload_i generates catarray for i-rate arrays.
;;_cslc_catarrayoload_k generate catarray for k-rate arrays.
;;Once created, the catarray UDO concatenates
;;multiple 1d arrays into a single array..
;;syntax:
;;kres[] catarray k1[],k2[],k3[]... etc
;;

opcode _cslc_catarrayoload_i,0,i
  inumops xin
  iopndx = 2
  while iopndx <= inumops do
    icount = iopndx
    indx = 1
    Smaini sprintf {{    iresult[] init lenarray(iarr1) + lenarray(iarr2)
    iargs = (iargs == -1 ? %d : iargs)
    indx = 0
    until indx = lenarray(iresult) do
      if indx < lenarray(iarr1) then
         iresult[indx] = iarr1[indx]
      else
         iresult[indx] = iarr2[indx - lenarray(iarr1)]
      endif
         indx += 1
      od
      iargs -= 1}},icount-1    
    Sopln1 = "opcode catarray, i[],"
    Sopln2 = ""
    Soprecurse = {{
       if iargs > 0 then
          iresult[] catarray iresult,}}
    until indx > icount do
       Sopln1 strcat Sopln1, "i[]"
       if indx < icount then
	  Snewln2 sprintf "iarr%d[],",icount - indx
          Sopln2 strcat Snewln2,Sopln2
          Snewoprecurse sprintf "iarr%d,",limit(indx+2,0,icount)
          Soprecurse strcat Soprecurse, Snewoprecurse 
       else
	  Snewln2 sprintf "iarr%d[],iargs xin\n",indx
          Sopln2 strcat Sopln2,Snewln2
          Snewoprecurse = "iargs\n      endif\n"
          Soprecurse strcat Soprecurse, Snewoprecurse
       endif
       indx+=1
    od
    Sopheader sprintf "%s%s%s%s",Sopln1,"j\n    ",Sopln2,Smaini
    Sopfooter sprintf "%sxout iresult \nendop\n",Soprecurse
    Sfinal strcat Sopheader, Sopfooter
    icomp compilestr Sfinal
    iopndx += 1
od
endop  

opcode _cslc_catarrayoload_k,0,i
  inumops xin
  iopndx = 2
  while iopndx <= inumops do
    icount = iopndx
    indx = 1
    Smaink sprintf {{    kresult[] init lenarray(karr1) + lenarray(karr2)
    iargs = (iargs == -1 ? %d : iargs)
    kndx = 0
    until kndx = lenarray(kresult) do
      if kndx < lenarray(karr1) then
         kresult[kndx] = karr1[kndx]
      else
         kresult[kndx] = karr2[kndx - lenarray(karr1)]
      endif
         kndx += 1
      od
      iargs -= 1}},icount-1    
    Sopln1 = "opcode catarray, k[],"
    Sopln2 = ""
    Soprecurse = {{
       if iargs > 0 then
          kresult[] catarray kresult,}}
    until indx > icount do
       Sopln1 strcat Sopln1, "k[]"
       if indx < icount then
	  Snewln2 sprintf "karr%d[],",icount - indx
          Sopln2 strcat Snewln2,Sopln2
          Snewoprecurse sprintf "karr%d,",limit(indx+2,0,icount)
          Soprecurse strcat Soprecurse, Snewoprecurse 
       else
	  Snewln2 sprintf "karr%d[],iargs xin\n",indx
          Sopln2 strcat Sopln2,Snewln2
          Snewoprecurse = "iargs\n      endif\n"
          Soprecurse strcat Soprecurse, Snewoprecurse
       endif
       indx+=1
    od
    Sopheader sprintf "%s%s%s%s",Sopln1,"j\n    ",Sopln2,Smaink
    Sopfooter sprintf "%sxout kresult \nendop\n",Soprecurse
    Sfinal strcat Sopheader, Sopfooter
    icomp compilestr Sfinal
    iopndx += 1
od
endop  
;;Default is to generate catarray up to 12 args
_cslc_catarrayoload_i 12
_cslc_catarrayoload_k 12

;send audio signals in an instrument to the global audio array (ga_cslc_PatchArr)
;e.g. send fillarray(aLeft, aRight)
opcode send, 0, a[]j
  asigs[],ichan xin
  ialen lenarray asigs
  ichan = (ichan == -1 ? ialen - 1:ichan)
  Sname nstrstr p1 ;temporary. Debugging only.
  asig = asigs[ichan]  
  ga_cslc_PatchArr[p1][ichan] = ga_cslc_PatchArr[p1][ichan] + asig
  if ichan > 0 then
     send asigs, ichan - 1
  else
     gi_cslc_Srcouts[p1][1] = ialen
  endif
endop    

;A couple of overloaded convenience wrappers to avoid array notation.
;especially since we can't use the arate fillarray opcode in instruments at orc init time.          
opcode send,0,aa 
aLeft, aRight xin
aArr[] init 2
aArr[0] = aLeft    
aArr[1] = aRight    
send aArr   
endop

opcode send,0,a
ain xin
aArr[] init 1
aArr[0] = ain    
send aArr
endop

;these get replaced by _cslc_fillarrayoload, but are useful on the first pass 
opcode fillarray,a[],aa
ain0,ain1 xin    
aArr[] init 2
aArr[0] = ain0
aArr[1] = ain1
xout aArr    
endop    
opcode fillarray,a[],a
ain xin
aArr[] init 1
aArr[0] = ain
xout aArr    
endop    

        
opcode _cslc_getSrcNumOuts,i,S
  Ssrc xin
  iSrcnum nstrnum Ssrc
  iSrccount = gi_cslc_Srcouts[iSrcnum][1]
  xout iSrccount
endop

;;;;hardcoded 299 for outs. Make sure it actually matches the instrument number. 
opcode _cslc_getDestNumIns,i,S
  SDest xin
  if (strcmp(SDest,"outs") == 0) then
     iDestnum = 299
  else
     iDestnum nstrnum SDest
  endif
  iDestcount = gi_cslc_Destins[iDestnum][1]
  xout iDestcount
endop

opcode _cslc_recordpatch,i,i
ipatchnstance xin
iexists _cslc_find ipatchnstance, gi_cslc_nstance
if (iexists == -1) then
   iexists _cslc_find 0, gi_cslc_nstance ;_cslc_find the next zero position
   tablew ipatchnstance, iexists, gi_cslc_nstance
   tablew 1, iexists, gi_cslc_nstance_cnt ;not really necessary in this context
elseif (iexists > -1) then
endif
xout iexists
endop

;Remove an instance from gi_cslc_nstance
opcode _cslc_removepatch,0,i
ipatchnstance xin 
iexists _cslc_find ipatchnstance, gi_cslc_nstance
if (iexists == -1) then
   ;printf_i "remove nstnce: not able to _cslc_find %f\n",1, ipatchnstance
else
   tablew 0, iexists, gi_cslc_nstance
   tablew table(iexists, gi_cslc_nstance_cnt) - 1, iexists, gi_cslc_nstance_cnt
   ;printf_i "removed instance: %f\n",1, ipatchnstance
endif
endop

;returns an array of the active patched source instances 
opcode _cslc_getSources,i[],0
  iresult[] tab2array gi_cslc_nstance
  icount = lenarray(iresult) - 1
  until (icount == 0) do
     ival = iresult[icount]
     if (ival == 0) then
        ;do nothing
     else
        igoto break
     endif
     icount -= 1
  od
  break:
  trim_i iresult, icount+1
  xout iresult
endop

;encodes two audio signals into one
opcode encode2,a,aa
iscaleFactor = 2^18
icp = iscaleFactor + 1
ax, ay xin
ax *= 0.5
ay *= 0.5
ax += 0.5
ay += 0.5
ax1 = int(ax * iscaleFactor)
ay1 = int(ay * iscaleFactor)
aenc = (ay1 * icp) + ax1
xout aenc
endop

;decodes an encoded audio signal into two channels
opcode decode2,aa,a
iscaleFactor = 2^18
icp = iscaleFactor + 1
aenc xin
ay = floor(aenc / icp)
ax = aenc - (ay * icp)
ay2 = (ay / iscaleFactor)
ax2 = (ax / iscaleFactor)
ax2 -= 0.5
ay2 -= 0.5
ax2 *= 2
ay2 *= 2
xout ax2,ay2
endop

;encode 4 integers into a single integer
opcode encode4,i,iiii
ival1, ival2,ival3,ival4 xin
iv1 = ival1 * 10^4
iv2 = ival2 * 10^2
iv3 = ival3 * 10^1
iv4 = ival4 * 10^0
iencoded = (iv1 + iv2 + iv3 + iv4) 
xout iencoded
endop

;decode a single integer into 4 separate integers
opcode decode4,iiii,i
idec xin
idecv1 = floor(idec / (10 ^ 4))
idecv2 = floor((idec % (10 ^ 4)) / (10 ^ 2))
idecv3 = round((idec % (10 ^ 2)) / (10 ^ 1))
idecv4 = round(idec) % 10
xout idecv1,idecv2,idecv3,idecv4
endop

opcode _cslc_getSrcInstances,i[],i
isrcnum xin
isrcs[] _cslc_getSources
isrcz[] cmp isrcs,"!=",0
ilenresult sumarray isrcz
iresult[] init (ilenresult == 0 ? 1:ilenresult)
indx = 0
iresndx = 0
while (indx < lenarray(isrcs)) do
  item = isrcs[indx]
  if item > 0 then
    instnce = round((item - gi_cslc_patchsig_inum) * 10^7)
    isrc,ichan,inst,inull decode4 instnce
    if isrc == isrcnum then
       iresult[iresndx] = instnce
       iresndx += 1
    endif
  endif
  indx += 1
od
trim_i iresult, iresndx
xout iresult
endop


opcode patchsig, 0,SSp
Ssrc, Sdest, ilevel xin
isrc nstrnum Ssrc
isrcnums = _cslc_getSrcNumOuts(Ssrc) - 1;e.g. 0, 1
idestnums = _cslc_getDestNumIns(Sdest) - 1; e.g. "Rvb:0", "Rvb:1"
imaxpatches max isrcnums, idestnums
inewpatches[] init imaxpatches+1
icurrentpatches[] _cslc_getSrcInstances, isrc
until (imaxpatches < 0) do
    isrcmodulo = imaxpatches % (isrcnums + 1)
    idestmodulo = imaxpatches % (idestnums + 1)
    SDestchan sprintf "%s:%d",Sdest,idestmodulo 
    iencoded = encode4(isrc,isrcmodulo,imaxpatches,0)
    ienc = 5 + (iencoded / 10^7)
    printf_i "Patching %s:%d (instance %f) => Destchan %s\n",1,Ssrc,isrcmodulo,ienc, SDestchan
    schedule ienc, 0, -1, SDestchan, ilevel, imaxpatches * -1
    irecresult _cslc_recordpatch ienc
    inewpatches[imaxpatches] = iencoded
    if (_cslc_find(SDestchan, gS_cslc_channelarr) == -1) then
       gS_cslc_channelarr[gi_cslc_chntally] = SDestchan
       gi_cslc_chntally += 1
    endif
    imaxpatches -= 1 
od
gk_cslc_clearupdate init 1 
ioldndx = lenarray(icurrentpatches) - 1 
until ioldndx < 0 do
   instnce = icurrentpatches[ioldndx]
   if (_cslc_find(instnce,inewpatches) == -1) then
      turnoff2_i gi_cslc_patchsig_inum+(instnce / 10^7),4,1
      _cslc_removepatch(gi_cslc_patchsig_inum+(instnce / 10^7))
      printf_i "removed patch %f\n",1,gi_cslc_patchsig_inum+(instnce / 10^7)
   else
      ;printf_i "\n\n**** found %f, doing nothing *** \n\n",1,instnce
   endif
   ioldndx -= 1
od
endop

opcode patchspread, 0,SS[]p
Ssrc, Sdests[],ilevel xin
;prints "\n\nEntering Patchspread\n\n"
isrc nstrnum Ssrc
isrcchans = _cslc_getSrcNumOuts(Ssrc)
isrcselect = 0
isdestlen lenarray Sdests
idestchanarr[] init isdestlen
idestchan = 0
iwalkdests = 0
;prints "\n\nPatchspread 0\n\n"
while (iwalkdests < isdestlen) do
  Sd = Sdests[iwalkdests]
  idnum = _cslc_getDestNumIns(Sd)
  idestchan += idnum
  idestchanarr[iwalkdests] = idnum - 1
  iwalkdests += 1
od
imaxpatches max isrcchans, idestchan
inewpatches[] init imaxpatches
ipatchexpected = lenarray(inewpatches)
icurrentpatches[] _cslc_getSrcInstances, isrc
ipatchndx = 0
idestndx = 0 
idchanndx = 0
while (ipatchndx < ipatchexpected) do
  isrcselect = wrap:i(ipatchndx,0,isrcchans) ;select source
  idselect = wrap:i(idestndx,0,isdestlen)
  Sdname = Sdests[idselect]
  idestchan = idchanndx
  SDestchan sprintf "%s:%d",Sdname,idestchan
  iencoded = encode4(isrc,isrcselect,imaxpatches,0)
  ienc = gi_cslc_patchsig_inum + (iencoded / 10^7)
  printf_i "Patching %s:%d (instance %f) => Destchan %s\n",1,Ssrc,isrcselect,ienc, SDestchan
  schedule ienc, 0, -1, SDestchan, ilevel,imaxpatches * -1
  irecresult _cslc_recordpatch ienc  
  ipatchndx += 1
  if idestchanarr[idselect] == 0 then
     idestndx += 1
     idchanndx = 0
  else
     idestchanarr[idestndx] = idestchanarr[idestndx] - 1
     idchanndx += 1
  endif  
  inewpatches[imaxpatches-1] = iencoded    
  if (_cslc_find(SDestchan, gS_cslc_channelarr) == -1) then
     gS_cslc_channelarr[gi_cslc_chntally] = SDestchan
     gi_cslc_chntally += 1
  endif
  imaxpatches -= 1 
od
gk_cslc_clearupdate init 1 
ioldndx = lenarray(icurrentpatches) - 1 
until ioldndx < 0 do
   instnce = icurrentpatches[ioldndx]
   if (_cslc_find(instnce,inewpatches) == -1) then
      turnoff2_i gi_cslc_patchsig_inum+(instnce / 10^7),4,1
      _cslc_removepatch(gi_cslc_patchsig_inum+(instnce / 10^7))
   else
      ;printf_i "\n\n**** found %f, doing nothing *** \n\n",1,instnce
   endif
   ioldndx -= 1
od
endop

opcode patchchain,0,S[]p
Schain[],ilevel xin
ichainlen lenarray Schain
indx = 0
while indx < (ichainlen - 1) do
   patchsig Schain[indx],Schain[indx+1],(indx == 0 ? ilevel : 1)
   indx += 1
od
endop

;;n == Abbreviation for nstrnum. Convenience.
opcode n, i,S
  Sinsname xin
  xout nstrnum(Sinsname)
endop

opcode _cslc_minarray2, i,i[]
iInarray[] xin
iresult = iInarray[0]
indx init 1
until indx == lenarray(iInarray) do
    ival = iInarray[indx]
    if ival < iresult then
       iresult = ival
    endif
    indx += 1
od
xout iresult
endop

opcode _cslc_minarray2, ii,i[]
iInarray[] xin
indxlow = 0
iresult = iInarray[indxlow]
indx = 1
until indx == lenarray(iInarray) do
    ival = iInarray[indx]
    if ival < iresult then
       iresult = ival
       indxlow = indx
    endif
    indx += 1
od
xout iresult, indxlow
endop

opcode _cslc_maxarray2, i,i[]
iInarray[] xin
iresult = iInarray[0]
indx init 1
until indx == lenarray(iInarray) do
    ival = iInarray[indx]
    if ival > iresult then
       iresult = ival
    endif
    indx += 1
od
xout iresult
endop

opcode _cslc_maxarray2, ii,i[]
iInarray[] xin
indxhigh = 0
iresult = iInarray[indxhigh]
indx = 1
until indx == lenarray(iInarray) do
    ival = iInarray[indx]
    if ival > iresult then
       iresult = ival
       indxhigh = indx
    endif
    indx += 1
od
xout iresult, indxhigh
endop

opcode _cslc_minarray2, k,k[]
kInarray[] xin
kresult = kInarray[0]
kndx init 1
until kndx == lenarray(kInarray) do
    kval = kInarray[kndx]
    if kval < kresult then
       kresult = kval
    endif
    kndx += 1
od
xout kresult
endop

opcode _cslc_minarray2, kk,k[]
kInarray[] xin
kndxlow init 0
kresult = kInarray[kndxlow]
kndx init 1
until kndx == lenarray(kInarray) do
    kval = kInarray[kndx]
    if kval < kresult then
       kresult = kval
       kndxlow = kndx
    endif
    kndx += 1
od
xout kresult, kndxlow
endop

opcode _cslc_maxarray2, k,k[]
kInarray[] xin
kresult = kInarray[0]
kndx init 1
until kndx == lenarray(kInarray) do
    kval = kInarray[kndx]
    if kval > kresult then
       kresult = kval
    endif
    kndx += 1
od
xout kresult
endop

opcode _cslc_maxarray2, kk,k[]
kInarray[] xin
kndxhigh init 0
kresult = kInarray[kndxhigh]
kndx init 1
until kndx == lenarray(kInarray) do
    kval = kInarray[kndx]
    if kval > kresult then
       kresult = kval
       kndxhigh = kndx
    endif
    kndx += 1
od
xout kresult, kndxhigh
endop

;wrapper around buggy sumarray
opcode _cslc_sumarray2, i,i[]
iArr[] xin
iresult = 0
indx = 0
ilen lenarray iArr
until (indx == ilen) do
    iresult += iArr[indx]
    indx += 1
od
xout iresult
endop

opcode _cslc_sumarray2, k,k[]
kArr[] xin
kresult init 0
kndx init 0
klen lenarray kArr
until (kndx == klen) do
    kresult += kArr[kndx]
    kndx += 1
od
xout kresult
endop


;a wrapper to for my preferred indexing around slicearray
opcode _cslc_slicearray2, i[],i[]iip
  iArr[],ibeg,iend,istride xin  
  if iend == 0 then
     iend = lenarray(iArr)
  elseif iend < 0 then
     iend = lenarray(iArr) + iend
  endif
  iend -= 1
iresult[] init (iend <= 0 ? 1:iend)
iresult[] slicearray iArr, ibeg, iend, istride
xout iresult
endop

;a wrapper to fix index 0 slicearray
opcode _cslc_slicearray2, k[],k[]iip
kArr[],ibeg,iend,istride xin
  if iend == 0 then
     iend = lenarray(kArr)
  elseif iend < 0 then
     iend = lenarray(kArr) + iend
  endif
  iend -= 1
  kresult[] slicearray kArr, ibeg, iend, istride
xout kresult
endop

;;slicearray with k-rate inputs
opcode slicearray_k, k[],k[]kk
  kArr[],kbeg,kend xin
  kresult[] genarray kbeg, kend, 1
  klen lenarray kresult
  kresndx = 0
  kndx = 0
  until kndx > kend do
    if kndx < kbeg then
    ;;do nothing
       kndx += 1
    elseif kndx <= kend then
      kresult[kresndx] = kArr[kndx]
      kndx += 1
      kresndx += 1
    else
      printf "slicearray_k shouldn't reach this condition\n",1
    endif      
  od
xout kresult
endop

;Given an an array and an index value, returns an array with the item at index removed, and the value in the input array at index.
opcode poparray, i[]i,i[]i
  iinArr[],indx xin
  iinlen lenarray iinArr
  if indx >= iinlen then
     ipopresult = 0
     ipopArr[] init 1
     prints "poparray error | index outof bounds\n"
  else    
    ipopresult = iinArr[indx]
    ipopArr[] init iinlen - 1
    ihead[] slicearray iinArr,0,indx-1
    itail[] slicearray iinArr,indx+1, iinlen-1
    icount = 0
    until icount == lenarray(ipopArr) do
      if icount < lenarray(ihead) then
        ipopArr[icount] = ihead[icount]
      else
        ipopArr[icount] = itail[icount - lenarray(ihead)]
      endif
    icount += 1
  od
  endif
    xout ipopArr,ipopresult
endop

opcode poparray, k[]k,k[]k
  kinArr[],kndx xin
  kinlen = lenarray:k(kinArr)
  if kndx >= kinlen then
     kpopresult = 0
     kpopArr[] init 1
     printf "poparray error | index out of bounds\n",1    
  else
    kpopresult = kinArr[kndx]
    kpopArr[] genarray 1,lenarray:k(kinArr) - 1
    khead[] slicearray_k kinArr,0,kndx-1
    ktail[] slicearray_k kinArr,kndx+1, lenarray:k(kinArr)-1
    kcount = 0
    until kcount == lenarray:k(kpopArr) do
      if kcount < lenarray:k(khead) then
         kpopArr[kcount] = khead[kcount]
      else
         kpopArr[kcount] = ktail[kcount - lenarray:k(khead)]
    endif
      kcount += 1
    od
  endif
  xout kpopArr,kpopresult
endop

;;returns an array, inum in length, of randomly selected items from an array.
;;Each item is only selected once. The selection will not contain duplicates.
opcode rndpick, i[],i[]i
  iinarr[],inum xin
  iresult[] init inum
  if inum >= lenarray:i(iinarr) then
    prints "randpick error | selection size to large for input array\n"
  else
    until inum == 0 do
    indx = floor(unirand:i(lenarray:i(iinarr)-0.000001))
    iinarr, ipopresult poparray iinarr,indx 
    iresult[inum - 1] = ipopresult
    inum -= 1
    od
  endif
  xout iresult
endop

opcode rndpick, k[],k[]k
  kinarr[],knum xin
  kresult[] genarray 1,knum
  if knum >= lenarray(kinarr) then
    printf "randpick error | selection size to large for input array\n",1
  else
    until knum == 0 do
      kndx = floor(unirand:k(lenarray:k(kinarr)-0.000001))
      kinarr, kpopresult poparray kinarr,kndx
      kresult[knum - 1] = kpopresult
    knum -= 1
    od
  endif  
  xout kresult
endop


;Generates a scale of equidistant degrees per period, usable by the cpstun[i] opcode.
;insteps is number of steps in the scale.
;ibasefreq and ibasekey correspond to the cpstun opcode documentation.  
;ibasefreq defaults to Csounds A4 value. ibasekey defaults to 69.
;iperiod specifies the scale repetition period. Defaults to 2 (octave)
;ifn specifies the ftable no. Defaults to zero (csound generated number).
;Output is the table number. 
;Example:
;generate a 13ed3 (Bohlen Pierce 13ed3 Tritave) scale.
;giscale Tbedn 13, 263, 60, 3
opcode Tbedn, i, ijjoo
insteps, ibasefreq, ibasekey, iperiod, ifn xin
ibasefreq = (ibasefreq == -1 ? A4 : ibasefreq)
ibasekey = (ibasekey == -1 ? 69 : ibasekey)
iperiod = (iperiod == 0 ? 2 : iperiod)
idummy_ ftgen ifn, 0, -(insteps + 5), -2, insteps, iperiod, ibasefreq, ibasekey, 1
iarrstep init 0
while iarrstep < insteps do
   tableiw iperiod^((iarrstep + 1)/insteps), iarrstep + 5, idummy_
   iarrstep += 1
od
xout idummy_
endop

opcode _cslc_get2dArr, i[], ii[][]
;returns the array from the 2nd dimension of a 2d array
indx, imulti[][] xin
icount = 0
ilen lenarray imulti, 2
iout[] init ilen
until (icount == ilen) do
    iout[icount] = imulti[indx][icount]
    icount += 1
od
xout iout
endop


opcode rescale, i, iiiii
ival, ioldmin, ioldmax, inewmin, inewmax  xin

ioldrange = ioldmax - ioldmin
inewrange = inewmax - inewmin
ioldsize = ival - ioldmin

xout ((inewrange / ioldrange) * ioldsize) + inewmin
endop


opcode rescalek, k, kkkkk
kval, koldmin, koldmax, knewmin, knewmax  xin

koldrange = koldmax - koldmin
knewrange = knewmax - knewmin
koldsize = kval - koldmin

xout ((knewrange / koldrange) * koldsize) + knewmin
endop

;randint returns a random integer inclusive of min and max
opcode randint, i, ii
imin, imax xin
xout round(random(imin, imax))
endop

opcode randint, k, kk
kmin, kmax xin
xout round(random(kmin, kmax))
endop

;;returns microtuning values from a scale table,
;;works with zero and fractional note numbers, and support for nonoctave scales.
;;fractional part is calculated between neighbouring notes.
opcode cpstun3,k,kKO
   knote, ktable,kforcetrig xin
   kbend frac knote
   ktrig changed knote, ktable,kforcetrig
   kn1 = int(knote)
   kf1 cpstun ktrig, kn1, ktable
   kf2 cpstun ktrig, kn1 + (1 * (kbend >= 0 ? 1:-1)), ktable
   kcps = kf1 * (kf2 / kf1) ^ abs(kbend)
xout kcps
endop

;;cps2deg
;;given a cps value, returns nearest scale degree and error value
;;the error value measures the deviation between the nearest scale degree,
;;and neighbouring note in the scale. Can be positive or negative.
;;see also cpstun3 and sclbend.
;;e.g. if iscl is standard 12edo and C4 = degree 0 
;;iresult, ierror cps2deg 440, gi12edo
;; iresult = 9, ierror = 0.0
;; 
opcode cps2deg, ii, io
  icps, iscl xin
  iscl = (iscl == 0 ? gi_CurrentScale : iscl)
  ibase table 2, iscl ;base frq
  iperiod table 1, iscl ;octave
  iratio = icps/ibase ;ratio
  idegs table 0, iscl ;no. of degrees
  i8ev = 0
  isign = 1
  if (iratio < 1) then
    isign = -1
    while (iratio < 1) do
      i8ev += 1
      iratio = icps*iperiod^i8ev/ibase
    od
  else
    isign = 1
    while (iratio >= iperiod) do
      i8ev += 1
      iratio = iratio / iperiod
    od
  endif
  iclosepit, itaberr _cslc_taberror iratio, iscl, 4, idegs + 4
  ;; adjust error
  ierrorsign signum itaberr
  ierrorsign = (ierrorsign == 0 ? 1:ierrorsign)
  ia table iclosepit, iscl
  ib table iclosepit + ierrorsign, iscl
  irefval = ia + itaberr
  ierror rescale irefval, ia, ib, 0, ierrorsign
  iresult = idegs*i8ev*isign + (iclosepit - 4)
  xout iresult, ierror*isign
endop

opcode cps2deg, kk, ko
  kcps, iscl xin
  iscl = (iscl == 0 ? gi_CurrentScale : iscl)
  ibase table 2, iscl ;base frq
  iperiod table 1, iscl ;octave
  idegs table 0, iscl ;no. of degrees
  k8evalt = 0
  kratioalt = kcps/ibase
  ksign = 1
  if (kratioalt >= 1) then
     ksign = 1
      while (kratioalt >= iperiod) do
         k8evalt += 1
         kratioalt = kratioalt / iperiod
      od
  else
      ksign = -1
      while (kratioalt < 1) do
         k8evalt += 1
         kratioalt = kcps*(iperiod^k8evalt)/ibase
      od
  endif
  kclosepitalt, ktaberralt _cslc_taberror kratioalt, iscl, 4, idegs + 4
  kerrorsignalt signum ktaberralt
  kerrorsignalt = (kerrorsignalt == 0 ? 1:kerrorsignalt)
  kaalt table kclosepitalt, iscl
  kbalt table kclosepitalt + kerrorsignalt, iscl
  krefvalalt = kaalt + ktaberralt
  kerroralt rescalek krefvalalt, kaalt, kbalt, 0, kerrorsignalt
  xout (kclosepitalt - 4) + (idegs * k8evalt) * ksign, kerroralt
endop

;overloading cps2deg with single value output. Useful for functional syntax 
opcode cps2deg, i, io
  icps, iscl xin
  iresult, ierror cps2deg icps, iscl
  xout iresult
endop

opcode cps2deg, k, ko
  kcps, iscl xin
  kresult, kerror cps2deg kcps, iscl
  xout kresult
endop

;;returns the pitch when given a scale degree and a modifier (pitchbend) channel.
;;channel control uses integers to reach the next scale degree
;;e.g. A channel value of -2 bends the pitch down 2 steps in the scale 
opcode sclbend, k,iSo
  iscldeg, Sbend, iscale xin
  iscale = (iscale == 0 ? gi_CurrentScale : iscale)
  icurrent, ierr cps2deg iscldeg, iscale
  kpitmod chnget Sbend
  knewpit cpstun3 kpitmod + ierr + icurrent, iscale
  xout knewpit
endop

opcode sclbend, k,KSo
  kscldeg, Sbend, iscale xin
  iscale = (iscale == 0 ? gi_CurrentScale : iscale)
  kcurrent, kerr cps2deg kscldeg, iscale
  kpitmod chnget Sbend
  knewpit cpstun3 kpitmod + kcurrent + kerr, iscale
  xout knewpit
endop

;very forgiving array indexing
;indices wrap around array length.
;negative indices count backwards from array kength
;note that just using wrap isn't suitable as wrap(-n,0,n) == n
;example
;iArr fillarray 4.5,4.6,4.7,4.8
;ndxarray(iArr,2.999) => 4.7
;ndxarray(iArr,5) => 4.6
;ndxarray(iArr,-2) => 4.7
opcode ndxarray, i,i[]i
iArr[], indx xin
ilen lenarray iArr
iresult = int(indx)
if (iresult >= ilen) then
   iresult = wrap(iresult, 0, ilen)
elseif (iresult < 0) then
   if (iresult = -ilen) then
      iresult = 0
   else
      iresult = wrap(iresult, 0, ilen)
   endif
endif
xout iArr[iresult]
endop


opcode ndxarray, k,k[]k
kArr[], kndx xin
klen lenarray kArr
kresult = int(kndx)
if (kresult >= klen) then
   kresult = wrap(kresult, 0, klen)
elseif (kresult < 0) then
   if (kresult = -klen) then
      kresult = 0
   else
      kresult = wrap(kresult, 0, klen)
   endif
endif
xout kArr[kresult]
endop

;;; mono returns 1 when the instance detects that a newer instance with the same instrument number
;;; has been launched. When used with turnoff it can be used for monophonic texture, while
;;; preserving envelope decays and extra time releases.
;;; example usage
;; if mono()==1 then 
;; turnoff 
;; endif
opcode mono, k, 0
koff = 0
iexists _cslc_find p1, gi_cslc_nstance
if (iexists == -1) then
   iexists _cslc_find  0, gi_cslc_nstance
   instid = 1
   tablew p1, iexists, gi_cslc_nstance
   tablew instid, iexists, gi_cslc_nstance_cnt
elseif (iexists > -1) then
   instid = table(iexists, gi_cslc_nstance_cnt) + 1
   tablew instid, iexists, gi_cslc_nstance_cnt
endif
knstid table iexists, gi_cslc_nstance_cnt
if (knstid != instid) then
   koff = 1
endif
xout koff
endop

;converts a karray to an iarray
opcode castarray, i[],k[]
kArr[] xin
ilen lenarray kArr
iArr[] init ilen; lenarray(kArr)
indx = 0
;until indx == lenarray:i(iArr) do
until indx >= ilen do
   ival = i(kArr, indx)
   iArr[indx] = ival
   indx += 1 
od
xout iArr
endop

;iarray to karray... redundant syntactic sugar
opcode castarray,k[],i[]
iArr[] xin
kout[] = iArr
xout kout
endop

;short wrappers to castarray to save typing
opcode ca, k[],i[]
   iArr[] xin
   kArr[] castarray iArr 
   xout kArr
endop 

opcode ca, i[],k[]
   kArr[] xin
   iArr[] castarray kArr 
   xout iArr
endop 

;truncatearray, shorten or extend an array.
;when extending, values in the input array are
;repeated until k/ilen is reached.
;optional argument sums an increment to each element.
;Good for introducing variations when extending.
opcode truncatearray, k[],k[]kO
  kArr[],klen,kinc xin
  kResult[] init i(klen)
  kndx = 0
  kval = 0
  kinctrack = kinc
  until (kndx >= klen) do
    kval = kArr[kndx % lenarray(kArr)]
    kResult[kndx] = kval + kinctrack
    kndx += 1
    kinctrack += kinc
  od
  xout kResult
endop

opcode truncatearray, i[],i[]io
  iArr[],ilen,iinc xin
  iResult[] init ilen
  indx = 0
  ival = 0
  iinctrack = 0
  until (indx >= ilen) do
    ival = iArr[indx % lenarray(iArr)]
    iResult[indx] = ival + iinctrack
    indx += 1
    iinctrack += iinc
  od
  xout iResult
endop

;weighted random choices from an array.
;The first array (kchoices[]) is the selection of values
;the second array (kweights) specifies relative probability of selecting
;the values in kchoices at the same indices.
;note that kweights will match the length of kchoices using the truncatearray opcode.
opcode wchoice, i,k[]k[]
kchoices[], kweights[]xin
  iweightsa[] castarray kweights
  ichoices[] castarray kchoices
  ilen lenarray ichoices
  indx = 0
  iweights[] truncatearray iweightsa, ilen
  isum _cslc_sumarray2 iweights
  irnd random 0, isum
  iupto = 0
  until (indx >= ilen) do
    ic = ichoices[indx]
    iw = iweights[indx % lenarray(iweights)]
    if ((iupto + iw) >= irnd) then
      igoto RESULT
    else
      iupto += iw
    endif
    indx += 1
  od
  RESULT:
  xout ic
endop

;;for 

;returns an array of differences between values in an array.
;e.g. _cslc_arraydeltas(fillarray(2,3,2,1))
;returns an array of 2,1,-1,-1
opcode _cslc_arraydeltas, k[],k[]
kinArr[] xin
koutArr[] init lenarray(kinArr) - 1
kndx = 1
kval = 0
klastval = kinArr[0]
until (kndx == lenarray(kinArr)) do
    kval = kinArr[kndx]
    koutval = kval - klastval
    koutArr[kndx - 1] = koutval
    klastval = kval
    kndx += 1
od
xout koutArr
endop

opcode _cslc_arraydeltas, i[],i[]
iinArr[] xin
ioutArr[] init lenarray(iinArr) - 1
indx = 1
ival = 0
ilastval = iinArr[0]
until (indx == lenarray(iinArr)) do
    ival = iinArr[indx]
    ioutval = ival - ilastval
    ioutArr[indx - 1] = ioutval
    ilastval = ival
    indx += 1
od
xout ioutArr
endop

;;
opcode rotatearray, i[],i[]i
iinArr[], ishift  xin

ilen lenarray iinArr
ioutArr[] init ilen
indx = 0
until (indx == ilen) do
;    ioutArr[indx] = iinArr[(indx + ishift) % ilen]
    ioutArr[indx] = ndxarray(iinArr, (indx + ishift))
    indx += 1
od

xout ioutArr
endop

opcode rotatearray, k[],k[]i
kinArr[], ishift  xin
klen init lenarray(kinArr)
koutArr[] init i(klen)
kndx = 0
until (kndx == klen) do
;    koutArr[kndx] = kinArr[(kndx + ishift) % klen]
    koutArr[kndx] = ndxarray(kinArr, (kndx + ishift))
    kndx += 1
od

xout koutArr
endop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remove duplates from arrays
;;; (also removes duplacate zero's)
opcode dedupe, i[],i[]
   isrcArr[] xin
   isrclen lenarray isrcArr
   ideletionflags[] init isrclen
   ;;; ok, now fill in the deletionflags
   indx = 0
   until (indx >= isrclen) do
      icmpArr[] cmp isrcArr, "==", isrcArr[indx]
      isum sumarray icmpArr
      if isum > 1 then
         icmpndx = 0
         icnt = 0
         until (icnt >= 1) do
            if (icmpArr[icmpndx] == 1) then
               icmpArr[icmpndx] = 0
               icnt += 1 
            endif
         icmpndx += 1
         od
         ideletionflags[] = ideletionflags + icmpArr
      endif
      indx += 1
   od
   iresult[] init isrclen - sumarray(limit(ideletionflags, 0, 1))
   iresndx = 0
   isrcndx = 0
   until isrcndx >= isrclen do
      if ideletionflags[isrcndx] >= 1 then
      ;don't add to iresult
      else
      iresult[iresndx] = isrcArr[isrcndx]
      iresndx += 1
      endif
      isrcndx += 1
   od
   xout iresult
endop

opcode dedupe, k[],k[]
   ksrcArr[] xin
   isrclen lenarray ksrcArr
   kdeletionflags[] init isrclen
   ;;; ok, now fill in the deletionflags
   kndx = 0
   until (kndx >= isrclen) do
      kcmpArr[] cmp ksrcArr, "==", ksrcArr[kndx]
      ksum sumarray kcmpArr
      if ksum > 1 then
         kcmpndx = 0
         kcnt = 0
         until (kcnt >= 1) do
            if (kcmpArr[kcmpndx] == 1) then
               kcmpArr[kcmpndx] = 0
               kcnt += 1 
            endif
         kcmpndx += 1
         od
         kdeletionflags[] = kdeletionflags + kcmpArr
      endif
      kndx += 1
   od
   ;using genarray as slight hack to create array with krate length instead of init
   kresult[] genarray 1, isrclen - sumarray(limit(kdeletionflags, 0, 1)), 1
   kresndx = 0
   ksrcndx = 0
   until ksrcndx >= isrclen do
      if kdeletionflags[ksrcndx] >= 1 then
      else
      kresult[kresndx] = ksrcArr[ksrcndx]
      kresndx += 1
      endif
      ksrcndx += 1
   od
   xout kresult
endop

;;;concatenates 5x -rate arrays. Used in loopevent.
;; Note that public versions of catarray are generated at performance time
;; with the _cslc_catarrayoload UDO
opcode _cslc_catarray, i[],i[]i[]i[]i[]i[]j
    iarr1[],iarr2[],iarr3[],iarr4[],iarr5[],iargs xin
    iresult[] init lenarray(iarr1) + lenarray(iarr2)
    iargs = (iargs == -1 ? 4 : iargs)
    indx = 0
    until indx = lenarray(iresult) do
      if indx < lenarray(iarr1) then
         iresult[indx] = iarr1[indx]
      else
         iresult[indx] = iarr2[indx - lenarray(iarr1)]
      endif
         indx += 1
      od
      iargs -= 1
       if iargs > 0 then
          iresult[] _cslc_catarray iresult,iarr3,iarr4,iarr5,iarr5,iargs
      endif
xout iresult
endop




;Given an array of select scale degrees,
;returns an array with 'in-between' degrees inserted.
;example:
;passing(array(0,3,6))
;=> [0,2,3,5,6,10]
opcode passing, i[],i[]j
ichrd[],iskew xin
iskew = (iskew == -1 ? 0.5:iskew)

iArr3[] rotatearray ichrd, 1

iArr4[] linlin iskew, ichrd, iArr3 
iArr5[] interleave ichrd, iArr4  
iArr6[] round iArr5
ilastndx = lenarray(iArr6) - 1
if iArr6[ilastndx] < iArr6[ilastndx - 1] then 
   iArr6[ilastndx] = iArr6[ilastndx] + table(0, gi_CurrentScale)
endif
xout dedupe(iArr6)
endop

opcode passing, k[],k[]V
kchrd[],kskew xin

kArr3[] rotatearray kchrd, 1

kArr4[] linlin kskew, kchrd, kArr3 
kArr5[] interleave kchrd, kArr4  
kArr6[] round kArr5
klastndx = lenarray(kArr6) - 1
if kArr6[klastndx] < kArr6[klastndx - 1] then 
   kArr6[klastndx] = kArr6[klastndx] + table(0, gi_CurrentScale)
endif
kresult[] dedupe kArr6
xout kresult
endop


;compares the contents of two tables
;returns 1 if the tables are identical, or 0 if there are differences.
opcode _cslc_tableeqv, i,ii
iaft, ibft xin

ialen tableng iaft
iblen tableng ibft
ishortlen = (ialen < iblen ? ialen : iblen)
iresult = 1
indx = 0
until (indx == ishortlen) do
    iaval tab_i indx, iaft
    ibval tab_i indx, ibft
    cigoto (iaval != ibval), EXITFAIL
    indx += 1
od
igoto EXIT
EXITFAIL:
iresult = 0
EXIT:
xout iresult
endop

;compares values stored in two ftables.
;returns an array of indices where values stored in
;ifta match values in iftb
;iastart, ibstart and iaend, ibend select a sections of the tables to examine.
;defaults are zero - whole tables are compared
opcode _cslc_matchindices, i[],iioooo
iaft, ibft, iastart, ibstart, iaend, ibend xin
if (iaend == 0) then
   iaend tableng iaft
endif
if (ibend == 0) then
   ibend tableng ibft
endif
iresult[] init (iaend - iastart)
ifound = 0
until (iastart >= iaend) do
    iaval tab_i iastart, iaft
    ibndx = ibstart
    until (ibndx >= ibend) do
        ibval tab_i ibndx, ibft
        if (ibval == iaval) then
           iresult[ifound] = ibndx - ibstart
           ifound += 1
        endif
        ibndx += 1
    od
    iastart += 1
od
xout iresult
endop

;;sets the current scale to a mode from superscale
;;; Optional arg to specify the table num
;;;defaults to gi_CurrentScale
opcode scalemode, 0, iii[]j
isuperscale, ikeyctr, iSuperscaleIntervalPattern[], idestifn xin

if (idestifn == -1) then
   idestifn = gi_CurrentScale
endif

isubpattern[] init lenarray(iSuperscaleIntervalPattern)
isubpattern[0] = 0
isubpndx init 1

until (isubpndx == lenarray(isubpattern)) do
isubpattern[isubpndx] = isubpattern[isubpndx - 1] + iSuperscaleIntervalPattern[isubpndx - 1]
isubpndx += 1
od

inumgrades table 0, isuperscale
iindinums[] init lenarray(isubpattern)
indx init 0
ilast init 0
iscaleroot init 0
iscalekeyctrndx init -1
ival init 0

iindices[] = iindinums

until indx == lenarray(iindices) do
ival = isubpattern[indx]
iindices[indx] = wrap:i(ival + ikeyctr, 0, inumgrades)

indx += 1
od

ilastvalfromsuper table inumgrades + 4, isuperscale
imodularval table wrap:i(ikeyctr, 0, inumgrades) + 4, isuperscale

isorted[] sorta iindices ; 
iscaleroot = isorted[0]

;;copy the initial values from the super scale
ilen init 0
ilen lenarray isorted
tableiw ilen, 0, idestifn ; degree nums
tableiw table:i(1, isuperscale), 1, idestifn ;octave value
tableiw table:i(2, isuperscale), 2, idestifn ;base freq
tableiw table:i(3, isuperscale), 3, idestifn ;key ctr

indx = 0
until (indx == ilen) do
  isortedndx = isorted[indx]
  irevisedval table isortedndx + 4, isuperscale
  tableiw irevisedval, indx + 4, idestifn
  if (irevisedval == imodularval) then
      iscalekeyctrndx = indx
  endif
  indx += 1
od
tableiw table:i(4,idestifn)    * ilastvalfromsuper, ilen + 4, idestifn

giTonic_ndx = iscalekeyctrndx

if (gi_SuperScale == 0) then
   gi_SuperScale = isuperscale
elseif (_cslc_tableeqv(gi_SuperScale, isuperscale) == 0) then
   gi_SuperScale = isuperscale
   ;tablecopy gi_SuperScale, isuperscalefn
else
   ;pass
endif   
endop

;This is just a wrapper for the irate array version 
;but is useful when using inline arrays which default to krate.
;e.g. scalemode gi_31edo, 0, array(5,5,3,5,5,5,3)
opcode scalemode, 0, iik[]j
isuperscale, ikeyctr, kSuperscaleIntervalPattern[],idestfn xin
iSuperscaleIntervalPattern[] castarray kSuperscaleIntervalPattern
scalemode isuperscale, ikeyctr, iSuperscaleIntervalPattern,idestfn
endop

;scaleModulate A quirky a wrapper around the scalemode opcode.
;scaleModulate changes the gi_CurrentScale by rotating the interval pattern between steps, and 
;shifting the reference degree for the mode. Clever, but easy to lose where you came from.
;iinterval = the degree to shift the tonic key to.
;imoderef = The degree of rotation of the scale.
;ichromatic = shifts the keycentre n steps in gi_Superscale.
;examples:
;;;;Setup C major in 12edo
;scalemode gi_12edo, 0, array(2,2,1,2,2,2,1)
;;now change to A minor (degree 5 = A in C Major, mode = 5 (aeolian, aka relative minor)) 
;scaleModulate 5,5   ;
;
;;change to A major 
;scaleModulate 0,2 ; (already on A, so no need to shift, moderef goes to degree 2 in aeolian, which converts is to major (Ionian, or relative major))
;
;;back to C Major
;scaleModulate 2,0 ; (now transpose up 2 degree back to C, already in major, so no need to change)
;

;;Start in C major in 31edo
;scalemode31 0, 1
;;move to D major
;scaleModulate 1
;
;;change to d Dorian 
;scaleModulate 0,1 ;
;
;;now to C Minor (aeolian)
;scaleModulate -1, 3
;
opcode scaleModulate, 0,ioo
iinterval, imoderef, ichromatic xin
iindices[] _cslc_matchindices gi_CurrentScale, gi_SuperScale, 4, 4, tab_i(0, gi_CurrentScale) + 5, tab_i(0, gi_SuperScale) + 5
itestend = -1
ilastval = ndxarray(iindices, itestend)
ilastdiff = 0  
until (ilastval != 0) do
   ilastdiff = (tab_i(0,gi_SuperScale) - ilastval) + iindices[0]
   iindices[lenarray(iindices) + itestend] = ilastdiff
   itestend -= 1
   ilastval = ndxarray(iindices, itestend)
od
iintervalpattern[] _cslc_arraydeltas iindices
icurrentmode[] rotatearray iintervalpattern, giTonic_ndx
inewslice[] _cslc_slicearray2 icurrentmode, 0, wrap(iinterval + giTonic_ndx, 0, lenarray(icurrentmode))
inewkeyctr _cslc_sumarray2 inewslice
printf_i "mode shift = %d\n", 1, inewkeyctr
inewmode[] rotatearray icurrentmode, imoderef
scalemode gi_SuperScale, inewkeyctr+ichromatic, inewmode
endop

;31edo version
opcode scalemode31, 0, io
;wrapper just for the 31edo mode matrix
;imode 0=default, 3=DiaDom7, 4=MinDom7, 1=Diatonic, 2=Minor,5=Diminished,6=neutral,7=Orwell[9]
idegree, imode  xin
if (imode == 0) then
  scalemode gi_31edo, idegree, _cslc_get2dArr(idegree, gi_cslc_31Modes)
elseif (imode == 3) then
  scalemode gi_31edo, idegree, gi31DiaDom7
elseif (imode == 4) then
  scalemode gi_31edo, idegree, gi31MinDom7
elseif (imode == 1) then
  scalemode gi_31edo, idegree, gi31Diatonic
elseif (imode == 2) then
  scalemode gi_31edo, idegree, gi31NaturalMinor
elseif (imode == 5) then
  scalemode gi_31edo, idegree, gi31Diminished
elseif (imode == 6) then
  scalemode gi_31edo, idegree, gi31Neutral
elseif (imode == 7) then
  scalemode gi_31edo, idegree, gi31Orwell
else
  scalemode gi_31edo, idegree, _cslc_get2dArr(idegree, gi_cslc_31Modes)
endif
endop

;Get the current time
opcode now, i, 0
xout i(gk_now)
endop

opcode cosr, i, ijo
;translated from impromptu's cosr macro
;does a complete cosine cycle, with multiplier and offset for convenience
;iamp defaults to 0.5
;ioffset defaults to 0.5 if iamp is not set, otherwise defaults to 1
iperiod, iamp, ioffset xin
if (iamp == -1) then
 iamp = 0.5
 ioffset = 0.5
endif
xout cos(divz:i(1,iperiod,0) * (2 * $M_PI) * now()) * iamp + ioffset
endop

;set the speed of the clock in bpm
opcode temposet, 0, i
ibpm xin
gk_tempo init ibpm
endop

;get the tempo in bpm
opcode tempoget, i, 0
xout i(gk_tempo)
endop

;return the duration in seconds for the duration measured by clock tempo.
;e.g. If tempo = 120, tempodur(3) => 1.5
opcode tempodur, i, p
idur xin
iresult divz 60, i(gk_tempo), -1
xout iresult * idur
endop

;k-rate version
opcode tempodur_k, k, k
kdur xin
kresult divz 60, gk_tempo, -1
xout kresult * kdur
endop

opcode _cslc_accumarray, k[], k[]
kArrSrc[] xin

kArrRes[] init lenarray(kArrSrc)

konce init 0
ckgoto (konce == 1), terminate

kndx    init       0

ksum init 0
until (kndx == lenarray(kArrSrc)) do
  kresult   =  ksum + kArrSrc[kndx]
  kArrRes[kndx] = kresult
  ksum      =  kresult
  kndx     = kndx + 1
od

konce = 1

terminate:
xout kArrRes
endop

opcode _cslc_accumarray, i[], i[]
iArrSrc[] xin

iArrRes[] init lenarray(iArrSrc)

indx = 0
isum = 0
until (indx == lenarray(iArrSrc)) do
  iresult   =  isum + iArrSrc[indx]
  iArrRes[indx] = iresult
  isum      =  iresult
  indx     = indx + 1
od

xout iArrRes
endop


opcode nextbeat, i, p
ibeatcount xin
if ibeatcount == 0 then
iresult = 0
else
inow = now()
ibc = frac(ibeatcount)
inudge = int(ibeatcount)
iresult = inudge + ibc + (round(divz(inow, ibc, inow)) * (ibc == 0 ? 1 : ibc)) - inow
endif
xout tempodur(iresult)
endop

;;onbeat returns the duration until the next beat in a bar.
;;imindur sets a minimum threshhold for the duration, and adds imindur to the result. 
;; - When using loops, imindur of 1/kr is recommended to avoid endless loops (because onbeat is itime, so it can return the same value).
;; - a negative imindur ignores the immediate beat and returns the next beat. 
opcode onbeat, i, ppoo
ibeatnum, ibarlen,imindur,inowdiff xin

ideltime wrap (ibeatnum % ibarlen) - (now()-inowdiff % ibarlen), 0, ibarlen

;; if (ideltime <= 1/kr) then
;;   ideltime  =  ibarlen - ideltime ;
;; endif

idelout = tempodur(ideltime)

if imindur == 0 then
   ;pass
elseif (idelout <= imindur) then
  idelout += imindur;  ibarlen - ideltime ; or 1/kr;
elseif (imindur < 0) then
  iabsmindur = abs(imindur)
  if (idelout <= iabsmindur) then
     ideltime  =  ibarlen - ideltime ;
     idelout = tempodur(ideltime)
  endif
endif
xout idelout
endop

opcode _cslc_updateActiveChans, i, S
Schan xin
indx = 0
ientered = 0
until (indx >= lenarray(gS_cslc_ActiveChans)) do
   Sval = gS_cslc_ActiveChans[indx]
   ilen strlen Sval
   if (ilen > 0) then ;if there's a channel
    if (strcmp(Sval, Schan) == 0) then ;and if it's the same as this one.
      tableiw table:i(indx, gi_cslc_chanfn) + 1, indx, gi_cslc_chanfn ; increment the count of active chans   
      ientered = 1
      igoto BREAK
    else
      indx += 1
    endif
   else
      igoto BREAK
   endif
od
BREAK:
if (ientered == 0) then
   gS_cslc_ActiveChans[indx] = Schan
   tableiw 1, indx, gi_cslc_chanfn
endif
xout indx      
endop

;linslide updates a channel (Schan) to move from it's current value to reach idest over idur time. 
;idel - the slide starts on nextbeat(idel) time (default 1)
;duration measured in tempodur(n)
;itype curve as per transeg itype
;iendreset - when non-zero the channel value returns to initval on release 
;initval - set an initial value to start from. Default (uses -1) is to use the current stored value for the channel. 
;example usage: linslide "fluteamp1", 10, 0.3
;results in the "fluteamp1 channel to linearly change from it's current value to 0.3 over 10 beats. 
;linslide runs at itime only, but launches an event (i3) to update Schan at krate.
;only one linslide instance for the specified Schan will run. If an Schan is already being updated by a running linslide then the older linslide instance is terminated.
opcode linslide, 0, Siipooj
  Schan, idur, idest, idel, itype, iendreset, initval  xin  
instndx = _cslc_updateActiveChans(Schan)
ist = nextbeat(idel) ;default is nextbeat(1)
Sout sprintf "i3 %f %f \"%s\" %f %f %f %f %d", ist, tempodur(idur), Schan, idest, itype, iendreset, initval, instndx
scoreline_i Sout
endop

;A state saving counter, using a channel name.
opcode counterChan, i, Spoo
Schan, iincrement, imodulo, ilower  xin
icurrent chnget Schan
if (imodulo < ilower) then
   itmp = imodulo
   imodulo = ilower
   ilower = itmp
endif
if (imodulo != 0) then
   icurrent = wrap(icurrent, ilower, imodulo)
   inewval = wrap((icurrent + iincrement), ilower, imodulo)
else
   inewval = icurrent + iincrement
endif
chnset inewval, Schan
xout icurrent
endop

opcode counterChan, K, SPOO
;state saving counter. krate, but one-shot.
Schan, kincrement, kmodulo, klower  xin
konce init 0
ckgoto (konce == 1), terminate
;;swap 
if (kmodulo < klower) then
   ktmp = kmodulo
   kmodulo = klower
   klower = ktmp
endif
kcurrent chnget Schan
if (kmodulo != 0) then
   kcurrent = wrap(kcurrent, klower, kmodulo)
   knewval = wrap((kcurrent + kincrement), klower, kmodulo)
else
   knewval = kcurrent + kincrement
endif
chnset knewval, Schan
konce = 1
terminate:
xout kcurrent
endop

;;a version which rotates an array on each call. Uses a channel name as a unique ID.
opcode rotatearray, k[],k[]Sp
kinArr[], Sid,iincr xin
klen init lenarray(kinArr)
koutArr[] init i(klen)
kndx = 0
kshift counterChan Sid, iincr; [, iincrement, imodulo, ilower]
until (kndx == klen) do
    koutArr[kndx] = ndxarray(kinArr, (kndx + kshift))
    kndx += 1
od
xout koutArr
endop

;returns successive values in an array on every call
;Sid is a string (any unique string), to store the state of each instance.
;idirection increments the index. Can be negative (will return values in reverse order), and fractional (floors the index).
;ist, iend wraps the sart and end values of the index. default to 0, lenarray, and large values than lenarray wrap, so never go out of bounds. 
;if iend is negative , it counts backwards from the array length (i.e. -iend == lenarray(kArr) - 1)
opcode iterArr,i,k[]Spoo
kArr[], Sid, idirection, ist, iend xin
imustend = lenarray(kArr)
imustbegin = 0
if (iend == 0) then 
   iend = imustend
elseif (iend < 0) then
   iend = wrap(abs(imustend + iend), 0, imustend)
endif 
iend = limit(iend, 0, imustend)
ist = limit(ist, 0, imustend)
ival counterChan Sid, idirection, iend, ist; [, iincrement, imodulo, ilower]
ival = (ival >= imustend ? (ival % imustend):ival)
iout = i(kArr, floor(ival))
xout iout
endop

opcode iterArr,i,i[]Spoo
iArr[], Sid, idirection, ist, iend xin
imustend = lenarray(iArr)
imustbegin = 0
if (iend == 0) then 
   iend = imustend
elseif (iend < 0) then
   iend = wrap(abs(imustend + iend), 0, imustend)
endif 
iend = limit(iend, 0, imustend)
ist = limit(ist, 0, imustend)
ival counterChan Sid, idirection, iend, ist; [, iincrement, imodulo, ilower]
ival = (ival >= imustend ? (ival % imustend):ival)
iout = iArr[floor(ival)]
xout iout
endop

;;returns the scheduled time to reach the next beat value in an array
;;nextrh uses a string ID for the instance. The convenience wrappers use p1 in the calling instrument.
;;note: if the array has a negative value, nextrh first calculates the scheduled time 
;;for the absolute value, then returns the negative signed equivalent. 
opcode nextrh,i,k[]Spp
  krh[], Sid, idirection,iminkp xin
  irh[] = krh
  iabsrh[] abs irh
  irhsignums[] = cmp(irh,">",0) - cmp(irh,"<",0)
  ibarlen sumarray iabsrh
  iaccumarray[] _cslc_accumarray iabsrh
  imodArr[] = iaccumarray - iaccumarray[0] 
  isignumval = irhsignums[chnget:i(Sid)]
  iselectval = iterArr(imodArr, Sid, idirection)
  xout onbeat(iselectval, ibarlen,iminkp/kr) * isignumval
endop

opcode nextrh, i,i[]Spp
  irh[], Sid,idirection,iminkp xin
  iabsrh[] abs irh
  ;irhsignums[] maparray irh,"signum" ;buggy when array size is changed
  irhsignums[] = cmp(irh,">",0) - cmp(irh,"<",0)
  ibarlen sumarray iabsrh
  iaccumarray[] _cslc_accumarray iabsrh
  imodArr[] = iaccumarray - iaccumarray[0] 
  isignumval = irhsignums[chnget:i(Sid) % lenarray(irh)]
  iselectval = iterArr(imodArr, Sid, idirection)
  xout onbeat(iselectval, ibarlen,iminkp/kr) * isignumval
endop

;convenience wrappers using p1 as ID. Only one per instrument.
opcode nextrh, i,k[]p
  krh[], iminkp xin
  Sid sprintf "nrh%f", p1
  iresult nextrh krh, Sid, 1,iminkp  
  xout iresult
endop

opcode nextrh, i,i[]p
  irh[], iminkp xin
  Sid sprintf "nrh%f", p1
  iresult nextrh irh, Sid, 1,iminkp  
  xout iresult
endop

;Oscillates between two values. Uses a channel name as a unique ID. 
opcode seesaw, i,iiS
ione, itwo, Sid xin
iArr[] init 2
iArr[0] = ione
iArr[1] = itwo
iresult iterArr iArr, Sid
xout iresult
endop

;A version of seesaw that uses p1 in the calling instrument as an ID
;instead of a channel name.
opcode seesaw, i,ii
ione, itwo xin
Sid sprintf "swsw%f", p1
iresult seesaw ione, itwo, Sid
xout iresult
endop

;A random walk on each call.
opcode walker, i, Spoo
Schan, istepsize, imodulo, ilower xin
if ilower > imodulo then
   itemp = imodulo
   imodulo = ilower
   ilower = itemp
endif
icurrent chnget Schan
istepsize = istepsize * signum(rnd31(1,1))

if (imodulo != 0) then
   icurrent = mirror(icurrent, ilower, imodulo)
   inewval = mirror((icurrent + istepsize), ilower, imodulo)
else
   inewval = icurrent + istepsize
endif
chnset inewval, Schan
xout icurrent
endop

;randomly select an integer at i-rate.
;ival randselect_i ia, ib, ic ...
opcode randselect_i, i, ijjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ival1, ival2, ival3, ival4, ival5, ival6, ival7, ival8, ival9, ival10, ival11, ival12, ival13, ival14, ival15, ival16, \
ival17, ival18, ival19, ival20, ival21, ival22, ival23, ival24, ival25, ival26, ival27, ival28, ival29, ival30, ival31, ival32 xin
iargArray[] array ival32, ival31, ival30, ival29, ival28, ival27, ival26, ival25, ival24, ival23, ival22, ival21, ival20, ival19, ival18, ival17, ival16, ival15, ival14, ival13, ival12, ival11, ival10, ival9, ival8, ival7, ival6, ival5, ival4, ival3, ival2, ival1
istart = 0
until (iargArray[istart] != -1) do
istart += 1
od
iout = iargArray[int(random(istart, lenarray(iargArray)))]
xout iout
endop

;remainder division  
opcode _cslc_remaindiv, ii,ii
ia, ib xin
idivresult = ia / ib
if (ia < 0) then
   idivresult = ceil(idivresult)
else
   idivresult = floor(idivresult)
endif
xout idivresult, ia % ib 
endop  

;scldegmatch returns the index in isclfn2 which matches the value returned by idegree in isclfn1
;useful when you want the superscale degree in isclfn2 which gives the same pitch from the degree in sclfn1
;Default tables are gi_CurrentScale and gi_SuperScale respectively.
;example:
;;Set the Super Scale to be 94 edo
;gi_SuperScale = TBedn(94, 263, 0);
;
;;set the Current Scale to be an approximate just diatonic major from 94edo 
;gi94major[] array 16, 16, 7, 16, 16, 16, 7
;scalemode gi_SuperScale, 0, gi94major
;
;;get the pitch two chromatic steps higher than the just major 3rd.
;ipitch = cpstuni(scldegmatch(2) + 2, gi_SuperScale)
opcode scldegmatch, i,ijj
idegree, isclfn1, isclfn2 xin
  isclfn1 = (isclfn1 == -1 ? gi_CurrentScale : isclfn1)
  isclfn2 = (isclfn2 == -1 ? gi_SuperScale : isclfn2)
  icp = table:i(0, isclfn1)
  isp = table:i(0, isclfn2)
  idiv, irem _cslc_remaindiv idegree, icp
  imatches[] _cslc_matchindices isclfn1, isclfn2, 4,4, icp + 4
  imatchndx = ndxarray(imatches, irem)
  if (idegree < 0) then  
    iresult = (isp * (imatchndx % icp == 0 ? idiv:idiv - 1))  + imatchndx 
  else
    iresult = (isp * idiv) + imatchndx     
  endif
xout iresult
  
endop  

;a wrapper around a power curve really. 
;ipower < 0.5 = convex fast to approach 1
;ipower > 0.5 - concave slow to approach 1
;expects ival to be between 0 - 1. Other values allowed, and might be useful...
;if ipower == 0.5 or 1.00 returns the value unchanged (straight line)
;defaults to a straight line.
opcode curve,i,ip
ival, ipower xin

if (ipower == 1) then
ipower = 1
elseif (ipower == 0.5) then
ipower = 1
elseif ipower > 0.5 then
ipower = rescale(ipower, 0.5, 1.0, 1, 3.5)
else
ipower = ipower * 2
endif

xout ival ^ ipower
endop


opcode curvek,K,KK
kval, kpower xin

if (kpower == 1) then
kpower = 1
elseif (kpower == 0.5) then
kpower = 1
elseif kpower > 0.5 then
kpower = rescalek(kpower, 0.5, 1.0, 1, 3.5)
else
kpower = kpower * 2
endif

kresult pow kval, kpower

xout kresult
endop

opcode _cslc_onsetArrayLength_i, i, i[]io
;return the the minimum length required to build an onset array, with overlap
iArrSrc[], idur, ioverlap xin
isum = 0
indx = 0

ilenSrc lenarray iArrSrc
until (indx >= ilenSrc) do
  isum      +=        iArrSrc[indx]
  indx      +=        1
od

isum = isum + ioverlap

iresult = ceil(idur) / isum
inewlen = iresult * ilenSrc 

isumtruncated = iresult * isum 
istepback = 0

if (isumtruncated > idur) then 
isumtruncated -= ioverlap 
endif

until (isumtruncated <= idur) do
  istepback +=        1 
  ilook     =  (ilenSrc - istepback) % ilenSrc 
  isumtruncated       -=  iArrSrc[ilook]
od
inewlen -= istepback 

xout inewlen
endop

opcode _cslc_onsetArrayLength_i, i, k[]KO
;return the the minimum length required to build an onset array, with overlap
kArrSrc[], kdur, koverlap xin
isum = 0
indx = 0

ilenSrc lenarray kArrSrc
until (indx >= ilenSrc) do
  isum      +=        i(kArrSrc, indx)
  indx      +=        1
od

isum = isum + i(koverlap)

iresult = ceil(i(kdur) / isum)
inewlen = iresult * ilenSrc 

isumtruncated = iresult * isum 
istepback = 0

if (isumtruncated > i(kdur)) then 
isumtruncated -= i(koverlap) 
endif

until (isumtruncated <= i(kdur)) do
  istepback +=        1 
  ilook     =  (ilenSrc - istepback) % ilenSrc 
  isumtruncated       -=  i(kArrSrc, ilook)
od
inewlen -= istepback 

xout inewlen
endop


opcode _cslc_onsetaccum, k[], k[]KO
;return an onset array
kArrSrc[], kdur, koverlap xin
ionsetlength _cslc_onsetArrayLength_i kArrSrc, kdur, koverlap ;
kArrRes[] init ionsetlength
iSrclen lenarray kArrSrc

kndx init 0
ksum init 0
ktrythisndx init 0  ;must re-init on subsequent calls.

while (kndx < ionsetlength) do
  ktrythisndx = kndx % iSrclen
  ksum      +=        kArrSrc[ktrythisndx]
  kArrRes[kndx] = ksum
  kndx      +=        1
  if ktrythisndx == 0 then
     ksum      +=        koverlap
  endif 
od

xout kArrRes
endop

opcode _cslc_onsetaccum, i[], i[]io
;return an onset array
iArrSrc[], idur, ioverlap xin
ionsetlength _cslc_onsetArrayLength_i iArrSrc, idur, ioverlap ;
iArrRes[] init ionsetlength
iSrclen lenarray iArrSrc
indx init 0
isum init 0
itrythisndx init 0  ;must re-init on subsequent calls.
while (indx < ionsetlength) do
  itrythisndx = indx % iSrclen
  isum      +=        iArrSrc[itrythisndx]
  iArrRes[indx] = isum
  indx      +=        1
  if itrythisndx == 0 then
     isum      +=        ioverlap
  endif 
od
xout iArrRes
endop

;;return an array of euclidean rhythm values
;;eg. euclidean(8,3) => (3,2,2)
;;ibarlen multiplies values so the sum of the array = ibarlen
;;irotate, rotates the patterno
opcode euclidean, k[], iiooO
iseqlen, inumhits, ibarlen, irotate, kmode xin
imult = (ibarlen == 0 ? 1:ibarlen / iseqlen)
kcnt init 0
khits[] init iseqlen
kresult[] init inumhits
kresndx = -1
until kcnt >= iseqlen do
      if (((kcnt % iseqlen)*inumhits) % iseqlen) < inumhits then
         khits[kcnt] = imult
         kresndx += 1
      else
         khits[kcnt] = 0
      endif      
      kresult[kresndx] = kresult[kresndx] + imult
      kcnt += 1
od

if (kmode == 1) then 
kout[] = khits
else
kout[] = kresult
endif

xout rotatearray(kout, irotate)
endop

opcode euclidean_i, i[], iiooo
iseqlen, inumhits, ibarlen, irotate, imode xin
imult = (ibarlen == 0 ? 1:ibarlen / iseqlen)
icnt init 0
ihits[] init iseqlen
iresult[] init inumhits
iresndx = -1
until icnt >= iseqlen do
      if (((icnt % iseqlen)*inumhits) % iseqlen) < inumhits then
         ihits[icnt] = imult
         iresndx += 1
      else
         ihits[icnt] = 0
      endif      
      iresult[iresndx] = iresult[iresndx] + imult
      icnt += 1
od
if (imode == 1) then 
iout[] = ihits
else
iout[] = iresult
endif
xout rotatearray(iout, irotate)
endop

; orni UDO
;   koriginal[], \
;   kwhens[], kdurs[], kamps[], kintervals[] [, kp6] [,kp7] [,...]\
;   korndur, kscale, koverlap xin

;   also... overloaded versions for convenience...
;   koriginal[], \
;   kwhens[], kamps[], kintervals[] [, kp6] [,kp7] [,...]\
;   korndur, kscale, koverlap xin

;   koriginal[], \
;   kwhens[], kintervals[] [, kp6] [,kp7] [,...]\
;   korndur, kscale, koverlap xin

;   koriginal[], \
;   iwhens, kintervals[] [, kp6] [,kp7] [,...]\
;   korndur, kscale, koverlap xin

; Generates a sequence of score events 
; 
; koriginal[] is an array of values which are treated like pfields in a score event.
; e.g. array(101, 0, 1, 0.8, 5) is equivalent to i101 0 1 0.8 5
;
;kwhens is an array specifying rhythmic intervals between generated events.

;kdurs[], kamps[], kintervals[], kp6[] etc... are numeric arrays. 
;The values in the arrays specify deviations in the generated events from the corresponding pfield in koriginal. 
;The deviations accumulate and are applied in a looped sequence for the length of orndur.
;For example using, kintervals[] array 2,-2, 1  will cause pitches in the generated events to ascend by 2steps, fall by 2steps, then ascend by 1, and repeat until orndur is reached.
;to keep a pfield constant, use array(0). To loop a set of values, ensure the sum of the array values equals zero.

; korndur sets the duration of the entire ornament. Defaults to the calling instruments p3.

; kscale is a table used by cpstun. defaults to gi_CurrentScale

; kpitbound sets upper or lower bounds to pitch generation. 
; If the sum of kintervals is positive an upper bound is set, with the lower bound being the pitch in koriginal.
; The reverse situation operates when the sum of kintervals is negative: i.e. a lower bound is set, with the upper bound being the pitch in koriginal.
; A positive kpitbound refects pitches using mirror. A negative kpitbound uses wrap.
; Default is 0 - no pitch boundaries.
;EXAMPLE
/*
instr 101

ares bellpno p4, p5, p6, p7, p8;kamp, ifrq, imod [, ir1, ir2]

ares declickr ares
chnmix ares, "outputC" 

endin

instr 11

ornament array(101, 0, 0.4, 0.2, -7, 2, 1, 1), array(0.125, 0.125, 0.125, randselect_i(0.125)), array(0), array(0), array(1), array(-0.1),\
array(0), array(1, -1), array(0), array(0),\
1.25,0

schedule p1, nextbeat(3), 5
turnoff
endin

schedule 11, nextbeat(1), 1
*/


;;; this version requires iorndur (duration of the ornament) to be provided.
opcode _cslc_ornimaster, 0, i[]i[]i[]i[]i[]i[]i[]i[]i[]i[]ioo
  ioriginal[], \
  iwhens[], idurs[], iamps[], iintervals[], ip6[], ip7[], ip8[], ip9[], ip10[], \
  iorndur,ipitbound,iscale xin

  ;a negative p1 is special, and forces instance instrument numbers  to increment
  iinsincr = (ioriginal[0] < 0 ? 0.01:0)

  indx      =         0                           
  ionce     =         0
  iplen lenarray ioriginal

  iscale    =  (iscale == 0 ? gi_CurrentScale : iscale)
  istarts[] _cslc_onsetaccum   iwhens, abs(iorndur), 0
  istartval =  tempodur(ioriginal[1]) ; I think this is always overwritten... could be removed?
  idurval   =  (iorndur < 0 ? abs(iorndur) - istartval + ioriginal[2] : ioriginal[2]) ;if orndur is negative, then generated note durs converge to abs(orndur) - startval.
  iampval   =  ioriginal[3]
  ipitval   =  ioriginal[4]
  idurndx   =         0
  iampndx   =         0
  ipitndx   =         0
  
  ;using this modulo purely to save on lots of conditionals
  ;the values are ignored if greater than iplen anyway
  ip6ndx    init      0  
  ip6val   =  ioriginal[5 % iplen]
  ip7ndx    init      0
  ip7val   =  ioriginal[6 % iplen]
  ip8ndx    init      0
  ip8val   =  ioriginal[7 % iplen]
  ip9ndx    init      0
  ip9val   =  ioriginal[8 % iplen]
  ip10ndx    init      0
  ip10val   =  ioriginal[9 % iplen]

  until     (indx >= lenarray(istarts)) do
    istartval =  tempodur(istarts[indx])

    if (iorndur < 0) then
    idurval = abs(iorndur) - istartval + ioriginal[2]
    else
    idurndx = indx % lenarray(idurs)
    idurval   +=        tempodur(idurs[idurndx])
    	  
    endif

    iampndx = indx % lenarray(iamps)
    iampval   +=        iamps[iampndx]
    ipitndx = indx % lenarray(iintervals)
    ipitval   +=        iintervals[ipitndx]

    
    if (ipitbound != 0) then
       idirection sumarray iintervals
       iboundlimit = abs(ipitbound)
       if (idirection < 0) then
          iupper = _cslc_maxarray2(iintervals) + ioriginal[4]
          ilower = ioriginal[4] - iboundlimit
       elseif (idirection > 0) then
          iupper = ioriginal[4] + iboundlimit
          ilower = _cslc_minarray2(iintervals) + ioriginal[4]
       else
          iupper = ioriginal[4] + iboundlimit
          ilower = ioriginal[4] - iboundlimit
       endif
       if (ipitbound < 0) then
          ipitvalb wrap ipitval, ilower, iupper
       elseif (ipitbound > 0) then
          ipitvalb mirror ipitval, ilower, iupper
       endif
    else
       ipitvalb = ipitval
    endif


    if (iplen == 5) then
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale)
    igoto break
    endif
    ip6ndx = indx % lenarray(ip6)
    ip6val    +=        ip6[ip6ndx]
    if (iplen == 6) then        
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale), \
                   ip6val
    igoto break
    endif
    ip7ndx = indx % lenarray(ip7)
    ip7val    +=        ip7[ip7ndx]
    if (iplen == 7) then
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale), \
                   ip6val, ip7val
    igoto break
    endif
    ip8ndx = indx % lenarray(ip8)
    ip8val    +=        ip8[ip8ndx]
    if (iplen == 8) then
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale), \
                   ip6val, ip7val, ip8val
    igoto break
    endif
    ip9ndx = indx % lenarray(ip9)
    ip9val    +=        ip9[ip9ndx]
    if (iplen == 9) then
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale), \
                   ip6val, ip7val, ip8val, ip9val
    igoto break
    endif

    ip10ndx = indx % lenarray(ip10)
    ip10val    +=        ip10[ip10ndx]
    if (iplen == 10) then
    event_i     "i", abs(ioriginal[0]) + (iinsincr * (indx + 1)), istartval, (abs(idurval) <= 0.0001 ? 0.0001 : idurval), \
                  (iampval < 0 ? 0 : iampval), cpstuni(ipitvalb, iscale), \
                   ip6val, ip7val, ip8val, ip9val, ip10val
    endif
   
    break:
    indx      +=        1
  od
endop

;_cslc_ornimaster interface opcodes
;note the karrays are converted to irate
;2 arrays and constant (i) rhythm
opcode orn, 0, k[]ik[]ioo
  koriginal[], \
  iwhen, kintervals[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(array(iwhen)), ca(array(0)), ca(array(0)), ca(kintervals), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;3 arrays = original, whens, intervals only, durs and amps constant
opcode orn, 0, k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kintervals[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(array(0)), ca(array(0)), ca(kintervals), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;4 arrays = original, whens, amps, intervals only - durs are constant
opcode orn, 0, k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kamps[], kintervals[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(array(0)), ca(kamps), ca(kintervals), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;p5
opcode orn, 0, k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop


;p6
opcode orn, 0, k[]k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], kp6[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(kp6), ca(array(0)), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;p7
opcode orn, 0, k[]k[]k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], kp6[], kp7[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(kp6), ca(kp7), ca(array(0)), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;p8
opcode orn, 0, k[]k[]k[]k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], kp6[], kp7[], kp8[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(kp6), ca(kp7), ca(kp8), ca(array(0)), ca(array(0)), iorndur, ipitbound, iscale
endop

;p9
opcode orn, 0, k[]k[]k[]k[]k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], kp6[], kp7[], kp8[], kp9[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(kp6), ca(kp7), ca(kp8), ca(kp9), ca(array(0)), iorndur, ipitbound, iscale
endop

;p10
opcode orn, 0, k[]k[]k[]k[]k[]k[]k[]k[]k[]k[]ioo
  koriginal[], \
  kwhens[], kdurs[], kamps[], kintervals[], kp6[], kp7[], kp8[], kp9[], kp10[], \
  iorndur, ipitbound, iscale xin
  _cslc_ornimaster ca(koriginal), ca(kwhens), ca(kdurs), ca(kamps), ca(kintervals), ca(kp6), ca(kp7), ca(kp8), ca(kp9), ca(kp10), iorndur, ipitbound, iscale
endop

;chrdi quick chords. koriginal holds the pfields on an event. (limit of 10 pfields)
;kintervals specifies concurrant pitches with that event.
;idbdamp reduces the p4 value as the number of notes increases. Assuming p4 is amplitude, a value of 1 reduces this by 3db every doubling of notes. Default is 0 (no reduction)
;insincr is an increment added to p1 in each generated event. Useful for tied notes. If p3 in koriginal is negative, insincr defaults to 0.01
;iautoinvert constrains pitches to pitch classes within the octaves spanned by kintervals (centred on the iautoinvert scale degree).
;For example, kintervals = array(4,6,8), and iautoinvert = 0 in a diatonic major scale, then pitches 1,4,6 are generated. Defaults to -1 (no inversion).
;uses cpstun for pitches, with scale specified by kscale (defaults to gi_CurrentScale)
opcode chrdi,0,k[]k[]oojo
koriginal[],kintervals[],idbdamp,insincr,iautoinvert,iscale xin
  ioriginal[] castarray koriginal
  iintervals[] castarray kintervals
  indx      =      0                           
  insincr = (ioriginal[2] < 0 ? 0.01 : (insincr == 1 ? 0.01 : insincr))
  iscale    =  (iscale == 0 ? gi_CurrentScale : iscale)
  ipitval = 0
  ilen lenarray iintervals
  iplen lenarray ioriginal
  ievamp = (ioriginal[3] < 0 ? ampdbfs(ioriginal[3]):ioriginal[3]) 
  iampfac = ampdbfs(log2(max(1,ilen)) * idbdamp); drop idbdamp db every doubling of instances
  idur    =  ioriginal[2]
  if (iautoinvert != -1) then
     ioctdegs = table(0,iscale)
     imininterval = minarray:i(iintervals)
     imaxinterval = maxarray:i(iintervals)
  endif
  until (indx >= ilen) do
    ipitval   =  ioriginal[4] + iintervals[indx]
    if (iautoinvert != -1) then
        ipitval = wrap(ipitval,
              (floor(imininterval / ioctdegs) * ioctdegs + iautoinvert),
              (ceil(imaxinterval / ioctdegs) * ioctdegs + iautoinvert))
    endif
    if (iplen == 5) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale)
    elseif (iplen == 6) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale), ioriginal[5]
    elseif (iplen == 7) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale), ioriginal[5], ioriginal[6]
    elseif (iplen == 8) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale), ioriginal[5], ioriginal[6], ioriginal[7]
    elseif (iplen == 9) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale), ioriginal[5], ioriginal[6], ioriginal[7], ioriginal[8]
    elseif (iplen == 10) then
      event_i     "i", ioriginal[0] + ((indx + 1) * insincr), tempodur(ioriginal[1]), tempodur(idur), ievamp*iampfac,\
                      cpstuni(ipitval,iscale), ioriginal[5], ioriginal[6], ioriginal[7], ioriginal[8], ioriginal[9]
    endif
  indx      +=        1
  od
endop


;arpi spreads notes in a chord by a time interval. 
;koriginal holds pfields of an event.
;kintervals are pitches aobve or below p5 in koriginal
;konsets are time intervals following p2 in koriginal.
;kampmults are multipliers of p4 
;ionsetfac compresses or expands the onset times of the arpeggiation. default is 1 (no compression)
;          negative ionset reduces or expands onset times throughout the duration of an arpeggiation. For example, -0.5 causes
;          an accelerando doubling tempo of notes by p3. A value of -1.5 halves the tempo. -1.0 leaves the tempo unchanged.   
;iampfac, applies a power curve to  p4 values throughout the duration of the arpeggiation.
;         positive values reduce p4 to zero (e.g. fade out).  
;         negative values increase p4 from zero to 1 (e.g. fade in).
;         Steepness of the curve increases as iampfac approaches 1 (or -1).
;         expected range is 0 to +-1, default is 0 (no modification applied).

opcode arpi, 0, k[]k[]k[]k[]iopo
  koriginal[],kintervals[],konsets[],kampmults[],idur,ievdur, ionsetfac, iampfac xin
  ioriginal[] castarray koriginal
  iintervals[] castarray kintervals
  ionsets[] castarray konsets
  iampmults[] castarray kampmults
  indx = 0
  ionce = 0

  iscale = gi_CurrentScale
  ipitval = 0

  ilen lenarray iintervals
  iamplen lenarray iampmults
  iplen lenarray ioriginal
  ionsetlength lenarray ionsets
  
  ikdur  = ioriginal[2]
  ionset = ioriginal[1]
  ionsetprogress = 0
  inextonset = 0

  ; initialise kampfac: negative values == fade in, + == fade out, 0 == no change
  iampmode = iampfac
  if (iampfac == 0) then
  iampfac = 1
  elseif (iampfac < 0) then
  iampfac = 0
  else
  iampfac = 1
  endif
    
  if (ionsetfac <= 0) then
      ikonsetfac = 1
      iaccelmode = 1
  else
      ikonsetfac = ionsetfac
      iaccelmode = 0
  endif
      
 ;;BEGIN LOOP
  until (ionset > (idur * (i(gk_tempo) / 60))) do

  ipitval   =  ioriginal[4] + iintervals[indx % ilen]

  if (ievdur == 0) then
  ikdur      =  ioriginal[2]
  elseif (ievdur > 0) then
  ikdur      =  ievdur - ionset
  else      
  inextonset   =      ionset + ionsets[(indx + 1) % ionsetlength] * ikonsetfac
  ikdur      =  inextonset - ionset
  endif
      
  iarg1 = ioriginal[0]
  iarg2 = tempodur(ionset)
  ikdur = tempodur(ikdur)  
  iarg4 = ioriginal[3]*iampfac*iampmults[indx % iamplen]
  if (iplen == 5) then
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale)
  elseif (iplen == 6) then
  iarg6 = ioriginal[5]
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale), iarg6
  elseif (iplen == 7) then
  iarg6 = ioriginal[5]
  iarg7 = ioriginal[6]
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale), iarg6, iarg7
  elseif (iplen == 8) then
  iarg6 = ioriginal[5]
  iarg7 = ioriginal[6]
  iarg8 = ioriginal[7]
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale), iarg6, iarg7, iarg8
  elseif (iplen == 9) then
  iarg6 = ioriginal[5]
  iarg7 = ioriginal[6]
  iarg8 = ioriginal[7]
  iarg9 = ioriginal[8]
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale), iarg6, iarg7, iarg8, iarg9
  elseif (iplen == 10) then
  iarg6 = ioriginal[5]
  iarg7 = ioriginal[6]
  iarg8 = ioriginal[7]
  iarg9 = ioriginal[8]
  iarg10 = ioriginal[9]
  event_i "i", iarg1, iarg2, ikdur, iarg4, cpstuni(ipitval, gi_CurrentScale), iarg6, iarg7, iarg8, iarg9,iarg10
  endif
  if (iaccelmode == 1) then
      ikonsetfac = (1 - (ionsetprogress * (1 - abs(ionsetfac))))
  endif
  ionset    =  ionset + ionsets[indx % ionsetlength] * ikonsetfac
  ionsetprogress = (tempodur(ionset)/idur)
  if (iampmode == 0) then
  iampfac = 1
  elseif (iampmode > 0) then

    if (iampmode > 0.5) then
      iampfac pow (1 - ionsetprogress), rescale(iampmode, 0, 1, 1, 5), 1
    else
      iampfac pow (1 - ionsetprogress), (iampmode * 2), 1
    endif

  else

    if (abs(iampmode) > 0.5) then
      iampfac pow ionsetprogress, rescale(abs(iampmode), 0, 1, 1, 5), 1
    else
      iampfac pow ionsetprogress, (abs(iampmode) * 2), 1
    endif

  endif
  indx      +=        1
  od

endop

;wrapper 
opcode arpi, 0, k[]k[]k[]iopo
  koriginal[],kintervals[],konsets[],idur,ievdur, ionsetfac, iampfac xin
  arpi koriginal, kintervals, konsets, array(1),idur,ievdur, ionsetfac, iampfac
endop

;;;;;;;;;;;;;;;
;;loopevent opcode
;; spawn repetitive patterns with a single line.
;; loopevent eventarray[] [,ilooptime, imode]
;; loopevent eventarray[], klooptimes[],[, imode]
;; loopevent eventarray*[], kpitches[], klooptimes[], imode]
;; eventarray holds parameter fields for a score event
;; loopevent with kpitches assumes the event uses p5 as an index into the current scale (for lookup using cpstuni).
;; imode == 0: starts and overlays additional loops
;; imode == 1: replaces running loops with new loop
;; imode == 3: Stops loops
;; Fractional instrument numbers in the event launch independant loops.
;; example
;;             event                        pitches          rhythm
;; loopevent array(12.1, 0, 1, 0.6, 0), array(0,3,6,2), array(1/4,1/8,1/8), 1  
;;;;;;;;;;;;;;;;;

;wrapper for krate arrays (because inline arrays default to krate) 
;usage
/*
ipfields[] - array containing score event pfields
ilptms[] - array with rhythm values. Negative values intepreted as rests.
ipits[] - array with pitch degrees
--- optional params
ipoly - polyphone mode. 1 == turn off previous instances default 
        >1 == don't turn off previous loops
        0 = turn off loops
        -1 = store loop parameters (no sound). 
             The instance ID can be set using fractional instrument numbers in ipfields.
itonic - pitch values transpose with gi_Tonic (default == -1, don't follow gi_Tonic)
irhgate - probability of score event being generated (default == 1, always play event)
ipitdir - direction and invrement pace reading ipits[]. -1 == read ipits backwards, 0.5 == read ipits at half speed.  
inextnsnce - instead of self-recursion, launch a stored loop set with ipoly.
inextprob - probability of launching the next instance, or self-recursing (0 - 1, default to 1). 

example: 
_cslc_loopmaster fillarray(n("Simpleosc")+0.3,0,0.7,0.2,0),fillarray(4,8),fillarray(1/2,1/4),-1,-1,1,1,4,0.5

*/
opcode _cslc_loopmaster, 0, i[]i[]i[]pjppjo
  ipfields[],ipits[],ilptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin  
  iabtms[] abs ilptms
  ilptm sumarray iabtms
  ievntinstr = ipfields[0]
  iinstance = ievntinstr * 0.001
  if frac(ievntinstr) == 0 then
     id = ievntinstr
  else
     id = strtod(strsub(sprintf("%.5g",frac(ievntinstr)),2)) ;converts decimal portion to an instance ID
  endif
  iloopins = 10
  icodestrset = -1
  ibaseArr[] fillarray iloopins + iinstance, 0, 1, ilptm, abs(ipoly), irhgate,ipitdir,itonic,icodestrset,inextnsnce,inextprob
  ibaselen lenarray ibaseArr 
  ipitlen lenarray ipits
  ilptmlen lenarray ilptms
  idividers[] fillarray ibaselen, ibaselen + ipitlen, ibaselen + ipitlen + ilptmlen
  ieventsnd[] _cslc_catarray ibaseArr, ipits, ilptms, ipfields,idividers
  Sschedchn sprintf "lpsched:%f",ieventsnd[0] 
  icurrentsched = chnget:i(Sschedchn)
  ischedtm = icurrentsched - now() - (2/kr)
  ieventsnd[2] = lenarray(ieventsnd)
  if (inextnsnce != -1) then
     printf_i "setting gi_cslc_Looprec at id %f\n",1,id
     gi_cslc_Looprec setrow ieventsnd,id
  endif
  if ischedtm < 0 then
     ieventsnd[1] = nextbeat(iabtms[0])
  else
     ieventsnd[1] = tempodur(ischedtm)
  endif
  if (ipoly == -1) then
     ;no sound
  else
     schedule ieventsnd
  endif
endop

opcode loopevent, 0, i[]ppjppjo
  ipfields[],ilptm,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ilptms[] fillarray ilptm
  ipits[] fillarray 0
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
endop

;k-rate launches the i-rate version
opcode loopevent, 0, k[]ppjppjo
  kpfields[],ilptm,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ipfields[] = kpfields
  ilptms[] fillarray ilptm
  ipits[] fillarray 0
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
  endop  

opcode loopevent, 0, i[]i[]pjppjo
  ipfields[],ilptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ipits[] fillarray 0
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
  endop

opcode loopevent, 0, k[]k[]pjppjo
  kpfields[],klptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ipfields[] = kpfields
  ilptms[] = klptms
  ipits[] fillarray 0
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
  endop


opcode loopevent, 0, k[]k[]k[]pjppjo
  kpfields[],kpits[],klptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ipfields[] = kpfields
  ipits[] = kpits
  ilptms[] = klptms
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
  endop

opcode loopevent, 0, i[]i[]i[]pjppjo
  ipfields[],ipits[],ilptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
endop

opcode loopevent, 0, k[]k[]i[]pjppjo
  kpfields[],kpits[],ilptms[],ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob xin
  ipfields[] = kpfields
  ipits[] = kpits
  _cslc_loopmaster ipfields,ipits,ilptms,ipoly,itonic,irhgate,ipitdir,inextnsnce,inextprob
  endop


;;; loop arbitrary Csound code.
;;; limited to irate code (for now).
opcode loopcode, 0, i[]iSpjo
  ilptms[],instanceid,Scode,itrig,inextnsnce,inextprob xin
  iabtms[] abs ilptms
  ilptm sumarray iabtms
  id = instanceid
  iinstance = instanceid * 0.001
  icodestrset = int(instanceid * 1000)
  strset icodestrset, Scode
  iloopins = 10
  itonic = 0
  irhgate = 1
  ipitdir = 1 
  ipits[] fillarray 0
  ipfields[] fillarray instanceid, 0, 0.1, 0,0
  ibaseArr[] fillarray iloopins + iinstance, 0, 1, ilptm, limit(abs(itrig),0,1), irhgate,ipitdir,itonic,icodestrset,inextnsnce,inextprob
  ibaselen lenarray ibaseArr
  idividers[] fillarray ibaselen, ibaselen + 1, ibaselen + 1 + lenarray:i(ilptms)
  ieventsnd[] _cslc_catarray ibaseArr, ipits, ilptms, ipfields,idividers
  Sschedchn sprintf "lpsched:%f",ieventsnd[0]
  icurrentsched = chnget:i(Sschedchn)
  ischedtm = icurrentsched - now() - (1/kr)    
  if ischedtm < 0 then
  ieventsnd[1] = nextbeat(iabtms[0])
  else
  ieventsnd[1] = ischedtm
  endif

  ieventsnd[2] = lenarray(ieventsnd)

  if (inextnsnce != -1) then
     printf_i "setting gi_cslc_Looprec at id %f\n",1,id
     gi_cslc_Looprec setrow ieventsnd,id
  endif
  if (itrig == -1) then
     ;no sound
  else
     schedule ieventsnd
  endif
endop

opcode loopcode, 0, k[]iSpjo
  klptms[],instanceid,Scode,itrig,inextnsnce,inextprob xin
  ilptms[] castarray klptms
  loopcode ilptms,instanceid,Scode,itrig,inextnsnce,inextprob
endop

opcode schedcode,0,So
Scode,itime xin
schedule 1,itime,1,Scode 
endop

;;Effect construction
opcode EffectConstruct, 0,SSiip
Sname, Seffectbody,iincount,ioutcount,ixfade xin
Snamestring sprintf "%s%s%s","\"",Sname,"\""
Sinsheader = {{
instr %s
iincount = %d
Sname = %s
gi_cslc_Destins[p1][1] = iincount
Schnames[] init iincount
indx = 0
while indx < iincount do
  Schnames[indx] = sprintf("%%s:%%d",Sname,indx)
  indx += 1
 od
ains[] chngeta Schnames
aouts[] init %d
}}

Sinsfooter = {{
aenv madsr %f,0,1,%f
aexit[] = aouts * aenv
send aexit
endin
}}

Snewheader sprintf Sinsheader, Sname, iincount,Snamestring,ioutcount
Snewfooter sprintf Sinsfooter, ixfade, ixfade
Sins1 strcat Snewheader, Seffectbody
Sinstr strcat Sins1, Snewfooter

printf_i Sinstr,1

ires compilestr Sinstr
Slaunch = {{
turnoff2_i nstrnum(%s),0,1 
schedule %s, 0, -1
}}
Slaunchstring sprintf Slaunch, Snamestring, Snamestring
ires2 compilestr Slaunchstring
endop
;;;
opcode declickr, a, ajjoj
itie tival  
ain, irisetime, idectime, itype,iinvert xin
irisetm = (irisetime == -1 ? 0.003 : irisetime)
idectm = (idectime == -1 ? 0.08 : idectime)
if (iinvert != -1) then
    aenv1   transegr itie, 0.003, 0, 1, irisetm, -itype, iinvert, 0,0,iinvert,idectm, itype, 1
    aenv2   linseg 1, abs(p3)+idectm-0.004, 1, 0.004,(p3 < 0 ? 1:0);transegr 1,0,0,1,0.08,0,0
    aenv = aenv2 * aenv1
  else
    aenv    transegr itie, irisetm, itype, 1, 0, 0, 1, idectm, itype, 0
endif
xout ain * aenv
endop


;used by schedcode
instr 1
Scode = p4
kval evalstr Scode,1
turnoff
endin

;time
instr 2
restart:
if (changed2(gk_tempo) == 1) then
   reinit restart
endif
;anow line i(ga_now), 60*(1/(i(gk_tempo)/60)),60+(i(ga_now))
;ga_now = anow
know line i(gk_now), 60*(1/(i(gk_tempo)/60)),60+(i(gk_now))
gk_now = know
endin
event_i "i", 2, 0, -1 

;used by the linslide opcode  
instr 3
Schan = p4
idest = p5
itype = p6
if (p8 == -1) then
    initval = chnget(Schan)
  else
    initval = p8
endif
if (p7 == 0) then
   iendreset = idest
else
   iendreset = initval
endif

instndx = p9

kinstance table k(instndx), gi_cslc_chanfn
  
kres transeg initval, p3 - 0.008, itype, idest, 0.008,0,iendreset
chnset kres, Schan

;need to ensure the last value is set.
kfinish init iendreset
if (timeinsts() >= p3) then
   chnset kfinish, Schan 
endif
kstop changed2 kinstance
if (kstop == 1) then
   turnoff
endif
endin

;;midi routing instrument
;;uncomment instantiation below only if MIDI is connected.
instr 4
kstatus, kchan, kdata1, kdata2 midiin
printf "kstatus= %d, kchan = %d, kdata1 = %d, kdata2=%d\n", kstatus+1, kstatus, kchan, kdata1, kdata2
kchan = (kchan == 0 ? 1 : kchan)
kins table kchan - 1, gi_midichanmap 
if (kstatus == 128 || (kstatus == 144 && kdata2 == 0)) then
    turnoff2 kins+(kdata1*0.001),4,1			
elseif (kstatus == 144) then
    kamp ampmidicurve kdata2, 1, 0.5
    event "i", kins + (kdata1 * 0.001), 0, -1, kamp, cpstun3(kdata1 - gi_midikeyref, gi_CurrentScale); may need to change 60 
else
   printf "other message ---> kstatus= %d, kchan = %d, kdata1 = %d, kdata2=%d\n", kstatus+1, kstatus, kchan, kdata1, kdata2
   ;extra stuff 
endif
endin
;only call if midi connected. Crashes otherwise
;schedule 4, 0, -1
;; A hack to predefine instrument numbers, and avoice errors in midi assignment
;;instr 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115
;; endin

;;;;;;;;;;PATCHING INSTRUMENTS;;;;;;;;;;;;;;;;
instr 5
idec = round((p1 - gi_cslc_patchsig_inum) * 10^7)
isrcnum, ichan, instnce,inull decode4 idec
   asrc = ga_cslc_PatchArr[isrcnum][ichan]
   ;asrc *= madsr(0.07,0,p5,1)
   asrc declickr asrc*p5, 0.5
   Sdest = p4 
   chnmix asrc, Sdest
iclearenc = encode4(isrcnum,ichan,0,0)
iclrenc = gi_cslc_clearsig_inum + (iclearenc / 10^7)
inotused = p6
schedule iclrenc, 0, -1    
endin

instr 6
   idec = round((p1 - gi_cslc_clearsig_inum) * 10^7)  
   isrc, ichan, inull1, inull2 decode4 idec
   ga_cslc_PatchArr[isrc][ichan] = 0
endin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Stop a performace.
instr 7
exitnow
endin

;;; called from CSDOutput.el
instr 8
Seval = strget(p4)
icompiled compilestr Seval
if (icompiled == 0) then
   printf_i "Compiled at time %f: %s\n", 1, p2, Seval
else
   printf_i "!!!Did not compile at time %f: %s\n", 1, p2, Seval
endif
endin

instr 9
;reserved  
endin


;;for the loopevent and loopcode opcodes.
instr 10
ipcnt pcount
ipArr[] passign
ival = p(ipcnt)
ipoly = ipArr[4]
kpoly = ipArr[4]
cggoto (ipoly == 0 || ipoly == 1), NEXT
itonic = ipArr[7]
icodeget = ipArr[8]
irhgate = ipArr[5]
ipitdir = ipArr[6]
inextnsnce = ipArr[9]
inextprob = ipArr[10]
if (icodeget != -1) then
   Scode strget icodeget
endif
idivider1 = ipArr[lenarray(ipArr) - 3] ; 
idivider2 = ipArr[lenarray(ipArr) - 2] ; 
idivider3 = ipArr[lenarray(ipArr) - 1] ; 
ipitarray[] slicearray ipArr, idivider1, idivider2 - 1 
ibeatArr[] slicearray ipArr, idivider2, idivider3 - 1
ischedArr[] slicearray ipArr, idivider3, lenarray(ipArr) - 4 ;
Slooprhid sprintf "rh%f", ischedArr[0]
Spitid sprintf "pit%f", ischedArr[0]
itonic = (itonic == -1 ? giTonic_ndx : itonic)
;cggoto (ipoly == 0), NEXT ;;see the cggoto earlier
if ipoly > 1 then
   ;increments the index
   if lenarray(ibeatArr) == 1 then
      ialtrh = ibeatArr[0]
   else
   ialtrh = iterArr(ibeatArr, Slooprhid)
   endif
   iabsrh abs ialtrh
   irhgatetest random 0,1
   if iabsrh <= 2/kr then
      ;do nothing
   else
      ipitdeg = iterArr(ipitarray, Spitid,ipitdir) + ischedArr[4] + itonic
      ieventArr[] = ischedArr
      ieventArr[4] = cpstuni(ipitdeg, gi_CurrentScale)
   endif
   if irhgatetest >= irhgate then
      ;no sound
   elseif ialtrh < 0 then
      ;negative rhythm is a rest
   elseif (icodeget != -1) then
      icompres evalstr Scode
   else
      schedule ieventArr
   endif
   ipArr[1] = iabsrh
   Sschedchn sprintf "lpsched:%f", ipArr[0]
   ;chnset now() + iabsrh, Sschedchn
   inexttest random 0,1
   if inextnsnce == -1 then
       irecurse[] = ipArr
   elseif inexttest >= inextprob then
       irecurse[] = ipArr
   else
       inextArr[] getrow gi_cslc_Looprec,inextnsnce
       inpcnt = inextArr[2]
       if inpcnt == 0 then
          printf_i "invalid instance found\n",1
          igoto NEXT
       else
       irecurse[] slicearray inextArr,0,inpcnt - 1
       irdiv2 = irecurse[lenarray(irecurse) - 2] ; 
       irdiv3 = irecurse[lenarray(irecurse) - 1] ; 
       irecbeats[] slicearray irecurse, irdiv2, irdiv3 - 1
       Sreclooprhid sprintf "rh%f", irecurse[irdiv3]
       irecurse[1] = irecbeats[chnget:i(Sreclooprhid) % lenarray(irecbeats)]
       endif
   endif
   irecurse[1] = nextbeat(irecurse[1])
   schedule irecurse
   chnset now() + irecurse[1], Sschedchn
endif
NEXT:
;kpoly = ipArr[4] ;already set above
if (kpoly == 1) then
    turnoff3 p1
    kpArr[] = ipArr 
    kpArr[4] = 2
    kpArr[1] = 0
    schedulek kpArr
elseif (kpoly == 0) then
   kpArr[] = ipArr 
   kpoly = 2
   turnoff3 kpArr[0]
endif
turnoff
endin

opcode beep, 0,0
schedule 302, 0, 0.1
endop

opcode clearterm,0,0
prints "\033[2J" ;clears an ansi terminal screen
endop

opcode setVUfreq, 0, i
imonfreq xin
gkVUmonitorfreq init imonfreq
endop

;output instrument
instr 299
ainL chnget "outs:0"
ainR chnget "outs:1"
gi_cslc_Destins[p1][1] = 2
aLeft compress ainL, ainL, 0, 90, 90, 100, 0.0, 0.08, 0.125
aRight compress ainR, ainR, 0, 90, 90, 100, 0.0, 0.08, 0.125
outc ainL, ainR
reclear:
Schanslice[] slicearray_i gS_cslc_channelarr, 0, gi_cslc_chntally
achanslice[] slicearray ga_cslc_channelclear, 0, gi_cslc_chntally
chnseta achanslice, Schanslice
if gk_cslc_clearupdate == 1 then
   gk_cslc_clearupdate = 0
   reinit reclear
endif
endin
schedule 299,0,-1

;Limiter and optional peak meter.
instr 301
  kreset metro gkVUmonitorfreq
  aout1, aout2 monitor ;get audio from spout
  amax maxabs aout1, aout2
  kmax peak amax
  
  ;;UNCOMMENT this printf line to see a peak meter in a terminal supporting ANSI Escape codes.
  printf "\033[1G\033[0;32m****************\033[0;33m*********\033[0;31m|***\033[0m\033[%sG\033[0K\033[25G|", kreset,sprintfk("%d",int(kmax * 25))

  if kreset == 1 then
    kmax = 0
  endif
  areplaceout1 compress aout1, amax, 0, 90, 90, 100, 0.0, 0.08, 0.125
  areplaceout2 compress aout2, amax, 0, 90, 90, 100, 0.0, 0.08, 0.125

  aout1 = areplaceout1 - aout1
  aout2 = areplaceout2 - aout2
  
outc aout1, aout2
endin

event_i "i", 301, 0, -1

;for beep opcode
instr 302
ares oscils 0.5, A4*2, 0
out ares, ares
endin
printf_i "finished loading cslc.csd %f\n", 1, 1

#ifdef SOUNDLIB
  #includestr "$SOUNDLIB"
#end

</CsInstruments>
<CsScore>
f0 z
</CsScore>
</CsoundSynthesizer>
